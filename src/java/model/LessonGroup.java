package model;

import java.util.UUID;

public class LessonGroup {
    private UUID id;
    private String name;
    private TargetLevel level;
    private int orderIndex;

    public LessonGroup() {
    }

    public LessonGroup(UUID id, String name, TargetLevel level, int orderIndex) {
        this.id = id;
        this.name = name;
        this.level = level;
        this.orderIndex = orderIndex;
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

    public TargetLevel getLevel() {
        return level;
    }

    public void setLevel(TargetLevel level) {
        this.level = level;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }
}
