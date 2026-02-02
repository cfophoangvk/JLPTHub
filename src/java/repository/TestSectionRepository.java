package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.TestSection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestSectionRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<TestSection> findAllByTestId(int testId) {
        List<TestSection> list = new ArrayList<>();
        String sql = "SELECT * FROM TestSection WHERE TestId = ? AND Status = 1 ORDER BY ID";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, testId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTestSection(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "findAllByTestId", "Error finding sections by test ID: " + e.getMessage());
        }
        return list;
    }

    public TestSection findById(int id) {
        String sql = "SELECT * FROM TestSection WHERE ID = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTestSection(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "findById", "Error finding section by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(TestSection section) {
        String sql = "INSERT INTO TestSection (TestId, TimeLimitMinutes, AudioUrl, SectionType, PassScore, TotalScore, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, section.getTestId());
            stmt.setInt(2, section.getTimeLimitMinutes());
            stmt.setString(3, section.getAudioUrl());
            stmt.setString(4, section.getSectionType());
            stmt.setInt(5, section.getPassScore());
            stmt.setInt(6, section.getTotalScore());
            stmt.setBoolean(7, section.isStatus());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    section.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "save", "Error saving section: " + e.getMessage());
        }
        return false;
    }

    public boolean update(TestSection section) {
        String sql = "UPDATE TestSection SET TimeLimitMinutes = ?, AudioUrl = ?, SectionType = ?, PassScore = ?, TotalScore = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, section.getTimeLimitMinutes());
            stmt.setString(2, section.getAudioUrl());
            stmt.setString(3, section.getSectionType());
            stmt.setInt(4, section.getPassScore());
            stmt.setInt(5, section.getTotalScore());
            stmt.setInt(6, section.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "update", "Error updating section: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE TestSection SET Status = 0 WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "delete", "Error deleting section: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteAllByTestId(int testId) {
        String sql = "UPDATE TestSection SET Status = 0 WHERE TestId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, testId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "deleteAllByTestId", "Error deleting all sections by test ID: " + e.getMessage());
        }
        return false;
    }

    public int countQuestionsBySectionId(int sectionId) {
        String sql = "SELECT COUNT(*) FROM Question WHERE SectionId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestSectionRepository.class.getName(), "countQuestionsBySectionId", "Error counting questions: " + e.getMessage());
        }
        return 0;
    }

    private TestSection mapResultSetToTestSection(ResultSet rs) throws SQLException {
        TestSection section = new TestSection();
        section.setId(rs.getInt("ID"));
        section.setTestId(rs.getInt("TestId"));
        section.setTimeLimitMinutes(rs.getInt("TimeLimitMinutes"));
        section.setAudioUrl(rs.getString("AudioUrl"));
        section.setSectionType(rs.getString("SectionType"));
        section.setPassScore(rs.getInt("PassScore"));
        section.setTotalScore(rs.getInt("TotalScore"));
        section.setStatus(rs.getBoolean("Status"));
        return section;
    }
}
