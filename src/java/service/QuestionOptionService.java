package service;

import java.util.List;
import model.QuestionOption;
import repository.QuestionOptionRepository;

public class QuestionOptionService {
    private final QuestionOptionRepository optionRepository = new QuestionOptionRepository();
    
    public List<QuestionOption> findAllByQuestionId(int questionId) {
        return optionRepository.findAllByQuestionId(questionId);
    }
    
    public QuestionOption findById(int id) {
        return optionRepository.findById(id);
    }
    
    public boolean save(QuestionOption option) {
        return optionRepository.save(option);
    }
    
    public boolean update(QuestionOption option) {
        return optionRepository.update(option);
    }
    
    public boolean delete(int id) {
        return optionRepository.delete(id);
    }
    
    public boolean deleteAllByQuestionId(int questionId) {
        return optionRepository.deleteAllByQuestionId(questionId);
    }
}
