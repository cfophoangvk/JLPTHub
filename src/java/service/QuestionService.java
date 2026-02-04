package service;

import common.logger.ExceptionLogger;
import java.util.ArrayList;
import java.util.List;
import model.Question;
import model.QuestionOption;
import repository.QuestionOptionRepository;
import repository.QuestionRepository;

public class QuestionService {
    private final QuestionRepository questionRepository = new QuestionRepository();
    private final QuestionOptionRepository optionRepository = new QuestionOptionRepository();
    
    public List<Question> findAllBySectionId(int sectionId) {
        return questionRepository.findAllBySectionId(sectionId);
    }
    
    public Question findById(int id) {
        return questionRepository.findById(id);
    }
    
    public boolean save(Question question, ArrayList<QuestionOption> questionOptions) {
        int questionId = questionRepository.save(question);
        if (questionId == 0) {
            ExceptionLogger.logError(QuestionService.class.getName(), "save", "Error getting question id: The id is 0.");
            return false;
        }
        for (QuestionOption questionOption : questionOptions) {
            questionOption.setQuestionId(questionId);
        }
        return optionRepository.saveBatch(questionOptions);
    }
    
    public boolean update(Question question) {
        return questionRepository.update(question);
    }
    
    public boolean delete(int id) {
        return questionRepository.delete(id);
    }
    
    public boolean deleteAllBySectionId(int sectionId) {
        return questionRepository.deleteAllBySectionId(sectionId);
    }
    
    public int countOptionsByQuestionId(int questionId) {
        return questionRepository.countOptionsByQuestionId(questionId);
    }
}
