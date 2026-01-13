package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class UserTestResult {
    private int id;
    private UUID userId;
    private int testId;
    private int scoreObtained;
    private boolean isPassed;
    private LocalDateTime takenDate;
    private Integer durationSeconds;

    public UserTestResult() {
    }

    public UserTestResult(int id, UUID userId, int testId, int scoreObtained, boolean isPassed, LocalDateTime takenDate, Integer durationSeconds) {
        this.id = id;
        this.userId = userId;
        this.testId = testId;
        this.scoreObtained = scoreObtained;
        this.isPassed = isPassed;
        this.takenDate = takenDate;
        this.durationSeconds = durationSeconds;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getScoreObtained() {
        return scoreObtained;
    }

    public void setScoreObtained(int scoreObtained) {
        this.scoreObtained = scoreObtained;
    }

    public boolean isPassed() {
        return isPassed;
    }

    public void setPassed(boolean passed) {
        isPassed = passed;
    }

    public LocalDateTime getTakenDate() {
        return takenDate;
    }

    public void setTakenDate(LocalDateTime takenDate) {
        this.takenDate = takenDate;
    }

    public Integer getDurationSeconds() {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds;
    }
}
