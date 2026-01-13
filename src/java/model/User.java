package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class User {
    public UUID id;
    public String email;
    public String fullName;
    public String password;
    public UUID emailVerificationToken;
    public LocalDateTime emailVerificationTokenExpire;
    public boolean isEmailVerified;
    public UUID passwordResetToken;
    public LocalDateTime passwordResetTokenExpire;
    public TargetLevel targetLevel;
    public short role;
    public String googleId;
    public String authProvider; // "local" or "google"

    public User() {
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UUID getEmailVerificationToken() {
        return emailVerificationToken;
    }

    public void setEmailVerificationToken(UUID emailVerificationToken) {
        this.emailVerificationToken = emailVerificationToken;
    }

    public LocalDateTime getEmailVerificationTokenExpire() {
        return emailVerificationTokenExpire;
    }

    public void setEmailVerificationTokenExpire(LocalDateTime emailVerificationTokenExpire) {
        this.emailVerificationTokenExpire = emailVerificationTokenExpire;
    }

    public boolean isIsEmailVerified() {
        return isEmailVerified;
    }

    public void setIsEmailVerified(boolean isEmailVerified) {
        this.isEmailVerified = isEmailVerified;
    }

    public UUID getPasswordResetToken() {
        return passwordResetToken;
    }

    public void setPasswordResetToken(UUID passwordResetToken) {
        this.passwordResetToken = passwordResetToken;
    }

    public LocalDateTime getPasswordResetTokenExpire() {
        return passwordResetTokenExpire;
    }

    public void setPasswordResetTokenExpire(LocalDateTime passwordResetTokenExpire) {
        this.passwordResetTokenExpire = passwordResetTokenExpire;
    }

    public TargetLevel getTargetLevel() {
        return targetLevel;
    }

    public void setTargetLevel(TargetLevel targetLevel) {
        this.targetLevel = targetLevel;
    }

    public short getRole() {
        return role;
    }

    public void setRole(short role) {
        this.role = role;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(String authProvider) {
        this.authProvider = authProvider;
    }
}
