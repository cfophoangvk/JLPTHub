package service;

import java.util.List;
import model.TestSection;
import repository.TestSectionRepository;

public class TestSectionService {
    private final TestSectionRepository sectionRepository = new TestSectionRepository();
    
    public List<TestSection> findAllByTestId(int testId) {
        return sectionRepository.findAllByTestId(testId);
    }
    
    public TestSection findById(int id) {
        return sectionRepository.findById(id);
    }
    
    public boolean save(TestSection section) {
        // Validate Choukai section must have audio
        if ("Choukai".equalsIgnoreCase(section.getSectionType())) {
            if (section.getAudioUrl() == null || section.getAudioUrl().trim().isEmpty()) {
                return false; // Choukai requires audio
            }
        }
        return sectionRepository.save(section);
    }
    
    public boolean update(TestSection section) {
        // Validate Choukai section must have audio
        if ("Choukai".equalsIgnoreCase(section.getSectionType())) {
            if (section.getAudioUrl() == null || section.getAudioUrl().trim().isEmpty()) {
                return false; // Choukai requires audio
            }
        }
        return sectionRepository.update(section);
    }
    
    public boolean delete(int id) {
        return sectionRepository.delete(id);
    }
    
    public boolean deleteAllByTestId(int testId) {
        return sectionRepository.deleteAllByTestId(testId);
    }
    
    public int countQuestionsBySectionId(int sectionId) {
        return sectionRepository.countQuestionsBySectionId(sectionId);
    }
    
    public boolean validateChoukaiAudio(String sectionType, String audioUrl) {
        if ("Choukai".equalsIgnoreCase(sectionType)) {
            return audioUrl != null && !audioUrl.trim().isEmpty();
        }
        return true;
    }
}
