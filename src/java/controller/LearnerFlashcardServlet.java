package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import common.logger.ExceptionLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Flashcard;
import model.FlashcardGroup;
import model.User;
import model.UserFlashcardProgress;
import repository.FlashcardGroupRepository;
import repository.FlashcardRepository;
import repository.UserFlashcardProgressRepository;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "LearnerFlashcardServlet", urlPatterns = {
    "/flashcard",
    "/flashcard/group",
    "/flashcard/bookmark",
    "/flashcard/review"
})
public class LearnerFlashcardServlet extends HttpServlet {

    private final FlashcardRepository flashcardRepository = new FlashcardRepository();
    private final FlashcardGroupRepository groupRepository = new FlashcardGroupRepository();
    private final UserFlashcardProgressRepository progressRepository = new UserFlashcardProgressRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/flashcard/group":
                viewGroupDetail(request, response);
                break;
            case "/flashcard/review":
                showReviewPage(request, response);
                break;
            case "/flashcard":
            default:
                listFlashcardGroups(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isLearner(request)) {
            sendJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "{\"error\": \"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/flashcard/bookmark":
                toggleBookmark(request, response);
                break;
            case "/flashcard/review":
                submitReview(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isLearner(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.LEARNER;
    }

    private User getCurrentUser(HttpServletRequest request) {
        return (User) request.getAttribute("currentUser");
    }

    private void listFlashcardGroups(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = getCurrentUser(request);
        
        // Lấy các level từ N5 đến level hiện tại của user
        List<model.TargetLevel> levels = Arrays.stream(model.TargetLevel.values())
                .filter(l -> l.ordinal() <= user.getTargetLevel().ordinal())
                .collect(Collectors.toList());
                
        List<FlashcardGroup> groups = groupRepository.findByLevels(levels);

        // Tính số thẻ trong mỗi bộ thẻ
        Map<UUID, Integer> cardCounts = new HashMap<>();
        for (FlashcardGroup group : groups) {
            List<Flashcard> cards = flashcardRepository.findAllByGroupId(group.getId());
            cardCounts.put(group.getId(), cards.size());
        }

        request.setAttribute("groups", groups);
        request.setAttribute("cardCounts", cardCounts);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/flashcard/list.jsp").forward(request, response);
    }

    private void viewGroupDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("id");
        if (groupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/flashcard");
            return;
        }

        User user = getCurrentUser(request);
        UUID groupId = UUID.fromString(groupIdStr);

        FlashcardGroup group = groupRepository.findById(groupId);
        if (group == null) {
            response.sendRedirect(request.getContextPath() + "/flashcard");
            return;
        }

        List<Flashcard> flashcards = flashcardRepository.findAllByGroupId(groupId);

        List<UserFlashcardProgress> progressList = progressRepository.findByUserAndGroup(user.getId(), groupId);

        Set<UUID> favoriteIds = progressList.stream()
                .filter(UserFlashcardProgress::isFavorite)
                .map(UserFlashcardProgress::getFlashcardId)
                .collect(Collectors.toSet());

        List<Flashcard> favoriteFlashcards = flashcards.stream()
                .filter(f -> favoriteIds.contains(f.getId()))
                .collect(Collectors.toList());

        request.setAttribute("group", group);
        request.setAttribute("flashcards", flashcards);
        request.setAttribute("favoriteIds", favoriteIds);
        request.setAttribute("favoriteFlashcards", favoriteFlashcards);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/flashcard/detail.jsp").forward(request, response);
    }

    //Đánh dấu thẻ cho người học (gọi ngầm bằng AJAX)
    private void toggleBookmark(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String flashcardIdStr = request.getParameter("flashcardId");
        if (flashcardIdStr == null) {
            sendJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, "{\"error\": \"flashcardId is required\"}");
            return;
        }

        try {
            User user = getCurrentUser(request);
            UUID flashcardId = UUID.fromString(flashcardIdStr);

            boolean success = progressRepository.toggleFavorite(user.getId(), flashcardId);
            boolean isFavorite = progressRepository.isFavorite(user.getId(), flashcardId);

            if (success) {
                sendJsonResponse(response, HttpServletResponse.SC_OK,
                        String.format("{\"success\": true, \"isFavorite\": %s}", isFavorite));
            } else {
                sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "{\"error\": \"Failed to toggle bookmark\"}");
            }
        } catch (Exception e) {
            ExceptionLogger.logError(LearnerFlashcardServlet.class.getName(), "toggleBookmark",
                    "Error toggling bookmark: " + e.getMessage());
            sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"error\": \"An error occurred\"}");
        }
    }

    private void showReviewPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("groupId");
        String mode = request.getParameter("mode");
        String scope = request.getParameter("scope");

        if (groupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/flashcard");
            return;
        }

        User user = getCurrentUser(request);
        UUID groupId = UUID.fromString(groupIdStr);
        FlashcardGroup group = groupRepository.findById(groupId);

        if (group == null) {
            response.sendRedirect(request.getContextPath() + "/flashcard");
            return;
        }

        if (mode == null) {
            mode = "quiz";
        }
        if (scope == null) {
            scope = "all";
        }

        List<Flashcard> flashcards;
        if ("favorites".equals(scope)) {
            List<UserFlashcardProgress> favorites = progressRepository.findFavoritesByUserAndGroup(user.getId(), groupId);
            Set<UUID> favoriteIds = favorites.stream()
                    .map(UserFlashcardProgress::getFlashcardId)
                    .collect(Collectors.toSet());
            flashcards = flashcardRepository.findAllByGroupId(groupId).stream()
                    .filter(f -> favoriteIds.contains(f.getId()))
                    .collect(Collectors.toList());
        } else {
            flashcards = flashcardRepository.findAllByGroupId(groupId);
        }

        Collections.shuffle(flashcards);

        request.setAttribute("group", group);
        request.setAttribute("flashcards", flashcards);
        request.setAttribute("mode", mode);
        request.setAttribute("scope", scope);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/learner/flashcard/review.jsp").forward(request, response);
    }

    //Lưu tiến trình ôn tập của người học (gọi ngầm bằng AJAX)
    private void submitReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            User user = getCurrentUser(request);
            String flashcardIdStr = request.getParameter("flashcardId");
            String isCorrectStr = request.getParameter("isCorrect");

            if (flashcardIdStr == null || isCorrectStr == null) {
                sendJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                        "{\"error\": \"flashcardId and isCorrect are required\"}");
                return;
            }

            UUID flashcardId = UUID.fromString(flashcardIdStr);
            boolean isCorrect = Boolean.parseBoolean(isCorrectStr);

            String status = isCorrect ? "Learned" : "Learning";
            progressRepository.updateReviewStatus(user.getId(), flashcardId, status);

            sendJsonResponse(response, HttpServletResponse.SC_OK, "{\"success\": true}");
        } catch (Exception e) {
            ExceptionLogger.logError(LearnerFlashcardServlet.class.getName(), "submitReview",
                    "Error submitting review: " + e.getMessage());
            sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"error\": \"An error occurred\"}");
        }
    }

    //Trả về chuỗi JSON bằng PrintWriter (khi gọi ngầm bằng AJAX)
    private void sendJsonResponse(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(json);
            out.flush();
        }
    }
}
