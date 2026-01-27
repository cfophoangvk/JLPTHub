package controller;

import common.constant.BaseURL;
import common.constant.Configuration;
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
import java.util.UUID;

@WebServlet(name = "AdminLessonServlet", urlPatterns = {
    "/admin/lessons",
    "/admin/lessons/create",
    "/admin/lessons/edit",
    "/admin/lessons/delete"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 100, // 100MB
        maxRequestSize = 1024 * 1024 * 120 // 120MB
)
public class AdminLessonServlet extends HttpServlet {

    private final LessonGroupService groupService = new LessonGroupService();
    private final LessonService lessonService = new LessonService();
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
                case "/admin/lessons/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/lessons/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/lessons":
                default:
                    listLessons(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminLessonServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/lessons/create":
                    createLesson(request, response);
                    break;
                case "/admin/lessons/edit":
                    updateLesson(request, response);
                    break;
                case "/admin/lessons/delete":
                    deleteLesson(request, response);
                    break;
                case "/admin/lessons":
                default:
                    listLessons(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminLessonServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listLessons(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            return;
        }

        UUID groupId = UUID.fromString(groupIdStr);
        LessonGroup group = groupService.findById(groupId);
        List<Lesson> lessons = lessonService.findAllByGroupId(groupId);

        request.setAttribute("group", group);
        request.setAttribute("lessons", lessons);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr != null) {
            LessonGroup group = groupService.findById(UUID.fromString(groupIdStr));
            request.setAttribute("group", group);
            request.setAttribute("groupId", groupIdStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Lesson lesson = lessonService.findById(UUID.fromString(idStr));
            if (lesson != null) {
                LessonGroup group = groupService.findById(lesson.getGroupId());
                request.setAttribute("lesson", lesson);
                request.setAttribute("group", group);
                request.setAttribute("groupId", lesson.getGroupId().toString());
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson/form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void createLesson(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String groupIdStr = request.getParameter("groupId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String contentHtml = request.getParameter("contentHtml");
        String orderIndexStr = request.getParameter("orderIndex");
        Part audioPart = request.getPart("audio");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            request.setAttribute("error", "Nhóm bài học không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề bài học là bắt buộc.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
            return;
        }

        if (title.length() > 150) {
            request.setAttribute("error", "Tiêu đề không được vượt quá 150 ký tự.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
            return;
        }

        if (audioPart != null && audioPart.getSize() > 0 && audioPart.getSize() > Configuration.MAX_AUDIO_SIZE) {
            request.setAttribute("error", "File audio không được vượt quá 100MB.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
            return;
        }

        int orderIndex = 0;
        if (orderIndexStr != null && !orderIndexStr.isEmpty()) {
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Thứ tự phải là số.");
                request.setAttribute("groupId", groupIdStr);
                showCreateForm(request, response);
                return;
            }
        }

        String audioUrl = cloudinaryService.uploadAudio(audioPart, BaseURL.CLOUDINARY_LESSON_FOLDER);

        Lesson lesson = new Lesson();
        lesson.setId(UUID.randomUUID());
        lesson.setGroupId(UUID.fromString(groupIdStr));
        lesson.setTitle(title.trim());
        lesson.setDescription(description != null ? description.trim() : null);
        lesson.setAudioUrl(audioUrl);
        lesson.setContentHtml(contentHtml);
        lesson.setOrderIndex(orderIndex);

        if (lessonService.save(lesson)) {
            response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Không thể tạo bài học. Vui lòng thử lại.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateLesson(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String groupIdStr = request.getParameter("groupId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String contentHtml = request.getParameter("contentHtml");
        String orderIndexStr = request.getParameter("orderIndex");
        String existingAudioUrl = request.getParameter("existingAudioUrl");
        Part audioPart = request.getPart("audio");

        if (idStr == null || title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            if (groupIdStr != null) {
                listLessons(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
            return;
        }

        if (title.length() > 150) {
            request.setAttribute("error", "Tiêu đề không được vượt quá 150 ký tự.");
            Lesson lesson = lessonService.findById(UUID.fromString(idStr));
            request.setAttribute("lesson", lesson);
            request.setAttribute("groupId", groupIdStr);
            showEditForm(request, response);
            return;
        }

        if (audioPart != null && audioPart.getSize() > 0 && audioPart.getSize() > Configuration.MAX_AUDIO_SIZE) {
            request.setAttribute("error", "File audio không được vượt quá 100MB.");
            Lesson lesson = lessonService.findById(UUID.fromString(idStr));
            request.setAttribute("lesson", lesson);
            request.setAttribute("groupId", groupIdStr);
            showEditForm(request, response);
            return;
        }

        int orderIndex = 0;
        if (orderIndexStr != null && !orderIndexStr.isEmpty()) {
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Thứ tự phải là số.");
                Lesson lesson = lessonService.findById(UUID.fromString(idStr));
                request.setAttribute("lesson", lesson);
                request.setAttribute("groupId", groupIdStr);
                showEditForm(request, response);
                return;
            }
        }

        Lesson lesson = lessonService.findById(UUID.fromString(idStr));
        if (lesson != null) {
            lesson.setTitle(title.trim());
            lesson.setDescription(description != null ? description.trim() : null);
            lesson.setContentHtml(contentHtml);
            lesson.setOrderIndex(orderIndex);

            String audioUrl = cloudinaryService.uploadAudio(audioPart, BaseURL.CLOUDINARY_LESSON_FOLDER);
            if (audioUrl != null) {
                lesson.setAudioUrl(audioUrl);
            } else {
                lesson.setAudioUrl(existingAudioUrl);
            }

            if (lessonService.update(lesson)) {
                response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật bài học. Vui lòng thử lại.");
                request.setAttribute("lesson", lesson);
                request.setAttribute("groupId", groupIdStr);
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr);
        }
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String groupIdStr = request.getParameter("groupId");
        if (idStr != null) {
            if (lessonService.delete(UUID.fromString(idStr))) {
                response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr + "&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr + "&error=delete_failed");
            }
        } else {
            if (groupIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/admin/lessons?groupId=" + groupIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
        }
    }
}
