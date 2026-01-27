package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.UserLessonProgress;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserLessonProgressRepository {

    private final Connection conn = DBConnect.getConnection();

    public UserLessonProgress findByUserAndLesson(UUID userId, UUID lessonId) {
        String sql = "SELECT * FROM UserLessonProgress WHERE UserId = ? AND LessonId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, lessonId.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserLessonProgressRepository.class.getName(), "findByUserAndLesson",
                    "Error finding progress by user and lesson: " + e.getMessage());
        }
        return null;
    }

    public List<UserLessonProgress> findByUserAndGroup(UUID userId, UUID groupId) {
        List<UserLessonProgress> list = new ArrayList<>();
        String sql = """
            SELECT ulp.* FROM UserLessonProgress ulp
            INNER JOIN Lesson l ON ulp.LessonId = l.ID
            WHERE ulp.UserId = ? AND l.GroupId = ?
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProgress(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserLessonProgressRepository.class.getName(), "findByUserAndGroup",
                    "Error finding progress by user and group: " + e.getMessage());
        }
        return list;
    }

    public int countCompletedByGroup(UUID userId, UUID groupId) {
        String sql = """
            SELECT COUNT(*) FROM UserLessonProgress ulp
            INNER JOIN Lesson l ON ulp.LessonId = l.ID
            WHERE ulp.UserId = ? AND l.GroupId = ? AND ulp.IsCompleted = 1
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserLessonProgressRepository.class.getName(), "countCompletedByGroup",
                    "Error counting completed lessons by group: " + e.getMessage());
        }
        return 0;
    }

    public boolean markCompleted(UUID userId, UUID lessonId) {
        UserLessonProgress existing = findByUserAndLesson(userId, lessonId);

        if (existing == null) {
            // Insert new record
            String sql = "INSERT INTO UserLessonProgress (UserId, LessonId, IsCompleted, CompletedDate) VALUES (?, ?, 1, GETDATE())";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, userId.toString());
                stmt.setString(2, lessonId.toString());
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                ExceptionLogger.logError(UserLessonProgressRepository.class.getName(), "markCompleted",
                        "Error inserting completed progress: " + e.getMessage());
            }
        } else if (!existing.isCompleted()) {
            // Update existing record
            String sql = "UPDATE UserLessonProgress SET IsCompleted = 1, CompletedDate = GETDATE() WHERE UserId = ? AND LessonId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, userId.toString());
                stmt.setString(2, lessonId.toString());
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                ExceptionLogger.logError(UserLessonProgressRepository.class.getName(), "markCompleted",
                        "Error updating completed progress: " + e.getMessage());
            }
        } else {
            // Already completed
            return true;
        }
        return false;
    }

    public boolean isCompleted(UUID userId, UUID lessonId) {
        UserLessonProgress progress = findByUserAndLesson(userId, lessonId);
        return progress != null && progress.isCompleted();
    }

    private UserLessonProgress mapResultSetToProgress(ResultSet rs) throws SQLException {
        UserLessonProgress progress = new UserLessonProgress();
        progress.setUserId(UUID.fromString(rs.getString("UserId")));
        progress.setLessonId(UUID.fromString(rs.getString("LessonId")));
        progress.setCompleted(rs.getBoolean("IsCompleted"));

        Timestamp completedDate = rs.getTimestamp("CompletedDate");
        if (completedDate != null) {
            progress.setCompletedDate(completedDate.toLocalDateTime());
        }

        return progress;
    }
}
