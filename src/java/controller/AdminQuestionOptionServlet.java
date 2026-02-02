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

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminQuestionOptionServlet", urlPatterns = {
    "/admin/question-options",
    "/admin/question-options/create",
    "/admin/question-options/edit",
    "/admin/question-options/delete"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB for images
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AdminQuestionOptionServlet extends HttpServlet {

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
                case "/admin/question-options/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/question-options/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/question-options":
                default:
                    listOptions(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminQuestionOptionServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/question-options/create":
                    createOption(request, response);
                    break;
                case "/admin/question-options/edit":
                    updateOption(request, response);
                    break;
                case "/admin/question-options/delete":
                    deleteOption(request, response);
                    break;
                case "/admin/question-options":
                default:
                    listOptions(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminQuestionOptionServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listOptions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String questionIdStr = request.getParameter("questionId");
        if (questionIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdStr);
            Question question = questionService.findById(questionId);
            TestSection section = sectionService.findById(question.getSectionId());
            Test test = testService.findById(section.getTestId());
            List<QuestionOption> options = optionService.findAllByQuestionId(questionId);

            request.setAttribute("test", test);
            request.setAttribute("section", section);
            request.setAttribute("question", question);
            request.setAttribute("options", options);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question-option/list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String questionIdStr = request.getParameter("questionId");
        if (questionIdStr != null) {
            try {
                int questionId = Integer.parseInt(questionIdStr);
                Question question = questionService.findById(questionId);
                TestSection section = sectionService.findById(question.getSectionId());
                Test test = testService.findById(section.getTestId());
                request.setAttribute("test", test);
                request.setAttribute("section", section);
                request.setAttribute("question", question);
                request.setAttribute("questionId", questionIdStr);
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question-option/form.jsp").forward(request, response);
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
                QuestionOption option = optionService.findById(id);
                if (option != null) {
                    Question question = questionService.findById(option.getQuestionId());
                    TestSection section = sectionService.findById(question.getSectionId());
                    Test test = testService.findById(section.getTestId());
                    request.setAttribute("option", option);
                    request.setAttribute("test", test);
                    request.setAttribute("section", section);
                    request.setAttribute("question", question);
                    request.setAttribute("questionId", String.valueOf(option.getQuestionId()));
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question-option/form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/tests");
    }

    private void createOption(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String questionIdStr = request.getParameter("questionId");
        String content = request.getParameter("content");
        String isCorrectStr = request.getParameter("isCorrect");
        Part imagePart = request.getPart("image");

        if (questionIdStr == null || questionIdStr.isEmpty()) {
            request.setAttribute("error", "Câu hỏi không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        // Content can be empty if there's an image
        boolean hasContent = content != null && !content.trim().isEmpty();
        boolean hasImage = imagePart != null && imagePart.getSize() > 0;
        
        if (!hasContent && !hasImage) {
            request.setAttribute("error", "Nội dung câu trả lời hoặc hình ảnh là bắt buộc.");
            request.setAttribute("questionId", questionIdStr);
            showCreateForm(request, response);
            return;
        }

        int questionId;
        try {
            questionId = Integer.parseInt(questionIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Câu hỏi không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        String imageUrl = cloudinaryService.uploadImage(imagePart);

        QuestionOption option = new QuestionOption();
        option.setQuestionId(questionId);
        option.setContent(hasContent ? content.trim() : null);
        option.setImageUrl(imageUrl);
        option.setCorrect("on".equals(isCorrectStr) || "true".equals(isCorrectStr));

        if (optionService.save(option)) {
            response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + questionIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Không thể tạo câu trả lời. Vui lòng thử lại.");
            request.setAttribute("questionId", questionIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateOption(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String questionIdStr = request.getParameter("questionId");
        String content = request.getParameter("content");
        String isCorrectStr = request.getParameter("isCorrect");
        String existingImageUrl = request.getParameter("existingImageUrl");
        Part imagePart = request.getPart("image");

        if (idStr == null) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            if (questionIdStr != null) {
                listOptions(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
            return;
        }

        // Content can be empty if there's an image
        boolean hasContent = content != null && !content.trim().isEmpty();
        boolean hasNewImage = imagePart != null && imagePart.getSize() > 0;
        boolean hasExistingImage = existingImageUrl != null && !existingImageUrl.trim().isEmpty();
        
        if (!hasContent && !hasNewImage && !hasExistingImage) {
            request.setAttribute("error", "Nội dung câu trả lời hoặc hình ảnh là bắt buộc.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Câu trả lời không hợp lệ.");
            listOptions(request, response);
            return;
        }

        QuestionOption option = optionService.findById(id);
        if (option != null) {
            option.setContent(hasContent ? content.trim() : null);
            option.setCorrect("on".equals(isCorrectStr) || "true".equals(isCorrectStr));

            String imageUrl = cloudinaryService.uploadImage(imagePart);
            if (imageUrl != null) {
                option.setImageUrl(imageUrl);
            } else {
                option.setImageUrl(existingImageUrl);
            }

            if (optionService.update(option)) {
                response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + option.getQuestionId() + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật câu trả lời. Vui lòng thử lại.");
                request.setAttribute("option", option);
                request.setAttribute("questionId", String.valueOf(option.getQuestionId()));
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question-option/form.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void deleteOption(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String questionIdStr = request.getParameter("questionId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                if (optionService.delete(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + questionIdStr + "&success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + questionIdStr + "&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + questionIdStr);
            }
        } else {
            if (questionIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/admin/question-options?questionId=" + questionIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        }
    }
}
