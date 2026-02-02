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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminQuestionServlet", urlPatterns = {
    "/admin/questions",
    "/admin/questions/create",
    "/admin/questions/edit",
    "/admin/questions/delete"
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
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/form.jsp").forward(request, response);
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
                    request.setAttribute("question", question);
                    request.setAttribute("test", test);
                    request.setAttribute("section", section);
                    request.setAttribute("sectionId", String.valueOf(question.getSectionId()));
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/tests");
    }

    private void createQuestion(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String sectionIdStr = request.getParameter("sectionId");
        String content = request.getParameter("content");
        Part imagePart = request.getPart("image");

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

        String imageUrl = cloudinaryService.uploadImage(imagePart);

        Question question = new Question();
        question.setSectionId(sectionId);
        question.setContent(content.trim());
        question.setImageUrl(imageUrl);

        if (questionService.save(question)) {
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
            question.setContent(content.trim());

            String imageUrl = cloudinaryService.uploadImage(imagePart);
            if (imageUrl != null) {
                question.setImageUrl(imageUrl);
            } else {
                question.setImageUrl(existingImageUrl);
            }

            if (questionService.update(question)) {
                response.sendRedirect(request.getContextPath() + "/admin/questions?sectionId=" + question.getSectionId() + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật câu hỏi. Vui lòng thử lại.");
                request.setAttribute("question", question);
                request.setAttribute("sectionId", String.valueOf(question.getSectionId()));
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/question/form.jsp").forward(request, response);
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
