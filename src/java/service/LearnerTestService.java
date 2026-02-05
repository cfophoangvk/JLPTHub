package service;

import model.*;
import repository.*;

import java.time.LocalDateTime;
import java.util.*;

public class LearnerTestService {

    private final TestRepository testRepository = new TestRepository();
    private final TestSectionRepository testSectionRepository = new TestSectionRepository();
    private final QuestionRepository questionRepository = new QuestionRepository();
    private final QuestionOptionRepository questionOptionRepository = new QuestionOptionRepository();
    private final UserTestResultRepository userTestResultRepository = new UserTestResultRepository();
    private final UserTestAnswerRepository userTestAnswerRepository = new UserTestAnswerRepository();
    private final UserTestSectionResultRepository userTestSectionResultRepository = new UserTestSectionResultRepository();

    /**
     * Get list of tests from N5 up to user's current level
     */
    public List<Test> findTestsForUser(TargetLevel userLevel) {
        List<Test> allTests = new ArrayList<>();
        TargetLevel[] levels = TargetLevel.values();
        
        for (TargetLevel level : levels) {
            allTests.addAll(testRepository.findAllByLevel(level));
            if (level == userLevel) {
                break;
            }
        }
        return allTests;
    }

    /**
     * Get list of tests by specific level
     */
    public List<Test> findTestsByLevel(TargetLevel level) {
        return testRepository.findAllByLevel(level);
    }

    public Test findTestById(int id) {
        return testRepository.findById(id);
    }

    /**
     * Get sections sorted by type order: Moji/Goi -> Bunpou -> Choukai
     */
    public List<TestSection> findSectionsByTestId(int testId) {
        List<TestSection> sections = testSectionRepository.findAllByTestId(testId);
        
        // Sort by section type order
        Map<String, Integer> order = new HashMap<>();
        order.put("Moji/Goi", 1);
        order.put("Bunpou", 2);
        order.put("Choukai", 3);
        
        sections.sort((a, b) -> {
            int orderA = order.getOrDefault(a.getSectionType(), 99);
            int orderB = order.getOrDefault(b.getSectionType(), 99);
            return Integer.compare(orderA, orderB);
        });
        
        return sections;
    }

    public TestSection findSectionById(int sectionId) {
        return testSectionRepository.findById(sectionId);
    }

    public List<Question> findQuestionsBySectionId(int sectionId) {
        return questionRepository.findAllBySectionId(sectionId);
    }

    public List<QuestionOption> findOptionsByQuestionId(int questionId) {
        return questionOptionRepository.findAllByQuestionId(questionId);
    }

    public int countSectionsByTestId(int testId) {
        return testRepository.countSectionsByTestId(testId);
    }

    /**
     * Submit test and calculate scores
     * @param userId User ID
     * @param testId Test ID
     * @param answers Map of questionId -> selectedOptionId
     * @param durationSeconds Time taken in seconds
     * @return UserTestResult with calculated scores
     */
    public UserTestResult submitTest(UUID userId, int testId, Map<Integer, Integer> answers, Integer durationSeconds) {
        Test test = testRepository.findById(testId);
        if (test == null) {
            return null;
        }

        List<TestSection> sections = findSectionsByTestId(testId);
        
        // Calculate scores
        int totalScore = 0;
        int totalMaxScore = 0;
        boolean allSectionsPassed = true;
        
        List<UserTestSectionResult> sectionResults = new ArrayList<>();
        List<UserTestAnswer> testAnswers = new ArrayList<>();
        
        for (TestSection section : sections) {
            List<Question> questions = findQuestionsBySectionId(section.getId());
            int correctCount = 0;
            
            for (Question question : questions) {
                List<QuestionOption> options = findOptionsByQuestionId(question.getId());
                Integer selectedOptionId = answers.get(question.getId());
                
                boolean isCorrect = false;
                if (selectedOptionId != null) {
                    for (QuestionOption option : options) {
                        if (option.getId() == selectedOptionId && option.isCorrect()) {
                            isCorrect = true;
                            correctCount++;
                            break;
                        }
                    }
                }
                
                // Create answer record
                UserTestAnswer answer = new UserTestAnswer();
                answer.setQuestionId(question.getId());
                answer.setSelectedOptionId(selectedOptionId);
                answer.setCorrect(isCorrect);
                testAnswers.add(answer);
            }
            
            // Calculate section score proportionally
            int sectionScore = 0;
            if (!questions.isEmpty()) {
                sectionScore = (int) Math.round((double) correctCount / questions.size() * section.getTotalScore());
            }
            boolean sectionPassed = sectionScore >= section.getPassScore();
            
            if (!sectionPassed) {
                allSectionsPassed = false;
            }
            
            // Create section result
            UserTestSectionResult sectionResult = new UserTestSectionResult();
            sectionResult.setSectionId(section.getId());
            sectionResult.setCorrectAnswers(correctCount);
            sectionResult.setTotalQuestions(questions.size());
            sectionResult.setScoreObtained(sectionScore);
            sectionResult.setPassed(sectionPassed);
            sectionResults.add(sectionResult);
            
            totalScore += sectionScore;
            totalMaxScore += section.getTotalScore();
        }
        
        // Calculate if passed overall
        int totalPassScore = sections.stream().mapToInt(TestSection::getPassScore).sum();
        boolean isPassed = totalScore >= totalPassScore && allSectionsPassed;
        
        // Save main result
        UserTestResult result = new UserTestResult();
        result.setUserId(userId);
        result.setTestId(testId);
        result.setScoreObtained(totalScore);
        result.setPassed(isPassed);
        result.setTakenDate(LocalDateTime.now());
        result.setDurationSeconds(durationSeconds);
        
        int resultId = userTestResultRepository.save(result);
        result.setId(resultId);
        
        // Update and save answers
        for (UserTestAnswer answer : testAnswers) {
            answer.setUserTestResultId(resultId);
        }
        userTestAnswerRepository.saveBatch(testAnswers);
        
        // Update and save section results
        for (UserTestSectionResult sectionResult : sectionResults) {
            sectionResult.setUserTestResultId(resultId);
        }
        userTestSectionResultRepository.saveBatch(sectionResults);
        
        return result;
    }

    public UserTestResult findResultById(int resultId) {
        return userTestResultRepository.findById(resultId);
    }

    public List<UserTestSectionResult> findSectionResultsByResultId(int resultId) {
        return userTestSectionResultRepository.findAllByResultId(resultId);
    }

    public List<UserTestResult> findResultsByUserAndTestId(UUID userId, int testId) {
        return userTestResultRepository.findByUserAndTestId(userId, testId);
    }
}
