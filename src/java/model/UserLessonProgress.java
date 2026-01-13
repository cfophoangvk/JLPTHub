package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class UserLessonProgress {
    private UUID userId;
    private UUID lessonId;
    private boolean isCompleted;
    private LocalDateTime completedDate;

    public UserLessonProgress() {
    }

    public UserLessonProgress(UUID userId, UUID lessonId, boolean isCompleted, LocalDateTime completedDate) {
        this.userId = userId;
        this.lessonId = lessonId;
        this.isCompleted = isCompleted;
        this.completedDate = completedDate;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getLessonId() {
        return lessonId;
    }

    public void setLessonId(UUID lessonId) {
        this.lessonId = lessonId;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public LocalDateTime getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(LocalDateTime completedDate) {
        this.completedDate = completedDate;
    }
}
