package repository;

import common.logger.ExceptionLogger;
import common.util.DBConnect;
import model.TargetLevel;
import model.User;

import java.sql.*;
import java.util.UUID;

public class UserRepository {

    private final Connection conn = DBConnect.getConnection();

    public User findById(UUID id) {
        String sql = "SELECT * FROM [User] WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "findById", "Error finding user by ID: " + e.getMessage());
        }
        return null;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM [User] WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "findByEmail", "Error finding user by email: " + e.getMessage());
        }
        return null;
    }

    public User findByGoogleId(String googleId) {
        String sql = "SELECT * FROM [User] WHERE GoogleId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, googleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "findByGoogleId", "Error finding user by Google ID: " + e.getMessage());
        }
        return null;
    }

    public User findByEmailVerificationToken(UUID token) {
        String sql = "SELECT * FROM [User] WHERE EmailVerificationToken = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "findByEmailVerificationToken", "Error finding user by verification token: " + e.getMessage());
        }
        return null;
    }

    public User findByPasswordResetToken(UUID token) {
        String sql = "SELECT * FROM [User] WHERE PasswordResetToken = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "findByPasswordResetToken", "Error finding user by reset token: " + e.getMessage());
        }
        return null;
    }

    public User save(User user) {
        String sql = """
            INSERT INTO [User] (ID, Email, Fullname, Password, EmailVerificationToken,
                EmailVerificationTokenExpire, IsEmailVerified, TargetLevel, Role, GoogleId, AuthProvider)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            UUID id = UUID.randomUUID();
            user.setId(id);

            stmt.setString(1, id.toString());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPassword());

            if (user.getEmailVerificationToken() != null) {
                stmt.setString(5, user.getEmailVerificationToken().toString());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }

            if (user.getEmailVerificationTokenExpire() != null) {
                stmt.setTimestamp(6, Timestamp.valueOf(user.getEmailVerificationTokenExpire()));
            } else {
                stmt.setNull(6, Types.TIMESTAMP);
            }

            stmt.setBoolean(7, user.isIsEmailVerified());
            stmt.setString(8, user.getTargetLevel().name());
            stmt.setShort(9, user.getRole());
            stmt.setString(10, user.getGoogleId());
            stmt.setString(11, user.getAuthProvider() != null ? user.getAuthProvider() : "local");

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                return user;
            }
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "save", "Error saving user: " + e.getMessage());
        }
        return null;
    }

    public boolean update(User user) {
        String sql = """
            UPDATE [User] SET
                Email = ?, Fullname = ?, Password = ?,
                EmailVerificationToken = ?, EmailVerificationTokenExpire = ?, IsEmailVerified = ?,
                PasswordResetToken = ?, PasswordResetTokenExpire = ?,
                TargetLevel = ?, Role = ?, GoogleId = ?, AuthProvider = ?
            WHERE ID = ?
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getPassword());

            if (user.getEmailVerificationToken() != null) {
                stmt.setString(4, user.getEmailVerificationToken().toString());
            } else {
                stmt.setNull(4, Types.VARCHAR);
            }

            if (user.getEmailVerificationTokenExpire() != null) {
                stmt.setTimestamp(5, Timestamp.valueOf(user.getEmailVerificationTokenExpire()));
            } else {
                stmt.setNull(5, Types.TIMESTAMP);
            }

            stmt.setBoolean(6, user.isIsEmailVerified());

            if (user.getPasswordResetToken() != null) {
                stmt.setString(7, user.getPasswordResetToken().toString());
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }

            if (user.getPasswordResetTokenExpire() != null) {
                stmt.setTimestamp(8, Timestamp.valueOf(user.getPasswordResetTokenExpire()));
            } else {
                stmt.setNull(8, Types.TIMESTAMP);
            }

            stmt.setString(9, user.getTargetLevel().name());
            stmt.setShort(10, user.getRole());
            stmt.setString(11, user.getGoogleId());
            stmt.setString(12, user.getAuthProvider() != null ? user.getAuthProvider() : "local");
            stmt.setString(13, user.getId().toString());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            ExceptionLogger.logError(UserRepository.class.getName(), "update", "Error updating user: " + e.getMessage());
        }
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(UUID.fromString(rs.getString("ID")));
        user.setEmail(rs.getString("Email"));
        user.setFullName(rs.getString("Fullname"));
        user.setPassword(rs.getString("Password"));

        String emailVerificationToken = rs.getString("EmailVerificationToken");
        if (emailVerificationToken != null) {
            user.setEmailVerificationToken(UUID.fromString(emailVerificationToken));
        }

        Timestamp emailVerificationExpire = rs.getTimestamp("EmailVerificationTokenExpire");
        if (emailVerificationExpire != null) {
            user.setEmailVerificationTokenExpire(emailVerificationExpire.toLocalDateTime());
        }

        user.setIsEmailVerified(rs.getBoolean("IsEmailVerified"));

        String passwordResetToken = rs.getString("PasswordResetToken");
        if (passwordResetToken != null) {
            user.setPasswordResetToken(UUID.fromString(passwordResetToken));
        }

        Timestamp passwordResetExpire = rs.getTimestamp("PasswordResetTokenExpire");
        if (passwordResetExpire != null) {
            user.setPasswordResetTokenExpire(passwordResetExpire.toLocalDateTime());
        }

        user.setTargetLevel(TargetLevel.valueOf(rs.getString("TargetLevel")));
        user.setRole(rs.getShort("Role"));
        user.setGoogleId(rs.getString("GoogleId"));
        user.setAuthProvider(rs.getString("AuthProvider"));

        return user;
    }
}
