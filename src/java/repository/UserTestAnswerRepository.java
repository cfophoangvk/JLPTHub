package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.UserTestAnswer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserTestAnswerRepository {

    private final Connection conn = DBConnect.getConnection();

    public boolean save(UserTestAnswer answer) {
        String sql = "INSERT INTO UserTestAnswer (UserTestResultId, QuestionId, SelectedOptionId, IsCorrect) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, answer.getUserTestResultId());
            stmt.setInt(2, answer.getQuestionId());
            if (answer.getSelectedOptionId() != null) {
                stmt.setInt(3, answer.getSelectedOptionId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setBoolean(4, answer.isCorrect());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    answer.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestAnswerRepository.class.getName(), "save", "Error saving answer: " + e.getMessage());
        }
        return false;
    }

    public boolean saveBatch(List<UserTestAnswer> answers) {
        String sql = "INSERT INTO UserTestAnswer (UserTestResultId, QuestionId, SelectedOptionId, IsCorrect) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (UserTestAnswer answer : answers) {
                stmt.setInt(1, answer.getUserTestResultId());
                stmt.setInt(2, answer.getQuestionId());
                if (answer.getSelectedOptionId() != null) {
                    stmt.setInt(3, answer.getSelectedOptionId());
                } else {
                    stmt.setNull(3, Types.INTEGER);
                }
                stmt.setBoolean(4, answer.isCorrect());
                stmt.addBatch();
            }
            int[] affectedRows = stmt.executeBatch();
            return affectedRows.length > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestAnswerRepository.class.getName(), "saveBatch", "Error saving batch of answers: " + e.getMessage());
        }
        return false;
    }

    public List<UserTestAnswer> findAllByResultId(int resultId) {
        List<UserTestAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM UserTestAnswer WHERE UserTestResultId = ? ORDER BY ID";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, resultId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUserTestAnswer(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserTestAnswerRepository.class.getName(), "findAllByResultId", "Error finding answers: " + e.getMessage());
        }
        return list;
    }

    private UserTestAnswer mapResultSetToUserTestAnswer(ResultSet rs) throws SQLException {
        UserTestAnswer answer = new UserTestAnswer();
        answer.setId(rs.getInt("ID"));
        answer.setUserTestResultId(rs.getInt("UserTestResultId"));
        answer.setQuestionId(rs.getInt("QuestionId"));
        int selectedOptionId = rs.getInt("SelectedOptionId");
        if (!rs.wasNull()) {
            answer.setSelectedOptionId(selectedOptionId);
        }
        answer.setCorrect(rs.getBoolean("IsCorrect"));
        return answer;
    }
}
