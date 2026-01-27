package service;

import java.util.List;
import java.util.UUID;
import model.Flashcard;
import repository.FlashcardRepository;

public class FlashcardService {
    private final FlashcardRepository flashcardRepository = new FlashcardRepository();
    
    public List<Flashcard> findAllByGroupId(UUID groupId) {
        return flashcardRepository.findAllByGroupId(groupId);
    }
    
    public Flashcard findById(UUID id) {
        return flashcardRepository.findById(id);
    }
    
    public boolean save(Flashcard flashcard) {
        return flashcardRepository.save(flashcard);
    }
    
    public boolean update(Flashcard flashcard) {
        return flashcardRepository.update(flashcard);
    }
    
    public boolean delete(UUID id) {
        return flashcardRepository.delete(id);
    }
    
}
