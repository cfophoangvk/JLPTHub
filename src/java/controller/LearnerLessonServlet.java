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
import service.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;
import service.GrammarPointService;
import service.LessonGroupService;
import service.LessonService;

@WebServlet(name = "LearnerLessonServlet", urlPatterns = {
    "/lesson",
    "/lesson/group",
    "/lesson/study",
    "/lesson/complete"
})
public class LearnerLessonServlet extends HttpServlet {

    private final LessonGroupService groupService = new LessonGroupService();
    private final LessonService lessonService = new LessonService();
    private final GrammarPointService grammarPointService = new GrammarPointService();
    private final UserLessonProgressService progressService = new UserLessonProgressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/lesson/group":
                viewGroupDetail(request, response);
                break;
            case "/lesson/study":
                showStudyPage(request, response);
                break;
            case "/lesson":
            default:
                listLessonGroups(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            sendJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "{\"error\": \"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getServletPath();
        if ("/lesson/complete".equals(pathInfo)) {
            markLessonComplete(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isLearner(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.LEARNER;
    }

    private User getCurrentUser(HttpServletRequest request) {
        return (User) request.getAttribute("currentUser");
    }

    // Danh sách nhóm bài học theo level của user
    private void listLessonGroups(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = getCurrentUser(request);

        List<LessonGroup> groups = groupService.findFromN5LevelTo(user.getTargetLevel());
        List<UUID> groupIds = groups.stream().map(group -> group.getId()).collect(Collectors.toList());

        // Tính số bài học và tiến trình cho mỗi nhóm
        Map<UUID, Integer> lessonCounts = lessonService.countLessonsByGroups(groupIds);
        Map<UUID, Integer> completedCounts = progressService.countCompletedByGroups(user.getId(), groupIds);

        request.setAttribute("groups", groups);
        request.setAttribute("lessonCounts", lessonCounts);
        request.setAttribute("completedCounts", completedCounts);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/lesson/list.jsp").forward(request, response);
    }

    // Chi tiết nhóm - danh sách bài học trong nhóm
    private void viewGroupDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("id");
        if (groupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/lesson");
            return;
        }

        User user = getCurrentUser(request);
        UUID groupId = UUID.fromString(groupIdStr);

        LessonGroup group = groupService.findById(groupId);
        if (group == null) {
            response.sendRedirect(request.getContextPath() + "/lesson");
            return;
        }

        List<Lesson> lessons = lessonService.findAllByGroupId(groupId);

        // Lấy trạng thái hoàn thành của từng bài
        Set<UUID> completedLessonIds = progressService.findCompletedLessonsByGroup(user.getId(), groupId);

        request.setAttribute("group", group);
        request.setAttribute("lessons", lessons);
        request.setAttribute("completedLessonIds", completedLessonIds);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/lesson/detail.jsp").forward(request, response);
    }

    // Màn hình học bài
    private void showStudyPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lessonIdStr = request.getParameter("id");
        if (lessonIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/lesson");
            return;
        }

        User user = getCurrentUser(request);
        UUID lessonId = UUID.fromString(lessonIdStr);

        Lesson lesson = lessonService.findById(lessonId);
        if (lesson == null) {
            response.sendRedirect(request.getContextPath() + "/lesson");
            return;
        }

        LessonGroup group = groupService.findById(lesson.getGroupId());
        List<Lesson> allLessonsInGroup = lessonService.findAllByGroupId(lesson.getGroupId());
        List<GrammarPoint> grammarPoints = grammarPointService.findAllByLessonId(lessonId);

        // Tìm bài tiếp theo
        Lesson nextLesson = null;
        for (int i = 0; i < allLessonsInGroup.size(); i++) {
            if (allLessonsInGroup.get(i).getId().equals(lessonId) && i + 1 < allLessonsInGroup.size()) {
                nextLesson = allLessonsInGroup.get(i + 1);
                break;
            }
        }

        // Lấy trạng thái hoàn thành
        Set<UUID> completedLessonIds = progressService.findCompletedLessonsByGroup(user.getId(), lesson.getGroupId());

        boolean isCurrentCompleted = completedLessonIds.contains(lessonId);

        request.setAttribute("lesson", lesson);
        request.setAttribute("group", group);
        request.setAttribute("allLessons", allLessonsInGroup);
        request.setAttribute("grammarPoints", grammarPoints);
        request.setAttribute("nextLesson", nextLesson);
        request.setAttribute("completedLessonIds", completedLessonIds);
        request.setAttribute("isCurrentCompleted", isCurrentCompleted);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/lesson/study.jsp").forward(request, response);
    }

    // Đánh dấu hoàn thành bài học (AJAX)
    private void markLessonComplete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null) {
            sendJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, "{\"error\": \"lessonId is required\"}");
            return;
        }

        try {
            User user = getCurrentUser(request);
            UUID lessonId = UUID.fromString(lessonIdStr);

            boolean success = progressService.markCompleted(user.getId(), lessonId);

            if (success) {
                sendJsonResponse(response, HttpServletResponse.SC_OK, "{\"success\": true}");
            } else {
                sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "{\"error\": \"Failed to mark lesson as complete\"}");
            }
        } catch (Exception e) {
            ExceptionLogger.logError(LearnerLessonServlet.class.getName(), "markLessonComplete",
                    "Error marking lesson complete: " + e.getMessage());
            sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"error\": \"An error occurred\"}");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(json);
            out.flush();
        }
    }
}
