package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.QuestionOption;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionOptionRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<QuestionOption> findAllByQuestionId(int questionId) {
        List<QuestionOption> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionOption WHERE QuestionId = ? ORDER BY ID";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToQuestionOption(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "findAllByQuestionId", "Error finding options by question ID: " + e.getMessage());
        }
        return list;
    }

    public QuestionOption findById(int id) {
        String sql = "SELECT * FROM QuestionOption WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToQuestionOption(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "findById", "Error finding option by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(QuestionOption option) {
        String sql = "INSERT INTO QuestionOption (QuestionId, Content, ImageUrl, IsCorrect) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, option.getQuestionId());
            stmt.setString(2, option.getContent());
            stmt.setString(3, option.getImageUrl());
            stmt.setBoolean(4, option.isCorrect());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    option.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "save", "Error saving option: " + e.getMessage());
        }
        return false;
    }

    //Lưu nhiều câu trả lời cùng 1 lúc
    public boolean saveBatch(ArrayList<QuestionOption> questionOptions) {
        String sql = "INSERT INTO QuestionOption (QuestionId, Content, ImageUrl, IsCorrect) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (QuestionOption option : questionOptions) {
                stmt.setInt(1, option.getQuestionId());
                stmt.setString(2, option.getContent());
                stmt.setString(3, option.getImageUrl());
                stmt.setBoolean(4, option.isCorrect());
                stmt.addBatch();
            }
            int[] affectedRows = stmt.executeBatch();
            return affectedRows.length > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "saveBatch", "Error saving batch of options: " + e.getMessage());
        }
        return false;
    }

    public boolean update(QuestionOption option) {
        String sql = "UPDATE QuestionOption SET Content = ?, ImageUrl = ?, IsCorrect = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, option.getContent());
            stmt.setString(2, option.getImageUrl());
            stmt.setBoolean(3, option.isCorrect());
            stmt.setInt(4, option.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "update", "Error updating option: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM QuestionOption WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "delete", "Error deleting option: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllByQuestionId(int questionId) {
        String sql = "DELETE FROM QuestionOption WHERE QuestionId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionOptionRepository.class.getName(), "deleteAllByQuestionId", "Error deleting all options by question ID: " + e.getMessage());
        }
        return false;
    }

    private QuestionOption mapResultSetToQuestionOption(ResultSet rs) throws SQLException {
        QuestionOption option = new QuestionOption();
        option.setId(rs.getInt("ID"));
        option.setQuestionId(rs.getInt("QuestionId"));
        option.setContent(rs.getString("Content"));
        option.setImageUrl(rs.getString("ImageUrl"));
        option.setCorrect(rs.getBoolean("IsCorrect"));
        return option;
    }
}
