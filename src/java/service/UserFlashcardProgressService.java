package service;

import java.util.List;
import java.util.UUID;
import model.UserFlashcardProgress;
import repository.UserFlashcardProgressRepository;

public class UserFlashcardProgressService {
    private final UserFlashcardProgressRepository progressRepository = new UserFlashcardProgressRepository();
    
    public List<UserFlashcardProgress> findByUserAndGroup(UUID userId, UUID groupId) {
        return progressRepository.findByUserAndGroup(userId, groupId);
    }
    
    public boolean toggleFavorite(UUID userId, UUID groupId) {
        return progressRepository.toggleFavorite(userId, groupId);
    }
    
    public boolean isFavorite(UUID userId, UUID groupId) {
        return progressRepository.isFavorite(userId, groupId);
    }
    
    public List<UserFlashcardProgress> findFavoritesByUserAndGroup(UUID userId, UUID groupId) {
        return progressRepository.findFavoritesByUserAndGroup(userId, groupId);
    }
    
    public void updateReviewStatus(UUID userId, UUID flashcardId, boolean hasLearned) {
        progressRepository.updateReviewStatus(userId, flashcardId, hasLearned ? "Learned" : "Learning");
    }
}
