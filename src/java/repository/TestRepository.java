package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.TargetLevel;
import model.Test;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestRepository {

    private final Connection conn = DBConnect.getConnection();

    public List<Test> findAll() {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM Test WHERE Status = 1 ORDER BY CreatedAt DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTest(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "findAll", "Error finding all tests: " + e.getMessage());
        }
        return list;
    }

    public List<Test> findAllByLevel(TargetLevel level) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM Test WHERE Level = ? AND Status = 1 ORDER BY CreatedAt DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, level.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTest(rs));
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "findAllByLevel", "Error finding tests by level: " + e.getMessage());
        }
        return list;
    }

    public Test findById(int id) {
        String sql = "SELECT * FROM Test WHERE ID = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTest(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "findById", "Error finding test by ID: " + e.getMessage());
        }
        return null;
    }

    public boolean save(Test test) {
        String sql = "INSERT INTO Test (Title, Level, CreatedAt, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, test.getTitle());
            stmt.setString(2, test.getLevel().name());
            stmt.setTimestamp(3, Timestamp.valueOf(test.getCreatedAt()));
            stmt.setBoolean(4, true);
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    test.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "save", "Error saving test: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Test test) {
        String sql = "UPDATE Test SET Title = ?, Level = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, test.getTitle());
            stmt.setString(2, test.getLevel().name());
            stmt.setInt(3, test.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "update", "Error updating test: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE Test SET Status = 0 WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "delete", "Error deleting test: " + e.getMessage());
        }
        return false;
    }

    public int countSectionsByTestId(int testId) {
        String sql = "SELECT COUNT(*) FROM TestSection WHERE TestId = ? AND Status = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, testId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(TestRepository.class.getName(), "countSectionsByTestId", "Error counting sections: " + e.getMessage());
        }
        return 0;
    }

    private Test mapResultSetToTest(ResultSet rs) throws SQLException {
        Test test = new Test();
        test.setId(rs.getInt("ID"));
        test.setTitle(rs.getString("Title"));
        test.setLevel(TargetLevel.valueOf(rs.getString("Level")));
        test.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        test.setStatus(rs.getBoolean("Status"));
        return test;
    }
}
