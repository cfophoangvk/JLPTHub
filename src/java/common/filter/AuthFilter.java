package common.filter;

import common.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;
import model.User;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthFilter.class.getName());
    private static final String JWT_COOKIE_NAME = "jwt_token";
    private static final String AUTH_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    //URL đặc biệt không cần xác thực (bỏ qua việc filter)
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/auth/login",
            "/auth/register",
            "/auth/forgot-password",
            "/auth/reset-password",
            "/auth/verify-email",
            "/auth/google",
            "/auth/google/callback",
            "/home",
            "/assets"
    );

    private UserService userService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userService = new UserService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();
        String contextPath = httpRequest.getContextPath();

        if (isPublicUrl(path)) {
            User user = getUserFromRequest(httpRequest);
            if (user != null) {
                httpRequest.setAttribute("currentUser", user);
            }
            chain.doFilter(request, response);
            return;
        }

        String token = getTokenFromRequest(httpRequest);

        if (token == null || !JwtUtil.validateToken(token)) {
            if (isApiRequest(httpRequest)) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.getWriter().write("{\"error\": \"Unauthorized\"}");
            } else {
                httpResponse.sendRedirect(contextPath + "/auth/login");
            }
            return;
        }

        User user = getUserFromRequest(httpRequest);
        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/auth/login");
            return;
        }

        httpRequest.setAttribute("currentUser", user);
        chain.doFilter(request, response);
    }

    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.equals(publicUrl) || path.startsWith(publicUrl + "/") || path.startsWith(publicUrl + "?")) {
                return true;
            }
        }
        return false;
    }

    private boolean isApiRequest(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        return accept != null && accept.contains("application/json");
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (JWT_COOKIE_NAME.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }

        String authHeader = request.getHeader(AUTH_HEADER);
        if (authHeader != null && authHeader.startsWith(BEARER_PREFIX)) {
            return authHeader.substring(BEARER_PREFIX.length());
        }

        return null;
    }

    private User getUserFromRequest(HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        if (token == null || !JwtUtil.validateToken(token)) {
            return null;
        }

        UUID userId = JwtUtil.getUserIdFromToken(token);
        if (userId == null) {
            return null;
        }

        try {
            return userService.getUserById(userId);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting user from token", e);
            return null;
        }
    }
}
