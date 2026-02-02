package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.Question;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionRepository {

    private final Connection conn = DBConnect.getConnection();
    private final QuestionOptionRepository optionRepository = new QuestionOptionRepository();

    public List<Question> findAllBySectionId(int sectionId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE SectionId = ? ORDER BY ID";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToQuestion(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "findAllBySectionId", "Error finding questions by section ID: " + e.getMessage());
        }
        return list;
    }

    public Question findById(int id) {
        String sql = "SELECT * FROM Question WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToQuestion(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "findById", "Error finding question by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(Question question) {
        String sql = "INSERT INTO Question (SectionId, Content, ImageUrl) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, question.getSectionId());
            stmt.setString(2, question.getContent());
            stmt.setString(3, question.getImageUrl());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    question.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "save", "Error saving question: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Question question) {
        String sql = "UPDATE Question SET Content = ?, ImageUrl = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getContent());
            stmt.setString(2, question.getImageUrl());
            stmt.setInt(3, question.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "update", "Error updating question: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        // First delete all options for this question
        optionRepository.deleteAllByQuestionId(id);
        
        // Then delete the question
        String sql = "DELETE FROM Question WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "delete", "Error deleting question: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllBySectionId(int sectionId) {
        // First get all questions for this section and delete their options
        List<Question> questions = findAllBySectionId(sectionId);
        for (Question question : questions) {
            optionRepository.deleteAllByQuestionId(question.getId());
        }
        
        // Then delete all questions
        String sql = "DELETE FROM Question WHERE SectionId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "deleteAllBySectionId", "Error deleting all questions by section ID: " + e.getMessage());
        }
        return false;
    }

    public int countOptionsByQuestionId(int questionId) {
        String sql = "SELECT COUNT(*) FROM QuestionOption WHERE QuestionId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(QuestionRepository.class.getName(), "countOptionsByQuestionId", "Error counting options: " + e.getMessage());
        }
        return 0;
    }

    private Question mapResultSetToQuestion(ResultSet rs) throws SQLException {
        Question question = new Question();
        question.setId(rs.getInt("ID"));
        question.setSectionId(rs.getInt("SectionId"));
        question.setContent(rs.getString("Content"));
        question.setImageUrl(rs.getString("ImageUrl"));
        return question;
    }
}
