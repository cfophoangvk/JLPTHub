package controller;

import common.constant.BaseURL;
import common.constant.Configuration;
import common.constant.RoleConstant;
import common.constant.SectionTypeConstant;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminTestSectionServlet", urlPatterns = {
    "/admin/test-sections",
    "/admin/test-sections/create",
    "/admin/test-sections/edit",
    "/admin/test-sections/delete"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 100, // 100MB
        maxRequestSize = 1024 * 1024 * 120 // 120MB
)
public class AdminTestSectionServlet extends HttpServlet {

    private final TestService testService = new TestService();
    private final TestSectionService sectionService = new TestSectionService();
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
                case "/admin/test-sections/create":
                    showCreateForm(request, response);
                    break;
                case "/admin/test-sections/edit":
                    showEditForm(request, response);
                    break;
                case "/admin/test-sections":
                default:
                    listSections(request, response);
                    break;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminTestSectionServlet.class.getName(), "doGet", "Error: " + e.getMessage());
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
                case "/admin/test-sections/create":
                    createSection(request, response);
                    break;
                case "/admin/test-sections/edit":
                    updateSection(request, response);
                    break;
                case "/admin/test-sections/delete":
                    deleteSection(request, response);
                    break;
                case "/admin/test-sections":
                default:
                    listSections(request, response);
            }
        } catch (Exception e) {
            ExceptionLogger.logError(AdminTestSectionServlet.class.getName(), "doPost", "Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = (User) request.getAttribute("currentUser");
        return user != null && user.getRole() == RoleConstant.ADMIN;
    }

    private void listSections(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
            return;
        }

        try {
            int testId = Integer.parseInt(testIdStr);
            Test test = testService.findById(testId);
            List<TestSection> sections = sectionService.findAllByTestId(testId);

            // Count questions for each section
            Map<Integer, Integer> questionCounts = new HashMap<>();
            for (TestSection section : sections) {
                questionCounts.put(section.getId(), sectionService.countQuestionsBySectionId(section.getId()));
            }

            request.setAttribute("test", test);
            request.setAttribute("sections", sections);
            request.setAttribute("questionCounts", questionCounts);
            request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test-section/list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr != null) {
            try {
                int testId = Integer.parseInt(testIdStr);
                Test test = testService.findById(testId);
                request.setAttribute("test", test);
                request.setAttribute("testId", testIdStr);
                request.setAttribute("sectionTypes", sectionService.getMissingTestSections(testId));
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test-section/form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                TestSection section = sectionService.findById(id);
                if (section != null) {
                    Test test = testService.findById(section.getTestId());
                    request.setAttribute("section", section);
                    request.setAttribute("test", test);
                    request.setAttribute("testId", String.valueOf(section.getTestId()));
                    request.setAttribute("sectionTypes", new String[]{ section.getSectionType() }); //Không cho edit.
                    request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test-section/form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/tests");
    }

    private void createSection(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String testIdStr = request.getParameter("testId");
        String sectionType = request.getParameter("sectionType");
        String timeLimitStr = request.getParameter("timeLimitMinutes");
        String passScoreStr = request.getParameter("passScore");
        String totalScoreStr = request.getParameter("totalScore");
        Part audioPart = request.getPart("audio");

        if (testIdStr == null || testIdStr.isEmpty()) {
            request.setAttribute("error", "Bài test không hợp lệ.");
            showCreateForm(request, response);
            return;
        }

        if (sectionType == null || sectionType.trim().isEmpty()) {
            request.setAttribute("error", "Loại phần thi là bắt buộc.");
            request.setAttribute("testId", testIdStr);
            showCreateForm(request, response);
            return;
        }

        // Validate Choukai must have audio
        boolean hasAudio = audioPart != null && audioPart.getSize() > 0;
        if ("Choukai".equalsIgnoreCase(sectionType) && !hasAudio) {
            request.setAttribute("error", "Phần Choukai (聴解) bắt buộc phải có file audio nghe.");
            request.setAttribute("testId", testIdStr);
            showCreateForm(request, response);
            return;
        }

        if (hasAudio && audioPart.getSize() > Configuration.MAX_AUDIO_SIZE) {
            request.setAttribute("error", "File audio không được vượt quá 100MB.");
            request.setAttribute("testId", testIdStr);
            showCreateForm(request, response);
            return;
        }

        int testId, timeLimit = 0, passScore = 0, totalScore = 0;
        try {
            testId = Integer.parseInt(testIdStr);
            if (timeLimitStr != null && !timeLimitStr.isEmpty()) {
                timeLimit = Integer.parseInt(timeLimitStr);
            }
            if (passScoreStr != null && !passScoreStr.isEmpty()) {
                passScore = Integer.parseInt(passScoreStr);
            }
            if (totalScoreStr != null && !totalScoreStr.isEmpty()) {
                totalScore = Integer.parseInt(totalScoreStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ.");
            request.setAttribute("testId", testIdStr);
            showCreateForm(request, response);
            return;
        }

        String audioUrl = cloudinaryService.uploadAudio(audioPart, BaseURL.CLOUDINARY_TEST_FOLDER);

        TestSection section = new TestSection();
        section.setTestId(testId);
        section.setSectionType(sectionType);
        section.setTimeLimitMinutes(timeLimit);
        section.setAudioUrl(audioUrl);
        section.setPassScore(passScore);
        section.setTotalScore(totalScore);
        section.setStatus(true);

        if (sectionService.save(section)) {
            response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + testIdStr + "&success=created");
        } else {
            request.setAttribute("error", "Không thể tạo phần thi. Vui lòng thử lại.");
            request.setAttribute("testId", testIdStr);
            showCreateForm(request, response);
        }
    }

    private void updateSection(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String testIdStr = request.getParameter("testId");
        String sectionType = request.getParameter("sectionType");
        String timeLimitStr = request.getParameter("timeLimitMinutes");
        String passScoreStr = request.getParameter("passScore");
        String totalScoreStr = request.getParameter("totalScore");
        String existingAudioUrl = request.getParameter("existingAudioUrl");
        Part audioPart = request.getPart("audio");

        if (idStr == null || sectionType == null || sectionType.trim().isEmpty()) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            if (testIdStr != null) {
                listSections(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
            return;
        }

        // Check if there's a new audio upload
        boolean hasNewAudio = audioPart != null && audioPart.getSize() > 0;
        boolean hasExistingAudio = existingAudioUrl != null && !existingAudioUrl.trim().isEmpty();
        
        // Validate Choukai must have audio
        if ("Choukai".equalsIgnoreCase(sectionType) && !hasNewAudio && !hasExistingAudio) {
            request.setAttribute("error", "Phần Choukai (聴解) bắt buộc phải có file audio nghe.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        if (hasNewAudio && audioPart.getSize() > Configuration.MAX_AUDIO_SIZE) {
            request.setAttribute("error", "File audio không được vượt quá 100MB.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        int id, timeLimit = 0, passScore = 0, totalScore = 0;
        try {
            id = Integer.parseInt(idStr);
            if (timeLimitStr != null && !timeLimitStr.isEmpty()) {
                timeLimit = Integer.parseInt(timeLimitStr);
            }
            if (passScoreStr != null && !passScoreStr.isEmpty()) {
                passScore = Integer.parseInt(passScoreStr);
            }
            if (totalScoreStr != null && !totalScoreStr.isEmpty()) {
                totalScore = Integer.parseInt(totalScoreStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ.");
            request.setAttribute("id", idStr);
            showEditForm(request, response);
            return;
        }

        TestSection section = sectionService.findById(id);
        if (section != null) {
            section.setSectionType(sectionType);
            section.setTimeLimitMinutes(timeLimit);
            section.setPassScore(passScore);
            section.setTotalScore(totalScore);

            String audioUrl = cloudinaryService.uploadAudio(audioPart, BaseURL.CLOUDINARY_TEST_FOLDER);
            if (audioUrl != null) {
                section.setAudioUrl(audioUrl);
            } else {
                section.setAudioUrl(existingAudioUrl);
            }

            if (sectionService.update(section)) {
                response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + section.getTestId() + "&success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật phần thi. Vui lòng thử lại.");
                request.setAttribute("section", section);
                request.setAttribute("testId", String.valueOf(section.getTestId()));
                request.setAttribute("sectionTypes", SectionTypeConstant.SECTION_TYPES);
                request.getRequestDispatcher(BaseURL.BASE_VIEW_FOLDER + "/admin/test-section/form.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tests");
        }
    }

    private void deleteSection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String testIdStr = request.getParameter("testId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                if (sectionService.delete(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + testIdStr + "&success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + testIdStr + "&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + testIdStr);
            }
        } else {
            if (testIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/admin/test-sections?testId=" + testIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tests");
            }
        }
    }
}
