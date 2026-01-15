package service;

import common.constant.Configuration;
import common.logger.ExceptionLogger;
import common.util.EmailUtil;
import common.util.GoogleOAuthUtil;
import common.util.JwtUtil;
import common.util.PasswordUtil;
import model.TargetLevel;
import model.User;
import repository.UserRepository;
import common.constant.RoleConstant;

import java.time.LocalDateTime;
import java.util.UUID;

public class AuthService {

    private final UserRepository userRepository = new UserRepository();

    //Đăng ký tài khoản -> gửi mail xác thực
    public AuthResult register(String email, String password, String fullName, TargetLevel targetLevel) {
        User existingUser = userRepository.findByEmail(email);
        if (existingUser != null) {
            return new AuthResult(false, "Email đã được sử dụng", null, null);
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setFullName(fullName);
        user.setTargetLevel(targetLevel);
        user.setRole(RoleConstant.LEARNER);
        user.setIsEmailVerified(false);
        user.setAuthProvider("local");

        UUID verificationToken = UUID.randomUUID();
        user.setEmailVerificationToken(verificationToken);
        user.setEmailVerificationTokenExpire(LocalDateTime.now().plusHours(Configuration.EMAIL_VERIFICATION_HOURS));

        User savedUser = userRepository.save(user);
        if (savedUser == null) {
            return new AuthResult(false, "Lỗi khi tạo tài khoản", null, null);
        }

        boolean emailSent = EmailUtil.sendVerificationEmail(email, verificationToken.toString());
        if (!emailSent) {
            ExceptionLogger.logError(AuthService.class.getName(), "register", "Failed to send verification email to: " + email);
        }

        return new AuthResult(true, "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.", null, savedUser);
    }

    //Đăng nhập
    public AuthResult login(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            return new AuthResult(false, "Email hoặc mật khẩu không đúng", null, null);
        }

        if ("google".equals(user.getAuthProvider())) {
            return new AuthResult(false, "Tài khoản này đã đăng ký bằng Google. Vui lòng đăng nhập bằng Google.", null, null);
        }

        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            return new AuthResult(false, "Email hoặc mật khẩu không đúng", null, null);
        }

        if (!user.isIsEmailVerified()) {
            return new AuthResult(false, "Vui lòng xác thực email trước khi đăng nhập", null, null);
        }

