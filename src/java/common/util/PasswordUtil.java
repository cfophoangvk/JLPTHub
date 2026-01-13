package common.util;

import common.logger.ExceptionLogger;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

public class PasswordUtil {
    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int SALT_LENGTH = 16;
    
    //Mã hóa password sử dụng thuật toán PBKDF2
    public static String hashPassword(String password) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = factory.generateSecret(spec).getEncoded();
            
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);
            
            return saltBase64 + ":" + hashBase64;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            ExceptionLogger.logError(PasswordUtil.class.getName(), "hashPassword", "Error hashing password: " + e.getMessage());
        }
        return null;
    }
    
    //Xác thực mật khẩu
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            String[] parts = storedHash.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
            
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] actualHash = factory.generateSecret(spec).getEncoded();
            
            // Constant-time comparison to prevent timing attacks
            if (expectedHash.length != actualHash.length) {
                return false;
            }
            
            int result = 0;
            for (int i = 0; i < expectedHash.length; i++) {
                result |= expectedHash[i] ^ actualHash[i];
            }
            return result == 0;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException | IllegalArgumentException e) {
            ExceptionLogger.logError(PasswordUtil.class.getName(), "verifyPassword", "Error verifying password: " + e.getMessage());
            return false;
        }
    }
}
