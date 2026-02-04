package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import common.logger.ExceptionLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.*;
import service.*;
import com.google.gson.Gson;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "AdminQuestionServlet", urlPatterns = {
    "/admin/questions",
    "/admin/questions/create",
    "/admin/questions/edit",
    "/admin/questions/delete",
    "/admin/questions/detail"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB for images
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AdminQuestionServlet extends HttpServlet {

    private final TestSectionService sectionService = new TestSectionService();
    private final TestService testService = new TestService();
    private final QuestionService questionService = new QuestionService();
    private final QuestionOptionService optionService = new QuestionOptionService();
    private final CloudinaryService cloudinaryService = new CloudinaryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/admin/questions/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/questions/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/questions/detail":
                    getQuestionDetails(request, response);
                    break;
                case "/admin/questions":
                default:
                    listQuestions(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "doGet", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/admin/questions/create":
                    createQuestion(request, response);
                    break;
                case "/admin/questions/edit":
                    updateQuestion(request, response);
                    break;
                case "/admin/questions/delete":
                    deleteQuestion(request, response);
                    break;
                case "/admin/questions":
                default:
                    listQuestions(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionIdStr = request.getParameter("sectionId");
        if (sectionIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
            return;
        }

        try {
            int sectionId = Integer.parseInt(sectionIdStr);
            TestSection section = sectionService.findById(sectionId);
            Test test = testService.findById(section.getTestId());
            List<Question> questions = questionService.findAllBySectionId(sectionId);

            // Count options for each question
            Map<Integer, Integer> optionCounts = new HashMap<>();
            for (Question question : questions) {
                optionCounts.put(question.getId(), questionService.countOptionsByQuestionId(question.getId()));
            }

            request.setAttribute("test", test);
            request.setAttribute("section", section);
            request.setAttribute("questions", questions);
            request.setAttribute("optionCounts", optionCounts);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionIdStr = request.getParameter("sectionId");
        if (sectionIdStr != null) {
            try {
                int sectionId = Integer.parseInt(sectionIdStr);
                TestSection section = sectionService.findById(sectionId);
                Test test = testService.findById(section.getTestId());
                request.setAttribute("test", test);
                request.setAttribute("section", section);
                request.setAttribute("sectionId", sectionIdStr);
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/add-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Question question = questionService.findById(id);
                if (question != null) {
                    TestSection section = sectionService.findById(question.getSectionId());
                    Test test = testService.findById(section.getTestId());
                    List<QuestionOption> options = optionService.findAllByQuestionId(id);
                    request.setAttribute("question", question);
                    request.setAttribute("options", options);
                    request.setAttribute("test", test);
                    request.setAttribute("section", section);
                    request.setAttribute("sectionId", String.valueOf(question.getSectionId()));
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/edit-form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "showEditForm", "Invalid question id!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/tests");
    }

    private void getQuestionDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Question question = questionService.findById(id);
                if (question != null) {
                    List<QuestionOption> options = optionService.findAllByQuestionId(id);
                    
                    Map<String, Object> data = new HashMap<>();
                    data.put("question", question);
                    data.put("options", options);
                    
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    
                    Gson gson = new Gson();
                    String json = gson.toJson(data);
                    
                    try (PrintWriter out = response.getWriter()) {
                        out.print(json);
                        out.flush();
                    }
                    return;
                }
            } catch (NumberFormatException e) {
                ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "getQuestionDetails", "Invalid question id!");
            }
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"error\": \"Question not found\"}");
    }

    //Tạo câu hỏi -> tạo luôn câu trả lời
    private void createQuestion(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String sectionIdStr = request.getParameter("sectionId");
        String content = request.getParameter("content");
        Part imagePart = request.getPart("image");
        ArrayList<String> answerIsCorrectIndexes = new ArrayList<>(Arrays.asList(request.getParameterValues("answerIsCorrect")));
        String[] answerContents = request.getParameterValues("answerContent");
        Collection<Part> answerImageParts = request.getParts().stream().filter(p -> p.getName().contains("answerImage")).collect(Collectors.toCollection(ArrayList::new));

        if (answerIsCorrectIndexes.isEmpty()) {
            request.setAttribute("error", "Không có câu trả lời đúng!");
            showCreateForm(request, response);
            return;
        }

        if (sectionIdStr == null || sectionIdStr.isEmpty()) {
            request.setAttribute("error", "Phần thi không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Nội dung câu hỏi là bắt buộc.");
            request.setAttribute("sectionId", sectionIdStr);
            showCreateForm(request, response);
            return;
        }

        int sectionId;
        try {
            sectionId = Integer.parseInt(sectionIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Phần thi không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        //upload ảnh lên cloud
        String questionImageUrl = cloudinaryService.uploadImage(imagePart, BaseURL.CLOUDINARY_TEST_FOLDER);
        ArrayList<String> answerImageUrls = new ArrayList<>();
        for (Part answerImagePart : answerImageParts) {
            if (!answerImagePart.getSubmittedFileName().isEmpty()) {
                String answerImageUrl = cloudinaryService.uploadImage(answerImagePart, BaseURL.CLOUDINARY_TEST_FOLDER);
                answerImageUrls.add(answerImageUrl);
            } else {
                answerImageUrls.add(null);
            }
        }

        ArrayList<QuestionOption> questionOptions = new ArrayList<>();
        for (int i = 0; i < answerContents.length; i++) {
            QuestionOption qo = new QuestionOption();
            qo.setContent(answerContents[i]);
            qo.setImageUrl(answerImageUrls.get(i));

            if (answerIsCorrectIndexes.contains(String.valueOf(i))) {
                qo.setCorrect(true);
            } else {
                qo.setCorrect(false);
            }

            questionOptions.add(qo);
        }

        Question question = new Question();
        question.setSectionId(sectionId);
        question.setContent(content.trim());
        question.setImageUrl(questionImageUrl);

        if (questionService.save(question, questionOptions)) {
            response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + sectionIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Không thể tạo câu hỏi. Vui lòng thử lại.");
            request.setAttribute("sectionId", sectionIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String sectionIdStr = request.getParameter("sectionId");
        String content = request.getParameter("content");
        String existingImageUrl = request.getParameter("existingImageUrl");
        Part imagePart = request.getPart("image");

        String[] optionIds = request.getParameterValues("optionId");
        String[] answerContents = request.getParameterValues("answerContent");
        String[] existingOptionImageUrls = request.getParameterValues("existingOptionImageUrl");
        String deletedOptionIdsStr = request.getParameter("deletedOptionIds");
        ArrayList<String> answerIsCorrectIndexes = new ArrayList<>();
        String[] correctValues = request.getParameterValues("answerIsCorrect");
        if (correctValues != null) {
            answerIsCorrectIndexes.addAll(Arrays.asList(correctValues));
        }
        Collection<Part> answerImageParts = request.getParts().stream()
                .filter(p -> p.getName().equals("answerImage"))
                .collect(Collectors.toCollection(ArrayList::new));

        if (idStr == null || content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            if (sectionIdStr != null) {
                listQuestions(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Câu hỏi không hợp lệ.");
            listQuestions(request, response);
            return;
        }

        Question question = questionService.findById(id);
        if (question != null) {
            // Update question content and image
            question.setContent(content.trim());

            String imageUrl = cloudinaryService.uploadImage(imagePart, BaseURL.CLOUDINARY_TEST_FOLDER);
            if (imageUrl != null) {
                question.setImageUrl(imageUrl);
            } else {
                question.setImageUrl(existingImageUrl);
            }

            boolean questionUpdated = questionService.update(question);

            // Xóa đáp án cũ
            if (deletedOptionIdsStr != null && !deletedOptionIdsStr.trim().isEmpty()) {
                String[] deletedIds = deletedOptionIdsStr.split(",");
                for (String deletedId : deletedIds) {
                    try {
                        int optionId = Integer.parseInt(deletedId.trim());
                        optionService.delete(optionId);
                    } catch (NumberFormatException e) {
                        ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "updateQuestion", "Error deleting option: " + e.getMessage());
                    }
                }
            }

            // Thêm/Sửa đáp án mới
            if (optionIds != null && answerContents != null) {
                List<Part> imagePartsList = new ArrayList<>(answerImageParts);

                for (int i = 0; i < optionIds.length; i++) {
                    String optionIdStr = optionIds[i];
                    String optContent = answerContents[i];
                    String existingOptImageUrl = (existingOptionImageUrls != null && i < existingOptionImageUrls.length) ? existingOptionImageUrls[i] : null;
                    Part optImagePart = (i < imagePartsList.size()) ? imagePartsList.get(i) : null;
                    boolean isCorrect = answerIsCorrectIndexes.contains(String.valueOf(i));

                    String optImageUrl = optionService.getUpdatedImageUrl(optImagePart, existingOptImageUrl);

                    if ("new".equals(optionIdStr)) {
                        // Create new option
                        QuestionOption newOption = new QuestionOption();
                        newOption.setQuestionId(id);
                        newOption.setContent(optContent);
                        newOption.setImageUrl(optImageUrl);
                        newOption.setCorrect(isCorrect);
                        optionService.save(newOption);
                    } else {
                        // Update existing option
                        try {
                            int existingOptionId = Integer.parseInt(optionIdStr);
                            QuestionOption existingOption = optionService.findById(existingOptionId);
                            if (existingOption != null) {
                                existingOption.setContent(optContent);
                                existingOption.setImageUrl(optImageUrl);
                                existingOption.setCorrect(isCorrect);
                                optionService.update(existingOption);
                            }
                        } catch (NumberFormatException e) {
                            ExceptionLogger.logError(AdminQuestionServlet.class.getName(), "updateQuestion", "Error updating option: " + e.getMessage());
                        }
                    }
                }
            }

            if (questionUpdated) {
                response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + question.getSectionId() + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật câu hỏi. Vui lòng thử lại.");
                request.setAttribute("question", question);
                request.setAttribute("sectionId", String.valueOf(question.getSectionId()));
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/edit-form.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String sectionIdStr = request.getParameter("sectionId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                if (questionService.delete(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + sectionIdStr + "&success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + sectionIdStr + "&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + sectionIdStr);
            }
        } else {
            if (sectionIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + sectionIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        }
    }
}
