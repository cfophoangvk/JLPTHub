package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class UserFlashcardProgress {
    private UUID userId;
    private UUID flashcardId;
    private boolean isFavorite;
    private String status;
    private LocalDateTime lastReviewedDate;

    public UserFlashcardProgress() {
    }

    public UserFlashcardProgress(UUID userId, UUID flashcardId, boolean isFavorite, String status, LocalDateTime lastReviewedDate) {
        this.userId = userId;
        this.flashcardId = flashcardId;
        this.isFavorite = isFavorite;
        this.status = status;
        this.lastReviewedDate = lastReviewedDate;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getFlashcardId() {
        return flashcardId;
    }

    public void setFlashcardId(UUID flashcardId) {
        this.flashcardId = flashcardId;
    }

    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean favorite) {
        isFavorite = favorite;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getLastReviewedDate() {
        return lastReviewedDate;
    }

    public void setLastReviewedDate(LocalDateTime lastReviewedDate) {
        this.lastReviewedDate = lastReviewedDate;
    }
}
