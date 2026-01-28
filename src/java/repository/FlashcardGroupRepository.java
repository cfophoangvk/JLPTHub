package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.FlashcardGroup;
import model.TargetLevel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class FlashcardGroupRepository {

    private final Connection conn = DBConnect.getConnection();
    private final FlashcardRepository flashcardRepository = new FlashcardRepository();

    public List<FlashcardGroup> findAll() {
        List<FlashcardGroup> list = new ArrayList<>();
        String sql = "SELECT * FROM FlashcardGroup WHERE Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToFlashcardGroup(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "findAll", "Error finding all flashcard groups: " + e.getMessage());
        }
        return list;
    }

    public List<FlashcardGroup> findByLevel(TargetLevel level) {
        List<FlashcardGroup> list = new ArrayList<>();
        String sql = "SELECT * FROM FlashcardGroup WHERE Level = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, level.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToFlashcardGroup(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "findByLevel", "Error finding flashcard groups by level: " + e.getMessage());
        }
        return list;
    }

    public List<FlashcardGroup> findByLevels(List<TargetLevel> levels) {
        List<FlashcardGroup> list = new ArrayList<>();
        if (levels == null || levels.isEmpty()) {
            return list;
        }

        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM FlashcardGroup WHERE Status = 1 AND Level IN (");
        for (int i = 0; i < levels.size(); i++) {
            sqlBuilder.append("?");
            if (i < levels.size() - 1) {
                sqlBuilder.append(", ");
            }
        }
        sqlBuilder.append(")");

        try (PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < levels.size(); i++) {
                stmt.setString(i + 1, levels.get(i).name());
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToFlashcardGroup(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "findByLevels", "Error finding flashcard groups by levels: " + e.getMessage());
        }
        return list;
    }

    public FlashcardGroup findById(UUID id) {
        String sql = "SELECT * FROM FlashcardGroup WHERE ID = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToFlashcardGroup(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "findById", "Error finding flashcard group by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(FlashcardGroup group) {
        String sql = "INSERT INTO FlashcardGroup (ID, Name, Description, Level, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getId().toString());
            stmt.setString(2, group.getName());
            stmt.setString(3, group.getDescription());
            stmt.setString(4, group.getLevel().name());

            if (group.getCreatedAt() != null) {
                stmt.setTimestamp(5, Timestamp.valueOf(group.getCreatedAt()));
            } else {
                stmt.setNull(5, Types.TIMESTAMP);
            }
            stmt.setBoolean(6, group.isStatus());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "save", "Error saving flashcard group: " + e.getMessage());
        }
        return false;
    }

    public boolean update(FlashcardGroup group) {
        String sql = "UPDATE FlashcardGroup SET Name = ?, Description = ?, Level = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getDescription());
            stmt.setString(3, group.getLevel().name());
            stmt.setString(4, group.getId().toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "update", "Error updating flashcard group: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(UUID id) {
        try {
            // Xóa hết các thẻ trong bộ thẻ
            flashcardRepository.deleteAllByGroupId(id);

            // Xong rồi xóa bộ thẻ
            String sql = "UPDATE FlashcardGroup SET Status = 0 WHERE ID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, id.toString());
                return stmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            ExceptionLogger.logError(FlashcardGroupRepository.class.getName(), "delete", "Error deleting flashcard group: " + e.getMessage());
        }
        return false;
    }

    private FlashcardGroup mapResultSetToFlashcardGroup(ResultSet rs) throws SQLException {
        FlashcardGroup group = new FlashcardGroup();
        group.setId(UUID.fromString(rs.getString("ID")));
        group.setName(rs.getString("Name"));
        group.setDescription(rs.getString("Description"));
        group.setLevel(TargetLevel.valueOf(rs.getString("Level")));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            group.setCreatedAt(createdAt.toLocalDateTime());
        }
        group.setStatus(rs.getBoolean("Status"));

        return group;
    }
}
