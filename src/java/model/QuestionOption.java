package model;

public class QuestionOption {
    private int id;
    private int questionId;
    private String content;
    private String imageUrl;
    private boolean isCorrect;

    public QuestionOption() {
    }

    public QuestionOption(int id, int questionId, String content, String imageUrl, boolean isCorrect) {
        this.id = id;
        this.questionId = questionId;
        this.content = content;
        this.imageUrl = imageUrl;
        this.isCorrect = isCorrect;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
}
