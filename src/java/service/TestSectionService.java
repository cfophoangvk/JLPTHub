package service;

import common.constant.SectionTypeConstant;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
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
    
    public List<String> getCurrentTestSections(int testId) {
        return sectionRepository.getCurrentTestSections(testId);
    }
    
    public List<String> getMissingTestSections(int testId) {
        List<String> currentSections = getCurrentTestSections(testId);
        List<String> allSections = Arrays.asList(SectionTypeConstant.SECTION_TYPES);
        return allSections.stream().filter(section -> !currentSections.contains(section)).collect(Collectors.toList());
    }
    
    public boolean save(TestSection section) {
        if ("Choukai".equalsIgnoreCase(section.getSectionType())) {
            if (section.getAudioUrl() == null || section.getAudioUrl().trim().isEmpty()) {
                return false;
            }
        }
        return sectionRepository.save(section);
    }
    
    public boolean update(TestSection section) {
        if ("Choukai".equalsIgnoreCase(section.getSectionType())) {
            if (section.getAudioUrl() == null || section.getAudioUrl().trim().isEmpty()) {
                return false;
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
