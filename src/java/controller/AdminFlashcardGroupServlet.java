package controller;

import common.constant.BaseURL;
import common.constant.RoleConstant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.FlashcardGroup;
import model.TargetLevel;
import model.User;
import repository.FlashcardGroupRepository;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminFlashcardGroupServlet", urlPatterns = {
    "/admin/flashcard-groups",
    "/admin/flashcard-groups/create",
    "/admin/flashcard-groups/edit",
    "/admin/flashcard-groups/delete"
})
public class AdminFlashcardGroupServlet extends HttpServlet {

    private final FlashcardGroupRepository groupRepository = new FlashcardGroupRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String pathInfo = request.getServletPath();
        switch (pathInfo) {
            case "/admin/flashcard-groups/create":
                showCreateForm(request, response);
                break;
            case "/admin/flashcard-groups/edit":
                showEditForm(request, response);
                break;

            case "/admin/flashcard-groups":
            default:
                listGroups(request, response);
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
            case "/admin/flashcard-groups/create":
                createGroup(request, response);
                break;
            case "/admin/flashcard-groups/edit":
                updateGroup(request, response);
                break;
            case "/admin/flashcard-groups/delete":
                deleteGroup(request, response);
                break;
            case "/admin/flashcard-groups":
            default:
                response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listGroups(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<FlashcardGroup> groups = groupRepository.findAll();
        request.setAttribute("groups", groups);
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard-group/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard-group/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            FlashcardGroup group = groupRepository.findById(UUID.fromString(idStr));
            request.setAttribute("group", group);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/flashcard-group/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }

    private void createGroup(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String levelStr = request.getParameter("level");

        if (name == null || name.isEmpty() || levelStr == null || levelStr.isEmpty()) {
            request.setAttribute("error", "Name and Level are required.");
            showCreateForm(request, response);
            return;
        }

        FlashcardGroup group = new FlashcardGroup();
        group.setId(UUID.randomUUID());
        group.setName(name);
        group.setDescription(description);
        group.setLevel(TargetLevel.valueOf(levelStr));
        group.setCreatedAt(LocalDateTime.now());

        if (groupRepository.save(group)) {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups?success=created");
        } else {
            request.setAttribute("error", "Failed to create group.");
            showCreateForm(request, response);
        }
    }

    private void updateGroup(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String levelStr = request.getParameter("level");

        if (idStr == null || name == null || name.isEmpty() || levelStr == null || levelStr.isEmpty()) {
            request.setAttribute("error", "Invalid data.");
            listGroups(request, response);
            return;
        }

        FlashcardGroup group = groupRepository.findById(UUID.fromString(idStr));
        if (group != null) {
            group.setName(name);
            group.setDescription(description);
            group.setLevel(TargetLevel.valueOf(levelStr));

            if (groupRepository.update(group)) {
                response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups?success=updated");
            } else {
                request.setAttribute("error", "Failed to update group.");
                request.setAttribute("group", group);
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }

    private void deleteGroup(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            if (groupRepository.delete(UUID.fromString(idStr))) {
                response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/flashcard-groups");
        }
    }
}
