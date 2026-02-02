package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.GrammarPoint;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class GrammarPointRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<GrammarPoint> findAllByLessonId(UUID lessonId) {
        List<GrammarPoint> list = new ArrayList<>();
        String sql = "SELECT * FROM GrammarPoint WHERE LessonId = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, lessonId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToGrammarPoint(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "findAllByLessonId", "Error finding grammar points by lesson ID: " + e.getMessage());
        }
        return list;
    }

    public GrammarPoint findById(UUID id) {
        String sql = "SELECT * FROM GrammarPoint WHERE ID = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToGrammarPoint(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "findById", "Error finding grammar point by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(GrammarPoint grammarPoint) {
        String sql = "INSERT INTO GrammarPoint (ID, LessonId, Title, Structure, Explanation, Example, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, grammarPoint.getId().toString());
            stmt.setString(2, grammarPoint.getLessonId().toString());
            stmt.setString(3, grammarPoint.getTitle());
            stmt.setString(4, grammarPoint.getStructure());
            stmt.setString(5, grammarPoint.getExplanation());
            stmt.setString(6, grammarPoint.getExample());
            stmt.setBoolean(7, true);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "save", "Error saving grammar point: " + e.getMessage());
        }
        return false;
    }

    public boolean update(GrammarPoint grammarPoint) {
        String sql = "UPDATE GrammarPoint SET Title = ?, Structure = ?, Explanation = ?, Example = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, grammarPoint.getTitle());
            stmt.setString(2, grammarPoint.getStructure());
            stmt.setString(3, grammarPoint.getExplanation());
            stmt.setString(4, grammarPoint.getExample());
            stmt.setString(5, grammarPoint.getId().toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "update", "Error updating grammar point: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(UUID id) {
        String sql = "UPDATE GrammarPoint SET Status = 0 WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "delete", "Error deleting grammar point: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllByLessonId(UUID lessonId) {
        String sql = "UPDATE GrammarPoint SET Status = 0 WHERE LessonId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, lessonId.toString());
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(GrammarPointRepository.class.getName(), "deleteAllByLessonId", "Error deleting all grammar points by lesson ID: " + e.getMessage());
        }
        return false;
    }

    private GrammarPoint mapResultSetToGrammarPoint(ResultSet rs) throws SQLException {
        GrammarPoint grammarPoint = new GrammarPoint();
        grammarPoint.setId(UUID.fromString(rs.getString("ID")));
        grammarPoint.setLessonId(UUID.fromString(rs.getString("LessonId")));
        grammarPoint.setTitle(rs.getString("Title"));
        grammarPoint.setStructure(rs.getString("Structure"));
        grammarPoint.setExplanation(rs.getString("Explanation"));
        grammarPoint.setExample(rs.getString("Example"));
        grammarPoint.setStatus(rs.getBoolean("Status"));
        return grammarPoint;
    }
}
