package service;

import java.util.List;
import model.TargetLevel;
import model.Test;
import repository.TestRepository;

public class TestService {
    private final TestRepository testRepository = new TestRepository();
    
    public List<Test> findAll() {
        return testRepository.findAll();
    }
    
    public List<Test> findAllByLevel(TargetLevel level) {
        return testRepository.findAllByLevel(level);
    }
    
    public Test findById(int id) {
        return testRepository.findById(id);
    }
    
    public boolean save(Test test) {
        return testRepository.save(test);
    }
    
    public boolean update(Test test) {
        return testRepository.update(test);
    }
    
    public boolean delete(int id) {
        return testRepository.delete(id);
    }
    
    public int countSectionsByTestId(int testId) {
        return testRepository.countSectionsByTestId(testId);
    }
}
