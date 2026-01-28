package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.Flashcard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class FlashcardRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<Flashcard> findAllByGroupId(UUID groupId) {
        List<Flashcard> list = new ArrayList<>();
        String sql = "SELECT * FROM Flashcard WHERE GroupId = ? AND Status = 1 ORDER BY OrderIndex ASC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToFlashcard(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "findAllByGroupId", "Error finding flashcards by group ID: " + e.getMessage());
        }
        return list;
    }

    public Flashcard findById(UUID id) {
        String sql = "SELECT * FROM Flashcard WHERE ID = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToFlashcard(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "findById", "Error finding flashcard by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(Flashcard flashcard) {
        String sql = "INSERT INTO Flashcard (ID, GroupId, Term, Definition, TermImageUrl, DefinitionImageUrl, OrderIndex, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, flashcard.getId().toString());
            stmt.setString(2, flashcard.getGroupId().toString());
            stmt.setString(3, flashcard.getTerm());
            stmt.setString(4, flashcard.getDefinition());
            stmt.setString(5, flashcard.getTermImageUrl());
            stmt.setString(6, flashcard.getDefinitionImageUrl());
            stmt.setInt(7, flashcard.getOrderIndex());
            stmt.setBoolean(8, flashcard.isStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "save", "Error saving flashcard: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Flashcard flashcard) {
        String sql = "UPDATE Flashcard SET GroupId = ?, Term = ?, Definition = ?, TermImageUrl = ?, DefinitionImageUrl = ?, OrderIndex = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, flashcard.getGroupId().toString());
            stmt.setString(2, flashcard.getTerm());
            stmt.setString(3, flashcard.getDefinition());
            stmt.setString(4, flashcard.getTermImageUrl());
            stmt.setString(5, flashcard.getDefinitionImageUrl());
            stmt.setInt(6, flashcard.getOrderIndex());
            stmt.setString(7, flashcard.getId().toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "update", "Error updating flashcard: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(UUID id) {
        String sql = "UPDATE Flashcard SET Status = 0 WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "delete", "Error deleting flashcard: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllByGroupId(UUID groupId) {
        String sql = "UPDATE Flashcard SET Status = 0 WHERE GroupId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupId.toString());
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(FlashcardRepository.class.getName(), "deleteAllByGroupId", "Error deleting all flashcards by group ID: " + e.getMessage());
        }
        return false;
    }

    private Flashcard mapResultSetToFlashcard(ResultSet rs) throws SQLException {
        Flashcard flashcard = new Flashcard();
        flashcard.setId(UUID.fromString(rs.getString("ID")));
        flashcard.setGroupId(UUID.fromString(rs.getString("GroupId")));
        flashcard.setTerm(rs.getString("Term"));
        flashcard.setDefinition(rs.getString("Definition"));
        flashcard.setTermImageUrl(rs.getString("TermImageUrl"));
        flashcard.setDefinitionImageUrl(rs.getString("DefinitionImageUrl"));
        flashcard.setOrderIndex(rs.getInt("OrderIndex"));
        flashcard.setStatus(rs.getBoolean("Status"));
        return flashcard;
    }
}
