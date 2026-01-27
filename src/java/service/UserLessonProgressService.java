package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import model.UserLessonProgress;
import repository.UserLessonProgressRepository;

public class UserLessonProgressService {

    private final UserLessonProgressRepository progressRepository = new UserLessonProgressRepository();

    public Set<UUID> findCompletedLessonsByGroup(UUID userId, UUID groupId) {
        List<UserLessonProgress> userProgress = progressRepository.findByUserAndGroup(userId, groupId);
        return userProgress.stream()
                .filter(UserLessonProgress::isCompleted)
                .map(UserLessonProgress::getLessonId)
                .collect(Collectors.toSet());
    }

    public Map<UUID, Integer> countCompletedByGroups(UUID userId, List<UUID> groupIds) {
        Map<UUID, Integer> completedCounts = new HashMap<>();
        for (UUID groupId : groupIds) {
            int numberOfLessons = progressRepository.countCompletedByGroup(userId, groupId);
            completedCounts.put(groupId, numberOfLessons);
        }

        return completedCounts;
    }

    public boolean markCompleted(UUID userId, UUID lessonId) {
        return progressRepository.markCompleted(userId, lessonId);
    }
}
