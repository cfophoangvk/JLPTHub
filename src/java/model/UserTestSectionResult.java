package model;

public class UserTestSectionResult {
    private int id;
    private int userTestResultId;
    private int sectionId;
    private int correctAnswers;
    private int totalQuestions;
    private int scoreObtained;
    private boolean isPassed;
    
    // Additional field for display purposes (not in DB)
    private String sectionType;

    public UserTestSectionResult() {
    }

    public UserTestSectionResult(int id, int userTestResultId, int sectionId, int correctAnswers, 
                                  int totalQuestions, int scoreObtained, boolean isPassed) {
        this.id = id;
        this.userTestResultId = userTestResultId;
        this.sectionId = sectionId;
        this.correctAnswers = correctAnswers;
        this.totalQuestions = totalQuestions;
        this.scoreObtained = scoreObtained;
        this.isPassed = isPassed;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserTestResultId() {
        return userTestResultId;
    }

    public void setUserTestResultId(int userTestResultId) {
        this.userTestResultId = userTestResultId;
    }

    public int getSectionId() {
        return sectionId;
    }

    public void setSectionId(int sectionId) {
        this.sectionId = sectionId;
    }

    public int getCorrectAnswers() {
        return correctAnswers;
    }

    public void setCorrectAnswers(int correctAnswers) {
        this.correctAnswers = correctAnswers;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getScoreObtained() {
        return scoreObtained;
    }

    public void setScoreObtained(int scoreObtained) {
        this.scoreObtained = scoreObtained;
    }

    public boolean isPassed() {
        return isPassed;
    }

    public void setPassed(boolean passed) {
        isPassed = passed;
    }

    public String getSectionType() {
        return sectionType;
    }

    public void setSectionType(String sectionType) {
        this.sectionType = sectionType;
    }
}
