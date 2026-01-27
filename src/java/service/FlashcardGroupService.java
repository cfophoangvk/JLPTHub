package service;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import model.FlashcardGroup;
import model.TargetLevel;
import repository.FlashcardGroupRepository;

public class FlashcardGroupService {
    private final FlashcardGroupRepository groupRepository = new FlashcardGroupRepository();
    
    public List<FlashcardGroup> findAll() {
        return groupRepository.findAll();
    }
    
    public List<FlashcardGroup> findFromN5LevelTo(TargetLevel level) {
        // Lấy các level từ N5 đến level hiện tại của user
        List<model.TargetLevel> levels = Arrays.stream(model.TargetLevel.values())
                .filter(l -> l.ordinal() <= level.ordinal())
                .collect(Collectors.toList());
        return groupRepository.findByLevels(levels);
    }
    
    public FlashcardGroup findById(UUID id) {
        return groupRepository.findById(id);
    }
    
    public boolean save(FlashcardGroup group) {
        return groupRepository.save(group);
    }
            
    public boolean update(FlashcardGroup group) {
        return groupRepository.update(group);
    }
    
    public boolean delete(UUID id) {
        return groupRepository.delete(id);
    }
}
