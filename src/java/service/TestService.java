package service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import model.Question;
import model.QuestionOption;
import model.TargetLevel;
import model.Test;
import model.TestSection;
import model.UserTestAnswer;
import model.UserTestResult;
import model.UserTestSectionResult;
import repository.QuestionOptionRepository;
import repository.QuestionRepository;
import repository.TestRepository;
import repository.TestSectionRepository;
import repository.LearnerTestAnswerRepository;
import repository.LearnerTestResultRepository;
import repository.LearnerTestSectionResultRepository;

public class TestService {

    private final TestRepository testRepository = new TestRepository();
    private final TestSectionRepository testSectionRepository = new TestSectionRepository();
    private final QuestionRepository questionRepository = new QuestionRepository();
    private final QuestionOptionRepository questionOptionRepository = new QuestionOptionRepository();
    private final LearnerTestResultRepository userTestResultRepository = new LearnerTestResultRepository();
    private final LearnerTestAnswerRepository userTestAnswerRepository = new LearnerTestAnswerRepository();
    private final LearnerTestSectionResultRepository userTestSectionResultRepository = new LearnerTestSectionResultRepository();

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

    public List<Test> sortBy(String fieldName, boolean isAscending) {
        return testRepository.sortBy(fieldName, isAscending);
    }

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

    public List<TestSection> findSectionsByTestId(int testId) {
        List<TestSection> sections = testSectionRepository.findAllByTestId(testId);

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

    public UserTestResult submitTest(UUID userId, int testId, Map<Integer, Integer> answers, Integer durationSeconds) {
        Test test = testRepository.findById(testId);
        if (test == null) {
            return null;
        }

        List<TestSection> sections = findSectionsByTestId(testId);

        int totalScore = 0;
        boolean allSectionsPassed = true;

        List<UserTestSectionResult> sectionResults = new ArrayList<>();
        List<UserTestAnswer> testAnswers = new ArrayList<>();

        for (TestSection section : sections) {
            List<Question> questions = questionRepository.findAllBySectionId(section.getId());
            int correctCount = 0;

            for (Question question : questions) {
                List<QuestionOption> options = questionOptionRepository.findAllByQuestionId(question.getId());
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

                UserTestAnswer answer = new UserTestAnswer();
                answer.setQuestionId(question.getId());
                answer.setSelectedOptionId(selectedOptionId);
                answer.setCorrect(isCorrect);
                testAnswers.add(answer);
            }

            int sectionScore = 0;
            if (!questions.isEmpty()) {
                sectionScore = (int) Math.round((double) correctCount / questions.size() * section.getTotalScore());
            }
            boolean sectionPassed = sectionScore >= section.getPassScore();

            if (!sectionPassed) {
                allSectionsPassed = false;
            }

            UserTestSectionResult sectionResult = new UserTestSectionResult();
            sectionResult.setSectionId(section.getId());
            sectionResult.setCorrectAnswers(correctCount);
            sectionResult.setTotalQuestions(questions.size());
            sectionResult.setScoreObtained(sectionScore);
            sectionResult.setPassed(sectionPassed);
            sectionResults.add(sectionResult);

            totalScore += sectionScore;
        }

        int totalPassScore = sections.stream().mapToInt(TestSection::getPassScore).sum();
        boolean isPassed = totalScore >= totalPassScore && allSectionsPassed;

        UserTestResult result = new UserTestResult();
        result.setUserId(userId);
        result.setTestId(testId);
        result.setScoreObtained(totalScore);
        result.setPassed(isPassed);
        result.setTakenDate(LocalDateTime.now());
        result.setDurationSeconds(durationSeconds);

        int resultId = userTestResultRepository.save(result);
        result.setId(resultId);

        for (UserTestAnswer answer : testAnswers) {
            answer.setUserTestResultId(resultId);
        }
        userTestAnswerRepository.saveBatch(testAnswers);

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
