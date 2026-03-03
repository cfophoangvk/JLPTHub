package service;

import java.util.List;
import java.util.UUID;
import model.GrammarPoint;
import repository.GrammarPointRepository;

public class GrammarPointService {

    private final GrammarPointRepository grammarRepository = new GrammarPointRepository();

    public List<GrammarPoint> find(UUID lessonId, String title, String structure, String sortFieldName, boolean isAscending) {
        if ((title != null && !title.isEmpty()) || (structure != null && !structure.isEmpty()) || sortFieldName != null) {
            return grammarRepository.filter(lessonId, title, structure, sortFieldName, isAscending);
        }
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
