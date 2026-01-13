package model;

import java.util.UUID;

public class Flashcard {
    private UUID id;
    private UUID groupId;
    private String term;
    private String definition;
    private String termImageUrl;
    private String definitionImageUrl;

    public Flashcard() {
    }

    public Flashcard(UUID id, UUID groupId, String term, String definition, String termImageUrl, String definitionImageUrl) {
        this.id = id;
        this.groupId = groupId;
        this.term = term;
        this.definition = definition;
        this.termImageUrl = termImageUrl;
        this.definitionImageUrl = definitionImageUrl;
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

    public String getTerm() {
        return term;
    }

    public void setTerm(String term) {
        this.term = term;
    }

    public String getDefinition() {
        return definition;
    }

    public void setDefinition(String definition) {
        this.definition = definition;
    }

    public String getTermImageUrl() {
        return termImageUrl;
    }

    public void setTermImageUrl(String termImageUrl) {
        this.termImageUrl = termImageUrl;
    }

    public String getDefinitionImageUrl() {
        return definitionImageUrl;
    }

    public void setDefinitionImageUrl(String definitionImageUrl) {
        this.definitionImageUrl = definitionImageUrl;
    }
}
