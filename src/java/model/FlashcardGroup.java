package model;

import java.time.LocalDateTime;
import java.util.UUID;

public class FlashcardGroup {
    private UUID id;
    private String name;
    private String description;
    private TargetLevel level;
    private LocalDateTime createdAt;
    private boolean status;

    public FlashcardGroup() {
    }

    public FlashcardGroup(UUID id, String name, String description, TargetLevel level, LocalDateTime createdAt, boolean status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.level = level;
        this.createdAt = createdAt;
        this.status = status;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public TargetLevel getLevel() {
        return level;
    }

    public void setLevel(TargetLevel level) {
        this.level = level;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
