package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.LessonGroup;
import model.TargetLevel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class LessonGroupRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<LessonGroup> findAll() {
        List<LessonGroup> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonGroup ORDER BY Level, OrderIndex";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToLessonGroup(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "findAll", "Error finding all lesson groups: " + e.getMessage());
        }
        return list;
    }

    public List<LessonGroup> findByLevel(TargetLevel level) {
        List<LessonGroup> list = new ArrayList<>();
        String sql = "SELECT * FROM LessonGroup WHERE Level = ? ORDER BY OrderIndex";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, level.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLessonGroup(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "findByLevel", "Error finding lesson groups by level: " + e.getMessage());
        }
        return list;
    }

    public LessonGroup findById(UUID id) {
        String sql = "SELECT * FROM LessonGroup WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToLessonGroup(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "findById", "Error finding lesson group by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(LessonGroup group) {
        String sql = "INSERT INTO LessonGroup (ID, Name, Level, OrderIndex) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getId().toString());
            stmt.setString(2, group.getName());
            stmt.setString(3, group.getLevel().name());
            stmt.setInt(4, group.getOrderIndex());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "save", "Error saving lesson group: " + e.getMessage());
        }
        return false;
    }

    public boolean update(LessonGroup group) {
        String sql = "UPDATE LessonGroup SET Name = ?, Level = ?, OrderIndex = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getLevel().name());
            stmt.setInt(3, group.getOrderIndex());
            stmt.setString(4, group.getId().toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "update", "Error updating lesson group: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(UUID id) {
        // Cascade delete is handled by database constraint (ON DELETE CASCADE)
        String sql = "DELETE FROM LessonGroup WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(LessonGroupRepository.class.getName(), "delete", "Error deleting lesson group: " + e.getMessage());
        }
        return false;
    }

    private LessonGroup mapResultSetToLessonGroup(ResultSet rs) throws SQLException {
        LessonGroup group = new LessonGroup();
        group.setId(UUID.fromString(rs.getString("ID")));
        group.setName(rs.getString("Name"));
        group.setLevel(TargetLevel.valueOf(rs.getString("Level")));
        group.setOrderIndex(rs.getInt("OrderIndex"));
        return group;
    }
}
