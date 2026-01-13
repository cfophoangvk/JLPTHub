package controller;

import common.constant.BaseURL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;
import java.util.UUID;
import model.TargetLevel;
import service.UserService;

@WebServlet(name = "UserServlet", urlPatterns = {"/user/profile"})
public class UserServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/user/profile":
                handleProfilePage(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/user/profile":
                handleUpdateProfile(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleProfilePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // User is already set by AuthFilter
        User currentUser = (User) request.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/user/profile.jsp").forward(request, response);
    }
    
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UUID id = UUID.fromString(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        TargetLevel targetLevel = TargetLevel.valueOf(request.getParameter("targetLevel"));
        
        User user = userService.updateProfile(id, fullName, targetLevel);
        if (user != null) {
            request.setAttribute("success", "Thành công");
        }else {
            request.setAttribute("error", "Lỗi");
        }
        
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/user/profile.jsp").forward(request, response);
    }
}
