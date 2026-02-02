package service;

import java.util.List;
import model.Question;
import repository.QuestionRepository;

public class QuestionService {
    private final QuestionRepository questionRepository = new QuestionRepository();
    
    public List<Question> findAllBySectionId(int sectionId) {
        return questionRepository.findAllBySectionId(sectionId);
    }
    
    public Question findById(int id) {
        return questionRepository.findById(id);
    }
    
    public boolean save(Question question) {
        return questionRepository.save(question);
    }
    
    public boolean update(Question question) {
        return questionRepository.update(question);
    }
    
    public boolean delete(int id) {
        // This will cascade delete all options
        return questionRepository.delete(id);
    }
    
    public boolean deleteAllBySectionId(int sectionId) {
        return questionRepository.deleteAllBySectionId(sectionId);
    }
    
    public int countOptionsByQuestionId(int questionId) {
        return questionRepository.countOptionsByQuestionId(questionId);
    }
}
