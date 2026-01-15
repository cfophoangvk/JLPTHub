package controller;

import common.constant.BaseURL;
import common.constant.Configuration;
import common.util.GoogleOAuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TargetLevel;
import service.AuthService;
import service.AuthService.AuthResult;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "AuthServlet", urlPatterns = {
    "/auth/login",
    "/auth/register",
    "/auth/logout",
    "/auth/verify-email",
    "/auth/forgot-password",
    "/auth/reset-password",
    "/auth/google",
    "/auth/google/callback"
})
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/auth/login":
                handleLoginPage(request, response);
                break;
            case "/auth/register":
                handleRegisterPage(request, response);
                break;
            case "/auth/logout":
                handleLogout(request, response);
                break;
            case "/auth/verify-email":
                handleVerifyEmail(request, response);
                break;
            case "/auth/forgot-password":
                handleForgotPasswordPage(request, response);
                break;
            case "/auth/reset-password":
                handleResetPasswordPage(request, response);
                break;
            case "/auth/google":
                handleGoogleAuth(request, response);
                break;
            case "/auth/google/callback":
                handleGoogleCallback(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/auth/login":
                handleLogin(request, response);
                break;
            case "/auth/register":
                handleRegister(request, response);
                break;
            case "/auth/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/auth/reset-password":
                handleResetPassword(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
    }

    private void handleRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp?register=true").forward(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Cookie cookie = new Cookie(Configuration.JWT_COOKIE_NAME, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        response.sendRedirect(request.getContextPath() + "/auth/login?message=logout_success");
    }

    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tokenStr = request.getParameter("token");

        if (tokenStr == null || tokenStr.isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/verifyEmail.jsp").forward(request, response);
            return;
        }

        try {
            UUID token = UUID.fromString(tokenStr);
            AuthResult result = authService.verifyEmail(token);

            if (result.isSuccess()) {
                request.setAttribute("success", result.getMessage());
            } else {
                request.setAttribute("error", result.getMessage());
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Token không hợp lệ");
        }

        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/verifyEmail.jsp").forward(request, response);
    }

    private void handleForgotPasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/forgotPassword.jsp").forward(request, response);
    }

    private void handleResetPasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tokenStr = request.getParameter("token");

        if (tokenStr == null || tokenStr.isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
        } else {
            request.setAttribute("token", tokenStr);
        }

        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
    }

    private void handleGoogleAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String authUrl = GoogleOAuthUtil.getAuthorizationUrl();
        response.sendRedirect(authUrl);
    }

    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String error = request.getParameter("error");

        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=google_cancelled");
            return;
        }

        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=google_error");
            return;
        }

        AuthResult result = authService.loginWithGoogle(code);

        if (result.isSuccess()) {
            setJwtCookie(response, result.getToken());
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/login?error="
                    + java.net.URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
            return;
        }

        AuthResult result = authService.login(email, password);

        if (result.isSuccess()) {
            setJwtCookie(response, result.getToken());
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", result.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String targetLevelStr = request.getParameter("targetLevel");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()
                || targetLevelStr == null || targetLevelStr.isEmpty() || fullName == null || fullName.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.setAttribute("isRegister", true);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            TargetLevel targetLevel = TargetLevel.valueOf(targetLevelStr);
            AuthResult result = authService.register(email, password, fullName, targetLevel);

            if (result.isSuccess()) {
                request.setAttribute("success", result.getMessage());
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", result.getMessage());
                request.setAttribute("isRegister", true);
                request.setAttribute("email", email);
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Cấp độ không hợp lệ");
            request.setAttribute("isRegister", true);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/login.jsp").forward(request, response);
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/forgotPassword.jsp").forward(request, response);
            return;
        }

        AuthResult result = authService.forgotPassword(email);

        request.setAttribute("success", result.getMessage());
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/forgotPassword.jsp").forward(request, response);
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tokenStr = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (tokenStr == null || tokenStr.isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            request.setAttribute("token", tokenStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("token", tokenStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("token", tokenStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            UUID token = UUID.fromString(tokenStr);
            AuthResult result = authService.resetPassword(token, newPassword);

            if (result.isSuccess()) {
                response.sendRedirect(request.getContextPath() + "/auth/login?success="
                        + java.net.URLEncoder.encode(result.getMessage(), "UTF-8"));
            } else {
                request.setAttribute("error", result.getMessage());
                request.setAttribute("token", tokenStr);
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/auth/resetPassword.jsp").forward(request, response);
        }
    }

    private void setJwtCookie(HttpServletResponse response, String token) {
        Cookie cookie = new Cookie(Configuration.JWT_COOKIE_NAME, token);
        cookie.setHttpOnly(true);
        cookie.setMaxAge(Configuration.COOKIE_MAX_AGE);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
