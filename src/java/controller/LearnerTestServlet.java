package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import common.logger.ExceptionLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import service.TestService;

import java.io.IOException;
import java.util.*;
import service.QuestionOptionService;
import service.QuestionService;

@WebServlet(name = "LearnerTestServlet", urlPatterns = {
    "/test",
    "/test/take",
    "/test/submit",
    "/test/result"
})
public class LearnerTestServlet extends HttpServlet {

    private final TestService testService = new TestService();
    private final QuestionService questionService = new QuestionService();
    private final QuestionOptionService questionOptionService = new QuestionOptionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/test/take":
                    showTakeTest(request, response);
                    break;
                case "/test/result":
                    showResult(request, response);
                    break;
                case "/test":
                default:
                    listTests(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(LearnerTestServlet.class.getName(), "doGet", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            if ("/test/submit".equals(pathInfo)) {
                submitTest(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/test");
            }
        } catch (Exception e) {
            ExceptionLogger.logError(LearnerTestServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isLearner(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.LEARNER;
    }

    private void listTests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getAttribute("currentUser");
        TargetLevel userLevel = user.getTargetLevel();

        String levelStr = request.getParameter("level");
        List<Test> tests;

        if (levelStr != null && !levelStr.isEmpty()) {
            try {
                TargetLevel selectedLevel = TargetLevel.valueOf(levelStr);
                if (selectedLevel.ordinal() <= userLevel.ordinal()) {
                    tests = testService.findAllByLevel(selectedLevel);
                    request.setAttribute("selectedLevel", levelStr);
                } else {
                    tests = testService.findTestsForUser(userLevel);
                }
            } catch (IllegalArgumentException e) {
                tests = testService.findTestsForUser(userLevel);
            }
        } else {
            tests = testService.findTestsForUser(userLevel);
        }

        Map<Integer, Integer> sectionCounts = new HashMap<>();
        for (Test test : tests) {
            sectionCounts.put(test.getId(), testService.countSectionsByTestId(test.getId()));
        }

        List<TargetLevel> availableLevels = new ArrayList<>();
        for (TargetLevel level : TargetLevel.values()) {
            availableLevels.add(level);
            if (level == userLevel) {
                break;
            }
        }

        request.setAttribute("tests", tests);
        request.setAttribute("sectionCounts", sectionCounts);
        request.setAttribute("levels", availableLevels);
        request.setAttribute("userLevel", userLevel);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/test/list.jsp").forward(request, response);
    }

    private void showTakeTest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/test");
            return;
        }

        try {
            int testId = Integer.parseInt(testIdStr);
            Test test = testService.findById(testId);

            if (test == null) {
                response.sendRedirect(request.getContextPath() + "/test");
                return;
            }

            User user = (User) request.getAttribute("currentUser");
            if (test.getLevel().ordinal() > user.getTargetLevel().ordinal()) {
                response.sendRedirect(request.getContextPath() + "/test?error=level_restricted");
                return;
            }

            List<TestSection> sections = testService.findSectionsByTestId(testId);

            // Build questions map for each section
            Map<Integer, List<Question>> sectionQuestions = new LinkedHashMap<>();
            Map<Integer, Map<Integer, List<QuestionOption>>> questionOptions = new HashMap<>();

            for (TestSection section : sections) {
                List<Question> questions = questionService.findAllBySectionId(section.getId());
                sectionQuestions.put(section.getId(), questions);

                Map<Integer, List<QuestionOption>> optionsMap = new HashMap<>();
                for (Question question : questions) {
                    optionsMap.put(question.getId(), questionOptionService.findAllByQuestionId(question.getId()));
                }
                questionOptions.put(section.getId(), optionsMap);
            }

            request.setAttribute("test", test);
            request.setAttribute("sections", sections);
            request.setAttribute("sectionQuestions", sectionQuestions);
            request.setAttribute("questionOptions", questionOptions);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/test/take.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/test");
        }
    }

    private void submitTest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getAttribute("currentUser");

        String testIdStr = request.getParameter("testId");
        String durationStr = request.getParameter("duration");

        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/test");
            return;
        }

        try {
            int testId = Integer.parseInt(testIdStr);
            Integer durationSeconds = null;
            if (durationStr != null && !durationStr.isEmpty()) {
                durationSeconds = Integer.parseInt(durationStr);
            }

            // Collect answers from form
            Map<Integer, Integer> answers = new HashMap<>();
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("question_")) {
                    try {
                        int questionId = Integer.parseInt(paramName.substring("question_".length()));
                        String optionValue = request.getParameter(paramName);
                        if (optionValue != null && !optionValue.isEmpty()) {
                            int optionId = Integer.parseInt(optionValue);
                            answers.put(questionId, optionId);
                        }
                    } catch (NumberFormatException e) {
                        // Skip invalid parameters
                    }
                }
            }

            UserTestResult result = testService.submitTest(user.getId(), testId, answers, durationSeconds);

            if (result != null) {
                response.sendRedirect(request.getContextPath() + "/test/result?resultId=" + result.getId());
            } else {
                response.sendRedirect(request.getContextPath() + "/test?error=submit_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/test");
        }
    }

    private void showResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resultIdStr = request.getParameter("resultId");
        if (resultIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/test");
            return;
        }

        try {
            int resultId = Integer.parseInt(resultIdStr);
            UserTestResult result = testService.findResultById(resultId);

            if (result == null) {
                response.sendRedirect(request.getContextPath() + "/test");
                return;
            }

            User user = (User) request.getAttribute("currentUser");
            if (!result.getUserId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }

            Test test = testService.findById(result.getTestId());
            List<UserTestSectionResult> sectionResults = testService.findSectionResultsByResultId(resultId);
            List<TestSection> sections = testService.findSectionsByTestId(result.getTestId());

            int totalMaxScore = sections.stream().mapToInt(TestSection::getTotalScore).sum();

            request.setAttribute("result", result);
            request.setAttribute("test", test);
            request.setAttribute("sectionResults", sectionResults);
            request.setAttribute("sections", sections);
            request.setAttribute("totalMaxScore", totalMaxScore);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/test/result.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/test");
        }
    }
}
