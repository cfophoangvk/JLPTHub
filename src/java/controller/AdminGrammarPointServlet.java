package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import common.logger.ExceptionLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GrammarPoint;
import model.Lesson;
import model.User;
import repository.GrammarPointRepository;
import repository.LessonRepository;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminGrammarPointServlet", urlPatterns = {
    "/admin/grammar-points",
    "/admin/grammar-points/create",
    "/admin/grammar-points/edit",
    "/admin/grammar-points/delete"
})
public class AdminGrammarPointServlet extends HttpServlet {

    private final GrammarPointRepository grammarRepository = new GrammarPointRepository();
    private final LessonRepository lessonRepository = new LessonRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/admin/grammar-points/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/grammar-points/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/grammar-points":
                default:
                    listGrammarPoints(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminGrammarPointServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/grammar-points/create":
                    createGrammarPoint(request, response);
                    break;
                case "/admin/grammar-points/edit":
                    updateGrammarPoint(request, response);
                    break;
                case "/admin/grammar-points/delete":
                    deleteGrammarPoint(request, response);
                    break;
                case "/admin/grammar-points":
                default:
                    listGrammarPoints(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminGrammarPointServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listGrammarPoints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            return;
        }

        UUID lessonId = UUID.fromString(lessonIdStr);
        Lesson lesson = lessonRepository.findById(lessonId);
        List<GrammarPoint> grammarPoints = grammarRepository.findAllByLessonId(lessonId);

        request.setAttribute("lesson", lesson);
        request.setAttribute("grammarPoints", grammarPoints);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/grammar-point/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr != null) {
            Lesson lesson = lessonRepository.findById(UUID.fromString(lessonIdStr));
            request.setAttribute("lesson", lesson);
            request.setAttribute("lessonId", lessonIdStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/grammar-point/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            GrammarPoint grammarPoint = grammarRepository.findById(UUID.fromString(idStr));
            if (grammarPoint != null) {
                Lesson lesson = lessonRepository.findById(grammarPoint.getLessonId());
                request.setAttribute("grammarPoint", grammarPoint);
                request.setAttribute("lesson", lesson);
                request.setAttribute("lessonId", grammarPoint.getLessonId().toString());
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/grammar-point/form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
        }
    }

    private void createGrammarPoint(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String lessonIdStr = request.getParameter("lessonId");
        String title = request.getParameter("title");
        String structure = request.getParameter("structure");
        String explanation = request.getParameter("explanation");
        String example = request.getParameter("example");

        if (lessonIdStr == null || lessonIdStr.isEmpty()) {
            request.setAttribute("error", "Bài học không hợp lệ.");
            listGrammarPoints(request, response);
            return;
        }

        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề là bắt buộc.");
            request.setAttribute("lessonId", lessonIdStr);
            showCreateForm(request, response);
            return;
        }

        GrammarPoint grammarPoint = new GrammarPoint();
        grammarPoint.setId(UUID.randomUUID());
        grammarPoint.setLessonId(UUID.fromString(lessonIdStr));
        grammarPoint.setTitle(title.trim());
        grammarPoint.setStructure(structure != null ? structure.trim() : null);
        grammarPoint.setExplanation(explanation != null ? explanation.trim() : null);
        grammarPoint.setExample(example != null ? example.trim() : null);

        if (grammarRepository.save(grammarPoint)) {
            response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Không thể tạo điểm ngữ pháp. Vui lòng thử lại.");
            request.setAttribute("lessonId", lessonIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateGrammarPoint(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String lessonIdStr = request.getParameter("lessonId");
        String title = request.getParameter("title");
        String structure = request.getParameter("structure");
        String explanation = request.getParameter("explanation");
        String example = request.getParameter("example");

        if (idStr == null || title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            if (lessonIdStr != null) {
                listGrammarPoints(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
            return;
        }

        GrammarPoint grammarPoint = grammarRepository.findById(UUID.fromString(idStr));
        if (grammarPoint != null) {
            grammarPoint.setTitle(title.trim());
            grammarPoint.setStructure(structure != null ? structure.trim() : null);
            grammarPoint.setExplanation(explanation != null ? explanation.trim() : null);
            grammarPoint.setExample(example != null ? example.trim() : null);

            if (grammarRepository.update(grammarPoint)) {
                response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật điểm ngữ pháp. Vui lòng thử lại.");
                request.setAttribute("grammarPoint", grammarPoint);
                request.setAttribute("lessonId", lessonIdStr);
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr);
        }
    }

    private void deleteGrammarPoint(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String lessonIdStr = request.getParameter("lessonId");
        if (idStr != null) {
            if (grammarRepository.delete(UUID.fromString(idStr))) {
                response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr + "&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr + "&error=delete_failed");
            }
        } else {
            if (lessonIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/admin/grammar-points?lessonId=" + lessonIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/lesson-groups");
            }
        }
    }
}
