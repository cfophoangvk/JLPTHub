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
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet(name = "AdminLessonGroupServlet", urlPatterns = {
    "/admin/lesson-groups",
    "/admin/lesson-groups/create",
    "/admin/lesson-groups/edit",
    "/admin/lesson-groups/delete"
})
public class AdminLessonGroupServlet extends HttpServlet {

    private final LessonGroupService groupService = new LessonGroupService();
    private final LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/admin/lesson-groups/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/lesson-groups/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/lesson-groups":
                default:
                    listGroups(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminLessonGroupServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/lesson-groups/create":
                    createGroup(request, response);
                    break;
                case "/admin/lesson-groups/edit":
                    updateGroup(request, response);
                    break;
                case "/admin/lesson-groups/delete":
                    deleteGroup(request, response);
                    break;
                case "/admin/lesson-groups":
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminLessonGroupServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listGroups(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<LessonGroup> groups = groupService.findAll();
        List<UUID> groupIds = groups.stream().map(group -> group.getId()).collect(Collectors.toList());
        
        Map<UUID, Integer> lessonCounts = lessonService.countLessonsByGroups(groupIds);
        
        request.setAttribute("groups", groups);
        request.setAttribute("lessonCounts", lessonCounts);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson-group/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson-group/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            LessonGroup group = groupService.findById(UUID.fromString(idStr));
            request.setAttribute("group", group);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/lesson-group/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void createGroup(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String levelStr = request.getParameter("level");
        String orderIndexStr = request.getParameter("orderIndex");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên nhóm bài học là bắt buộc.");
            showCreateForm(request, response);
            return;
        }

        if (levelStr == null || levelStr.isEmpty()) {
            request.setAttribute("error", "Cấp độ là bắt buộc.");
            showCreateForm(request, response);
            return;
        }

        int orderIndex = 0;
        if (orderIndexStr != null && !orderIndexStr.isEmpty()) {
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Thứ tự phải là số.");
                showCreateForm(request, response);
                return;
            }
        }

        LessonGroup group = new LessonGroup();
        group.setId(UUID.randomUUID());
        group.setName(name.trim());
        group.setLevel(TargetLevel.valueOf(levelStr));
        group.setOrderIndex(orderIndex);

        if (groupService.save(group)) {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups?success=created");
        } else {
            request.setAttribute("error", "Không thể tạo nhóm bài học. Vui lòng thử lại.");
            showCreateForm(request, response);
        }
    }

    private void updateGroup(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String levelStr = request.getParameter("level");
        String orderIndexStr = request.getParameter("orderIndex");

        if (idStr == null || name == null || name.trim().isEmpty() || levelStr == null || levelStr.isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            listGroups(request, response);
            return;
        }

        int orderIndex = 0;
        if (orderIndexStr != null && !orderIndexStr.isEmpty()) {
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Thứ tự phải là số.");
                request.setAttribute("group", groupService.findById(UUID.fromString(idStr)));
                showEditForm(request, response);
                return;
            }
        }

        LessonGroup group = groupService.findById(UUID.fromString(idStr));
        if (group != null) {
            group.setName(name.trim());
            group.setLevel(TargetLevel.valueOf(levelStr));
            group.setOrderIndex(orderIndex);

            if (groupService.update(group)) {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups?success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật nhóm bài học. Vui lòng thử lại.");
                request.setAttribute("group", group);
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void deleteGroup(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            if (groupService.delete(UUID.fromString(idStr))) {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }
}