        String token = JwtUtil.generateToken(user);
        return new AuthResult(true, "Đăng nhập thành công", token, user);
    }

    //Đăng nhập/đăng ký Google
    public AuthResult loginWithGoogle(String code) {
        String accessToken = GoogleOAuthUtil.exchangeCodeForToken(code);
        if (accessToken == null) {
            return new AuthResult(false, "Không thể xác thực với Google", null, null);
        }

        GoogleOAuthUtil.GoogleUserInfo googleUser = GoogleOAuthUtil.getUserInfo(accessToken);
        if (googleUser == null) {
            return new AuthResult(false, "Không thể lấy thông tin từ Google", null, null);
        }

        User user = userRepository.findByGoogleId(googleUser.getId());
        if (user != null) {
            String token = JwtUtil.generateToken(user);
            return new AuthResult(true, "Đăng nhập thành công", token, user);
        }

        //Tìm user trong hệ thống
        user = userRepository.findByEmail(googleUser.getEmail());
        if (user != null) {
            user.setGoogleId(googleUser.getId());
            user.setAuthProvider("google");
            user.setIsEmailVerified(true);
            userRepository.update(user);

            String token = JwtUtil.generateToken(user);
            return new AuthResult(true, "Đăng nhập thành công", token, user);
        }

        // Nếu không có user đó thì tạo mới
        user = new User();
        user.setEmail(googleUser.getEmail());
        user.setFullName(googleUser.getName());
        user.setGoogleId(googleUser.getId());
        user.setAuthProvider("google");
        user.setIsEmailVerified(true);
        user.setRole(RoleConstant.LEARNER);
        user.setTargetLevel(TargetLevel.N5);

        User savedUser = userRepository.save(user);
        if (savedUser == null) {
            return new AuthResult(false, "Lỗi khi tạo tài khoản", null, null);
        }

        String token = JwtUtil.generateToken(savedUser);
        return new AuthResult(true, "Đăng ký thành công với Google", token, savedUser);
    }

    //Xác thực email
    public AuthResult verifyEmail(UUID token) {
        User user = userRepository.findByEmailVerificationToken(token);
        if (user == null) {
            return new AuthResult(false, "Token không hợp lệ", null, null);
        }

        if (user.getEmailVerificationTokenExpire().isBefore(LocalDateTime.now())) {
            return new AuthResult(false, "Token đã hết hạn. Vui lòng đăng ký lại.", null, null);
        }

        user.setIsEmailVerified(true);
        user.setEmailVerificationToken(null);
        user.setEmailVerificationTokenExpire(null);

        boolean updated = userRepository.update(user);
        if (!updated) {
            return new AuthResult(false, "Lỗi khi xác thực email", null, null);
        }

        return new AuthResult(true, "Xác thực email thành công! Bạn có thể đăng nhập ngay.", null, user);
    }

    // Yêu cầu gửi email khi quên mật khẩu
    public AuthResult forgotPassword(String email) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            return new AuthResult(false, "Email không tồn tại!", null, null);
        }

        if ("google".equals(user.getAuthProvider())) {
            return new AuthResult(false, "Tài khoản này đăng ký bằng Google. Vui lòng đăng nhập bằng Google.", null, null);
        }

        UUID resetToken = UUID.randomUUID();
        user.setPasswordResetToken(resetToken);
        user.setPasswordResetTokenExpire(LocalDateTime.now().plusHours(Configuration.PASSWORD_RESET_HOURS));

        boolean updated = userRepository.update(user);
        if (!updated) {
            return new AuthResult(false, "Lỗi khi tạo token đặt lại mật khẩu", null, null);
        }

        boolean emailSent = EmailUtil.sendPasswordResetEmail(email, resetToken.toString());
        if (!emailSent) {
            ExceptionLogger.logError(AuthService.class.getName(), "forgotPassword", "Failed to send password reset email to: " + email);
        }

        return new AuthResult(true, "Vui lòng kiểm tra email để lấy link đặt lại mật khẩu.", null, null);
    }

    // Đặt lại mật khẩu
    public AuthResult resetPassword(UUID token, String newPassword) {
        User user = userRepository.findByPasswordResetToken(token);
        if (user == null) {
            return new AuthResult(false, "Token không hợp lệ", null, null);
        }

        if (user.getPasswordResetTokenExpire().isBefore(LocalDateTime.now())) {
            return new AuthResult(false, "Token đã hết hạn. Vui lòng yêu cầu đặt lại mật khẩu mới.", null, null);
        }

        user.setPassword(PasswordUtil.hashPassword(newPassword));
        user.setPasswordResetToken(null);
        user.setPasswordResetTokenExpire(null);

        boolean updated = userRepository.update(user);
        if (!updated) {
            return new AuthResult(false, "Lỗi khi đặt lại mật khẩu", null, null);
        }

        return new AuthResult(true, "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập ngay.", null, user);
    }

    //Gửi lại mail xác thực (trong trường hợp không nhận được hoặc có lỗi gửi mail)
    public AuthResult resendVerificationEmail(String email) {
        User user = userRepository.findByEmail(email);
        if (user == null || user.isIsEmailVerified()) {
            return new AuthResult(true, "Nếu email chưa được xác thực, bạn sẽ nhận được email xác thực mới.", null, null);
        }

        UUID verificationToken = UUID.randomUUID();
        user.setEmailVerificationToken(verificationToken);
        user.setEmailVerificationTokenExpire(LocalDateTime.now().plusHours(Configuration.EMAIL_VERIFICATION_HOURS));

        boolean updated = userRepository.update(user);
        if (!updated) {
            return new AuthResult(false, "Lỗi khi tạo token xác thực", null, null);
        }

        boolean emailSent = EmailUtil.sendVerificationEmail(email, verificationToken.toString());
        if (!emailSent) {
            ExceptionLogger.logError(AuthService.class.getName(), "resendVerificationEmail", "Failed to resend verification email to: " + email);
        }

        return new AuthResult(true, "Email xác thực đã được gửi lại. Vui lòng kiểm tra hộp thư.", null, null);
    }

    public static class AuthResult {

        private final boolean success;
        private final String message;
        private final String token;
        private final User user;

        public AuthResult(boolean success, String message, String token, User user) {
            this.success = success;
            this.message = message;
            this.token = token;
            this.user = user;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }

        public String getToken() {
            return token;
        }

        public User getUser() {
            return user;
        }
    }
}
