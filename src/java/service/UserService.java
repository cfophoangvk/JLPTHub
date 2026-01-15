package service;

import common.logger.ExceptionLogger;
import model.TargetLevel;
import model.User;
import repository.UserRepository;

import java.util.UUID;

public class UserService {

    private final UserRepository userRepository = new UserRepository();

    //Tìm user thông qua ID
    public User getUserById(UUID userId) {
        return userRepository.findById(userId);
    }

    //Tìm user thông qua email
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    //Cập nhật thông tin người dùng
    public User updateProfile(UUID userId, String fullName, TargetLevel targetLevel) {
        User user = userRepository.findById(userId);
        if (user == null) {
            ExceptionLogger.logError(UserService.class.getName(), "updateProfile", "User not found for update: " + userId);
            return null;
        }

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }

        if (targetLevel != null) {
            user.setTargetLevel(targetLevel);
        }

        boolean updated = userRepository.update(user);
        if (!updated) {
            ExceptionLogger.logError(UserService.class.getName(), "updateProfile", "Failed to update user profile: " + userId);
            return null;
        }

        return user;
    }
}
