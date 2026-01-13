package model;

public class UserTestAnswer {
    private int id;
    private int userTestResultId;
    private int questionId;
    private Integer selectedOptionId;
    private boolean isCorrect;

    public UserTestAnswer() {
    }

    public UserTestAnswer(int id, int userTestResultId, int questionId, Integer selectedOptionId, boolean isCorrect) {
        this.id = id;
        this.userTestResultId = userTestResultId;
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        this.isCorrect = isCorrect;
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

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(Integer selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
}
