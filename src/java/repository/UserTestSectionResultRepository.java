package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.UserTestSectionResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserTestSectionResultRepository {

    private final Connection conn = DBConnect.getConnection();

    public boolean save(UserTestSectionResult result) {
        String sql = "INSERT INTO UserTestSectionResult (UserTestResultId, SectionId, CorrectAnswers, TotalQuestions, ScoreObtained, IsPassed) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, result.getUserTestResultId());
            stmt.setInt(2, result.getSectionId());
            stmt.setInt(3, result.getCorrectAnswers());
            stmt.setInt(4, result.getTotalQuestions());
            stmt.setInt(5, result.getScoreObtained());
            stmt.setBoolean(6, result.isPassed());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    result.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestSectionResultRepository.class.getName(), "save", "Error saving section result: " + e.getMessage());
        }
        return false;
    }

    public boolean saveBatch(List<UserTestSectionResult> results) {
        String sql = "INSERT INTO UserTestSectionResult (UserTestResultId, SectionId, CorrectAnswers, TotalQuestions, ScoreObtained, IsPassed) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (UserTestSectionResult result : results) {
                stmt.setInt(1, result.getUserTestResultId());
                stmt.setInt(2, result.getSectionId());
                stmt.setInt(3, result.getCorrectAnswers());
                stmt.setInt(4, result.getTotalQuestions());
                stmt.setInt(5, result.getScoreObtained());
                stmt.setBoolean(6, result.isPassed());
                stmt.addBatch();
            }
            int[] affectedRows = stmt.executeBatch();
            return affectedRows.length > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestSectionResultRepository.class.getName(), "saveBatch", "Error saving batch of section results: " + e.getMessage());
        }
        return false;
    }

    public List<UserTestSectionResult> findAllByResultId(int resultId) {
        List<UserTestSectionResult> list = new ArrayList<>();
        String sql = "SELECT sr.*, ts.SectionType FROM UserTestSectionResult sr " +
                     "JOIN TestSection ts ON sr.SectionId = ts.ID " +
                     "WHERE sr.UserTestResultId = ? ORDER BY sr.ID";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, resultId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUserTestSectionResult(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestSectionResultRepository.class.getName(), "findAllByResultId", "Error finding section results: " + e.getMessage());
        }
        return list;
    }

    private UserTestSectionResult mapResultSetToUserTestSectionResult(ResultSet rs) throws SQLException {
        UserTestSectionResult result = new UserTestSectionResult();
        result.setId(rs.getInt("ID"));
        result.setUserTestResultId(rs.getInt("UserTestResultId"));
        result.setSectionId(rs.getInt("SectionId"));
        result.setCorrectAnswers(rs.getInt("CorrectAnswers"));
        result.setTotalQuestions(rs.getInt("TotalQuestions"));
        result.setScoreObtained(rs.getInt("ScoreObtained"));
        result.setPassed(rs.getBoolean("IsPassed"));
        try {
            result.setSectionType(rs.getString("SectionType"));
        } catch (SQLException e) {
            // SectionType might not be present in all queries
        }
        return result;
    }
}
