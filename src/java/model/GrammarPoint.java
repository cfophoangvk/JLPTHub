package model;

import java.util.UUID;

public class GrammarPoint {
    private UUID id;
    private UUID lessonId;
    private String title;
    private String structure;
    private String explanation;
    private String example;

    public GrammarPoint() {
    }

    public GrammarPoint(UUID id, UUID lessonId, String title, String structure, String explanation, String example) {
        this.id = id;
        this.lessonId = lessonId;
        this.title = title;
        this.structure = structure;
        this.explanation = explanation;
        this.example = example;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getLessonId() {
        return lessonId;
    }

    public void setLessonId(UUID lessonId) {
        this.lessonId = lessonId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStructure() {
        return structure;
    }

    public void setStructure(String structure) {
        this.structure = structure;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getExample() {
        return example;
    }

    public void setExample(String example) {
        this.example = example;
    }
}
