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
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminTestServlet", urlPatterns = {
    "/admin/tests",
    "/admin/tests/create",
    "/admin/tests/edit",
    "/admin/tests/delete"
})
public class AdminTestServlet extends HttpServlet {

    private final TestService testService = new TestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/admin/tests/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/tests/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/tests":
                default:
                    listTests(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminTestServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/tests/create":
                    createTest(request, response);
                    break;
                case "/admin/tests/edit":
                    updateTest(request, response);
                    break;
                case "/admin/tests/delete":
                    deleteTest(request, response);
                    break;
                case "/admin/tests":
                default:
                    listTests(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminTestServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listTests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String levelStr = request.getParameter("level");
        List<Test> tests;
        
        if (levelStr != null && !levelStr.isEmpty()) {
            try {
                TargetLevel level = TargetLevel.valueOf(levelStr);
                tests = testService.findAllByLevel(level);
                request.setAttribute("selectedLevel", levelStr);
            } catch (IllegalArgumentException e) {
                tests = testService.findAll();
            }
        } else {
            tests = testService.findAll();
        }

        // Count sections for each test
        Map<Integer, Integer> sectionCounts = new HashMap<>();
        for (Test test : tests) {
            sectionCounts.put(test.getId(), testService.countSectionsByTestId(test.getId()));
        }

        request.setAttribute("tests", tests);
        request.setAttribute("sectionCounts", sectionCounts);
        request.setAttribute("levels", TargetLevel.values());
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("levels", TargetLevel.values());
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Test test = testService.findById(id);
                if (test != null) {
                    request.setAttribute("test", test);
                    request.setAttribute("levels", TargetLevel.values());
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test/form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/tests");
    }

    private void createTest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String title = request.getParameter("title");
        String levelStr = request.getParameter("level");

        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề bài test là bắt buộc.");
            showCreateForm(request, response);
            return;
        }

        if (title.length() > 255) {
            request.setAttribute("error", "Tiêu đề không được vượt quá 255 ký tự.");
            showCreateForm(request, response);
            return;
        }

        TargetLevel level;
        try {
            level = TargetLevel.valueOf(levelStr);
        } catch (IllegalArgumentException | NullPointerException e) {
            request.setAttribute("error", "Cấp độ không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        Test test = new Test();
        test.setTitle(title.trim());
        test.setLevel(level);
        test.setCreatedAt(LocalDateTime.now());
        test.setStatus(true);

        if (testService.save(test)) {
            response.sendRedirect(request.getContextPath() + "/admin/tests?success=created");
        } else {
            request.setAttribute("error", "Không thể tạo bài test. Vui lòng thử lại.");
            showCreateForm(request, response);
        }
    }

    private void updateTest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String levelStr = request.getParameter("level");

        if (idStr == null || title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            listTests(request, response);
            return;
        }

        if (title.length() > 255) {
            request.setAttribute("error", "Tiêu đề không được vượt quá 255 ký tự.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        TargetLevel level;
        try {
            level = TargetLevel.valueOf(levelStr);
        } catch (IllegalArgumentException | NullPointerException e) {
            request.setAttribute("error", "Cấp độ không hợp lệ.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Test test = testService.findById(id);
            if (test != null) {
                test.setTitle(title.trim());
                test.setLevel(level);

                if (testService.update(test)) {
                    response.sendRedirect(request.getContextPath() + "/admin/tests?success=updated");
                } else {
                    request.setAttribute("error", "Không thể cập nhật bài test. Vui lòng thử lại.");
                    request.setAttribute("test", test);
                    request.setAttribute("levels", TargetLevel.values());
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test/form.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void deleteTest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                if (testService.delete(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin/tests?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/tests?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }
}
