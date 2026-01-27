package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import model.Lesson;
import repository.LessonRepository;

public class LessonService {
    private final LessonRepository lessonRepository = new LessonRepository();
    
    public List<Lesson> findAllByGroupId(UUID groupId) {
        return lessonRepository.findAllByGroupId(groupId);
    }
    
    public Map<UUID, Integer> countLessonsByGroups(List<UUID> groupIds) {
        Map<UUID, Integer> lessonCounts = new HashMap<>();
        for (UUID groupId : groupIds) {
            int numberOfLessons = lessonRepository.countByGroupId(groupId);
            lessonCounts.put(groupId, numberOfLessons);
        }
        
        return lessonCounts;
    }
    
    public Lesson findById(UUID id) {
        return lessonRepository.findById(id);
    }
    
    public boolean save(Lesson lesson) {
        return lessonRepository.save(lesson);
    }
    
    public boolean update(Lesson lesson) {
        return lessonRepository.update(lesson);
    }
    
    public boolean delete(UUID id) {
        return lessonRepository.delete(id);
    }
}
