package model;

public class Question {
    private int id;
    private int sectionId;
    private String content;
    private String imageUrl;

    public Question() {
    }

    public Question(int id, int sectionId, String content, String imageUrl) {
        this.id = id;
        this.sectionId = sectionId;
        this.content = content;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSectionId() {
        return sectionId;
    }

    public void setSectionId(int sectionId) {
        this.sectionId = sectionId;
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
}
