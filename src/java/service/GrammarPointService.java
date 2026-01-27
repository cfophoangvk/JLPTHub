package service;

import java.util.List;
import java.util.UUID;
import model.GrammarPoint;
import repository.GrammarPointRepository;

public class GrammarPointService {

    private final GrammarPointRepository grammarRepository = new GrammarPointRepository();

    public List<GrammarPoint> findAllByLessonId(UUID lessonId) {
        return grammarRepository.findAllByLessonId(lessonId);
    }

    public GrammarPoint findById(UUID id) {
        return grammarRepository.findById(id);
    }

    public boolean save(GrammarPoint grammar) {
        return grammarRepository.save(grammar);
    }
    
    public boolean update(GrammarPoint grammar) {
        return grammarRepository.update(grammar);
    }
    
    public boolean delete(UUID id) {
        return grammarRepository.delete(id);
    }
}
