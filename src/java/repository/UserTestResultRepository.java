package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.UserTestResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserTestResultRepository {

    private final Connection conn = DBConnect.getConnection();

    public int save(UserTestResult result) {
        String sql = "INSERT INTO UserTestResult (UserId, TestId, ScoreObtained, IsPassed, TakenDate, DurationSeconds) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, result.getUserId().toString());
            stmt.setInt(2, result.getTestId());
            stmt.setInt(3, result.getScoreObtained());
            stmt.setBoolean(4, result.isPassed());
            stmt.setTimestamp(5, result.getTakenDate() != null ? Timestamp.valueOf(result.getTakenDate()) : new Timestamp(System.currentTimeMillis()));
            if (result.getDurationSeconds() != null) {
                stmt.setInt(6, result.getDurationSeconds());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestResultRepository.class.getName(), "save", "Error saving test result: " + e.getMessage());
        }
        return 0;
    }

    public UserTestResult findById(int id) {
        String sql = "SELECT * FROM UserTestResult WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUserTestResult(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestResultRepository.class.getName(), "findById", "Error finding result by ID: " + e.getMessage());
        }
        return null;
    }

    public List<UserTestResult> findByUserId(UUID userId) {
        List<UserTestResult> list = new ArrayList<>();
        String sql = "SELECT * FROM UserTestResult WHERE UserId = ? ORDER BY TakenDate DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUserTestResult(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestResultRepository.class.getName(), "findByUserId", "Error finding results by user ID: " + e.getMessage());
        }
        return list;
    }

    public List<UserTestResult> findByUserAndTestId(UUID userId, int testId) {
        List<UserTestResult> list = new ArrayList<>();
        String sql = "SELECT * FROM UserTestResult WHERE UserId = ? AND TestId = ? ORDER BY TakenDate DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setInt(2, testId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUserTestResult(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestResultRepository.class.getName(), "findByUserAndTestId", "Error finding results: " + e.getMessage());
        }
        return list;
    }

    private UserTestResult mapResultSetToUserTestResult(ResultSet rs) throws SQLException {
        UserTestResult result = new UserTestResult();
        result.setId(rs.getInt("ID"));
        result.setUserId(UUID.fromString(rs.getString("UserId")));
        result.setTestId(rs.getInt("TestId"));
        result.setScoreObtained(rs.getInt("ScoreObtained"));
        result.setPassed(rs.getBoolean("IsPassed"));
        Timestamp takenDate = rs.getTimestamp("TakenDate");
        if (takenDate != null) {
            result.setTakenDate(takenDate.toLocalDateTime());
        }
        int durationSeconds = rs.getInt("DurationSeconds");
        if (!rs.wasNull()) {
            result.setDurationSeconds(durationSeconds);
        }
        return result;
    }
}
