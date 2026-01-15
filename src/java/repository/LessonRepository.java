package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.Lesson;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class LessonRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<Lesson> findAllByGroupId(UUID groupId) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM Lesson WHERE GroupId = ? ORDER BY OrderIndex";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLesson(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "findAllByGroupId", "Error finding lessons by group ID: " + e.getMessage());
        }
        return list;
    }

    public int countByGroupId(UUID groupId) {
        String sql = "SELECT COUNT(*) FROM Lesson WHERE GroupId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "countByGroupId", "Error counting lessons by group ID: " + e.getMessage());
        }
        return 0;
    }

    public Lesson findById(UUID id) {
        String sql = "SELECT * FROM Lesson WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToLesson(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "findById", "Error finding lesson by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(Lesson lesson) {
        String sql = "INSERT INTO Lesson (ID, GroupId, Title, Description, AudioUrl, ContentHtml, OrderIndex) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, lesson.getId().toString());
            stmt.setString(2, lesson.getGroupId().toString());
            stmt.setString(3, lesson.getTitle());
            stmt.setString(4, lesson.getDescription());
            stmt.setString(5, lesson.getAudioUrl());
            stmt.setString(6, lesson.getContentHtml());
            stmt.setInt(7, lesson.getOrderIndex());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "save", "Error saving lesson: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Lesson lesson) {
        String sql = "UPDATE Lesson SET Title = ?, Description = ?, AudioUrl = ?, ContentHtml = ?, OrderIndex = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, lesson.getTitle());
            stmt.setString(2, lesson.getDescription());
            stmt.setString(3, lesson.getAudioUrl());
            stmt.setString(4, lesson.getContentHtml());
            stmt.setInt(5, lesson.getOrderIndex());
            stmt.setString(6, lesson.getId().toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "update", "Error updating lesson: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(UUID id) {
        // Cascade delete for GrammarPoints is handled by database constraint
        String sql = "DELETE FROM Lesson WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "delete", "Error deleting lesson: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllByGroupId(UUID groupId) {
        String sql = "DELETE FROM Lesson WHERE GroupId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupId.toString());
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonRepository.class.getName(), "deleteAllByGroupId", "Error deleting all lessons by group ID: " + e.getMessage());
        }
        return false;
    }

    private Lesson mapResultSetToLesson(ResultSet rs) throws SQLException {
        Lesson lesson = new Lesson();
        lesson.setId(UUID.fromString(rs.getString("ID")));
        lesson.setGroupId(UUID.fromString(rs.getString("GroupId")));
        lesson.setTitle(rs.getString("Title"));
        lesson.setDescription(rs.getString("Description"));
        lesson.setAudioUrl(rs.getString("AudioUrl"));
        lesson.setContentHtml(rs.getString("ContentHtml"));
        lesson.setOrderIndex(rs.getInt("OrderIndex"));
        return lesson;
    }
}
