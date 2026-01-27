package service;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import model.LessonGroup;
import model.TargetLevel;
import repository.LessonGroupRepository;

public class LessonGroupService {

    private final LessonGroupRepository groupRepository = new LessonGroupRepository();

    public List<LessonGroup> findAll() {
        return groupRepository.findAll();
    }

    public List<LessonGroup> findFromN5LevelTo(TargetLevel level) {
        // Lấy các level từ N5 đến level hiện tại của user
        List<model.TargetLevel> levels = Arrays.stream(model.TargetLevel.values())
                .filter(l -> l.ordinal() <= level.ordinal())
                .collect(Collectors.toList());
        return groupRepository.findByLevels(levels);
    }

    public LessonGroup findById(UUID id) {
        return groupRepository.findById(id);
    }

    public boolean save(LessonGroup group) {
        return groupRepository.save(group);
    }

    public boolean update(LessonGroup group) {
        return groupRepository.update(group);
    }

    public boolean delete(UUID id) {
        return groupRepository.delete(id);
    }
}
