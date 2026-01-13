package model;

import java.util.UUID;

public class Lesson {
    private UUID id;
    private UUID groupId;
    private String title;
    private String description;
    private String audioUrl;
    private String contentHtml;
    private int orderIndex;

    public Lesson() {
    }

    public Lesson(UUID id, UUID groupId, String title, String description, String audioUrl, String contentHtml, int orderIndex) {
        this.id = id;
        this.groupId = groupId;
        this.title = title;
        this.description = description;
        this.audioUrl = audioUrl;
        this.contentHtml = contentHtml;
        this.orderIndex = orderIndex;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getGroupId() {
        return groupId;
    }

    public void setGroupId(UUID groupId) {
        this.groupId = groupId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

    public String getContentHtml() {
        return contentHtml;
    }

    public void setContentHtml(String contentHtml) {
        this.contentHtml = contentHtml;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }
}
