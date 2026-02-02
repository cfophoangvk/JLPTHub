package model;

import java.time.LocalDateTime;

public class Test {
    private int id;
    private String title;
    private TargetLevel level;
    private LocalDateTime createdAt;
    private boolean status;

    public Test() {
    }

    public Test(int id, String title, TargetLevel level, LocalDateTime createdAt, boolean status) {
        this.id = id;
        this.title = title;
        this.level = level;
        this.createdAt = createdAt;
        this.status = status;
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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
