package model;

public class TestSection {
    private int id;
    private int testId;
    private int timeLimitMinutes;
    private String audioUrl;
    private String sectionType;
    private int passScore;
    private int totalScore;
    private boolean status;

    public TestSection() {
    }

    public TestSection(int id, int testId, int timeLimitMinutes, String audioUrl, String sectionType, int passScore, int totalScore, boolean status) {
        this.id = id;
        this.testId = testId;
        this.timeLimitMinutes = timeLimitMinutes;
        this.audioUrl = audioUrl;
        this.sectionType = sectionType;
        this.passScore = passScore;
        this.totalScore = totalScore;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getTimeLimitMinutes() {
        return timeLimitMinutes;
    }

    public void setTimeLimitMinutes(int timeLimitMinutes) {
        this.timeLimitMinutes = timeLimitMinutes;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

    public String getSectionType() {
        return sectionType;
    }

    public void setSectionType(String sectionType) {
        this.sectionType = sectionType;
    }

    public int getPassScore() {
        return passScore;
    }

    public void setPassScore(int passScore) {
        this.passScore = passScore;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
