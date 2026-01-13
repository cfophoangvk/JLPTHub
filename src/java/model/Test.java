package model;

import java.time.LocalDateTime;

public class Test {
    private int id;
    private String title;
    private TargetLevel level;
    private LocalDateTime createdAt;

    public Test() {
    }

    public Test(int id, String title, TargetLevel level, LocalDateTime createdAt) {
        this.id = id;
        this.title = title;
        this.level = level;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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
}
