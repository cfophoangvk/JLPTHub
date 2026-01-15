package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Flashcard;
import model.FlashcardGroup;
import model.User;
import repository.FlashcardGroupRepository;
import repository.FlashcardRepository;
import service.CloudinaryService;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminFlashcardServlet", urlPatterns = {
    "/admin/flashcards",
    "/admin/flashcards/create",
    "/admin/flashcards/edit",
    "/admin/flashcards/delete"
})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AdminFlashcardServlet extends HttpServlet {
    private final FlashcardRepository flashcardRepository = new FlashcardRepository();
    private final FlashcardGroupRepository groupRepository = new FlashcardGroupRepository();
    private final CloudinaryService cloudinaryService = new CloudinaryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/admin/flashcards/create":
                showCreateForm(request, response);
                break;
            case "/admin/flashcards/edit":
                showEditForm(request, response);
                break;
            case "/admin/flashcards":
            default:
                listFlashcards(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/admin/flashcards/create":
                createFlashcard(request, response);
                break;
            case "/admin/flashcards/edit":
                updateFlashcard(request, response);
                break;
            case "/admin/flashcards/delete":
                deleteFlashcard(request, response);
                break;
            case "/admin/flashcards":
            default:
                listFlashcards(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listFlashcards(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
            return;
        }

        UUID groupId = UUID.fromString(groupIdStr);
        FlashcardGroup group = groupRepository.findById(groupId);
        List<Flashcard> flashcards = flashcardRepository.findAllByGroupId(groupId);
        
        request.setAttribute("group", group);
        request.setAttribute("flashcards", flashcards);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr != null) {
            request.setAttribute("groupId", groupIdStr);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard/form.jsp").forward(request, response);
        } else {
             response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Flashcard flashcard = flashcardRepository.findById(UUID.fromString(idStr));
            request.setAttribute("flashcard", flashcard);
            request.setAttribute("groupId", flashcard.getGroupId().toString());
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }

    private void createFlashcard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String groupIdStr = request.getParameter("groupId");
        String term = request.getParameter("term");
        String definition = request.getParameter("definition");
        Part termImagePart = request.getPart("termImage");
        Part definitionImagePart = request.getPart("definitionImage");

        if (groupIdStr == null || term == null || term.isEmpty() || definition == null || definition.isEmpty()) {
            request.setAttribute("error", "Group, Term and Definition are required.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
            return;
        }

        String termImageUrl = cloudinaryService.uploadImage(termImagePart);
        String definitionImageUrl = cloudinaryService.uploadImage(definitionImagePart);

        Flashcard flashcard = new Flashcard();
        flashcard.setId(UUID.randomUUID());
        flashcard.setGroupId(UUID.fromString(groupIdStr));
        flashcard.setTerm(term);
        flashcard.setDefinition(definition);
        flashcard.setTermImageUrl(termImageUrl);
        flashcard.setDefinitionImageUrl(definitionImageUrl);

        if (flashcardRepository.save(flashcard)) {
            response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Failed to create flashcard.");
            request.setAttribute("groupId", groupIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateFlashcard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String groupIdStr = request.getParameter("groupId");
        String term = request.getParameter("term");
        String definition = request.getParameter("definition");
        Part termImagePart = request.getPart("termImage");
        Part definitionImagePart = request.getPart("definitionImage");
        String existingTermImage = request.getParameter("existingTermImage");
        String existingDefinitionImage = request.getParameter("existingDefinitionImage");

        if (idStr == null || term == null || term.isEmpty() || definition == null || definition.isEmpty()) {
            request.setAttribute("error", "Invalid data.");
             if(groupIdStr != null) listFlashcards(request, response);
             else response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
            return;
        }

        Flashcard flashcard = flashcardRepository.findById(UUID.fromString(idStr));
        if (flashcard != null) {
            flashcard.setTerm(term);
            flashcard.setDefinition(definition);

            String termImageUrl = cloudinaryService.uploadImage(termImagePart);
            if (termImageUrl != null) {
                flashcard.setTermImageUrl(termImageUrl);
            } else {
                flashcard.setTermImageUrl(existingTermImage);
            }

            String definitionImageUrl = cloudinaryService.uploadImage(definitionImagePart);
            if (definitionImageUrl != null) {
                flashcard.setDefinitionImageUrl(definitionImageUrl);
            } else {
                 flashcard.setDefinitionImageUrl(existingDefinitionImage);
            }

            if (flashcardRepository.update(flashcard)) {
                response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr + "&success=updated");
            } else {
                request.setAttribute("error", "Failed to update flashcard.");
                request.setAttribute("flashcard", flashcard);
                showEditForm(request, response);
            }
        } else {
             response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr);
        }
    }

    private void deleteFlashcard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String groupIdStr = request.getParameter("groupId");
        if (idStr != null) {
             if(flashcardRepository.delete(UUID.fromString(idStr))) {
                  response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr + "&success=deleted");
             } else {
                  response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr + "&error=delete_failed");
             }
        } else {
            if(groupIdStr != null) response.sendRedirect(request.getContextPath() + "/admin/flashcards?groupId=" + groupIdStr);
            else response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }
}
