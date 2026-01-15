package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.UserFlashcardProgress;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserFlashcardProgressRepository {
    private final Connection conn = DBConnect.getConnection();

    public List<UserFlashcardProgress> findByUserAndGroup(UUID userId, UUID groupId) {
        List<UserFlashcardProgress> list = new ArrayList<>();
        String sql = """
            SELECT ufp.* FROM UserFlashcardProgress ufp
            INNER JOIN Flashcard f ON ufp.FlashcardId = f.ID
            WHERE ufp.UserId = ? AND f.GroupId = ?
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProgress(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "findByUserAndGroup", 
                "Error finding progress by user and group: " + e.getMessage());
        }
        return list;
    }

    public List<UserFlashcardProgress> findFavoritesByUserAndGroup(UUID userId, UUID groupId) {
        List<UserFlashcardProgress> list = new ArrayList<>();
        String sql = """
            SELECT ufp.* FROM UserFlashcardProgress ufp
            INNER JOIN Flashcard f ON ufp.FlashcardId = f.ID
            WHERE ufp.UserId = ? AND f.GroupId = ? AND ufp.IsFavorite = 1
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, groupId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProgress(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "findFavoritesByUserAndGroup", 
                "Error finding favorites by user and group: " + e.getMessage());
        }
        return list;
    }

    public UserFlashcardProgress findByUserAndFlashcard(UUID userId, UUID flashcardId) {
        String sql = "SELECT * FROM UserFlashcardProgress WHERE UserId = ? AND FlashcardId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, flashcardId.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "findByUserAndFlashcard", 
                "Error finding progress by user and flashcard: " + e.getMessage());
        }
        return null;
    }

    public boolean save(UserFlashcardProgress progress) {
        String sql = "INSERT INTO UserFlashcardProgress (UserId, FlashcardId, IsFavorite, Status, LastReviewedDate) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, progress.getUserId().toString());
            stmt.setString(2, progress.getFlashcardId().toString());
            stmt.setBoolean(3, progress.isFavorite());
            stmt.setString(4, progress.getStatus() != null ? progress.getStatus() : "New");
            
            if (progress.getLastReviewedDate() != null) {
                stmt.setTimestamp(5, Timestamp.valueOf(progress.getLastReviewedDate()));
            } else {
                stmt.setNull(5, Types.TIMESTAMP);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "save", 
                "Error saving progress: " + e.getMessage());
        }
        return false;
    }

    public boolean toggleFavorite(UUID userId, UUID flashcardId) {
        // First check if record exists
        UserFlashcardProgress existing = findByUserAndFlashcard(userId, flashcardId);
        
        if (existing == null) {
            // Create new record with favorite set to true
            UserFlashcardProgress newProgress = new UserFlashcardProgress();
            newProgress.setUserId(userId);
            newProgress.setFlashcardId(flashcardId);
            newProgress.setFavorite(true);
            newProgress.setStatus("New");
            return save(newProgress);
        } else {
            // Toggle existing favorite status
            String sql = "UPDATE UserFlashcardProgress SET IsFavorite = ~IsFavorite WHERE UserId = ? AND FlashcardId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, userId.toString());
                stmt.setString(2, flashcardId.toString());
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "toggleFavorite", 
                    "Error toggling favorite: " + e.getMessage());
            }
        }
        return false;
    }

    public boolean isFavorite(UUID userId, UUID flashcardId) {
        UserFlashcardProgress progress = findByUserAndFlashcard(userId, flashcardId);
        return progress != null && progress.isFavorite();
    }

    public boolean updateReviewStatus(UUID userId, UUID flashcardId, String status) {
        UserFlashcardProgress existing = findByUserAndFlashcard(userId, flashcardId);
        
        if (existing == null) {
            // Create new record
            UserFlashcardProgress newProgress = new UserFlashcardProgress();
            newProgress.setUserId(userId);
            newProgress.setFlashcardId(flashcardId);
            newProgress.setFavorite(false);
            newProgress.setStatus(status);
            newProgress.setLastReviewedDate(java.time.LocalDateTime.now());
            return save(newProgress);
        } else {
            String sql = "UPDATE UserFlashcardProgress SET Status = ?, LastReviewedDate = GETDATE() WHERE UserId = ? AND FlashcardId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setString(2, userId.toString());
                stmt.setString(3, flashcardId.toString());
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                ExceptionLogger.logError(UserFlashcardProgressRepository.class.getName(), "updateReviewStatus", 
                    "Error updating review status: " + e.getMessage());
            }
        }
        return false;
    }

    private UserFlashcardProgress mapResultSetToProgress(ResultSet rs) throws SQLException {
        UserFlashcardProgress progress = new UserFlashcardProgress();
        progress.setUserId(UUID.fromString(rs.getString("UserId")));
        progress.setFlashcardId(UUID.fromString(rs.getString("FlashcardId")));
        progress.setFavorite(rs.getBoolean("IsFavorite"));
        progress.setStatus(rs.getString("Status"));
        
        Timestamp lastReviewed = rs.getTimestamp("LastReviewedDate");
        if (lastReviewed != null) {
            progress.setLastReviewedDate(lastReviewed.toLocalDateTime());
        }
        
        return progress;
    }
}
