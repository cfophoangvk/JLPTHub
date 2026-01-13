package common.util;

import common.constant.BaseURL;
import common.logger.ExceptionLogger;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {
    private static final String SMTP_HOST;
    private static final int SMTP_PORT;
    private static final String SMTP_USERNAME;
    private static final String SMTP_PASSWORD;
    private static final String APP_BASE_URL;
    
    static {
        Dotenv dotenv = Dotenv.configure()
                .directory(BaseURL.ENV_DIRECTORY)
                .load();
        SMTP_HOST = dotenv.get("SMTP_HOST", "smtp.gmail.com");
        SMTP_PORT = Integer.parseInt(dotenv.get("SMTP_PORT", "587"));
        SMTP_USERNAME = dotenv.get("SMTP_USERNAME");
        SMTP_PASSWORD = dotenv.get("SMTP_PASSWORD");
        APP_BASE_URL = dotenv.get("APP_BASE_URL", "http://localhost:8080/JLPTHub");
    }
    
    //Tạo phiên làm việc với gmail (cấu hình mail trước khi gửi)
    private static Session getMailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
    }
    
    //Gửi email xác thực khi đăng ký
    public static boolean sendVerificationEmail(String toEmail, String token) {
        String subject = "JLPTHub - Xác thực email";
        String verificationLink = APP_BASE_URL + "/auth/verify-email?token=" + token;
        String htmlContent = """
            <html>
            <body style="font-family: Arial, sans-serif; padding: 20px;">
                <h2 style="color: #333;">Xác thực tài khoản JLPTHub</h2>
                <p>Xin chào,</p>
                <p>Cảm ơn bạn đã đăng ký tài khoản tại JLPTHub. Vui lòng click vào link dưới đây để xác thực email của bạn:</p>
                <p>
                    <a href="%s" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
                        Xác thực email
                    </a>
                </p>
                <p>Hoặc copy link sau vào trình duyệt:</p>
                <p><a href="%s">%s</a></p>
                <p>Link này sẽ hết hạn sau 24 giờ.</p>
                <p>Nếu bạn không đăng ký tài khoản này, vui lòng bỏ qua email này.</p>
                <br>
                <p>Trân trọng,<br>JLPTHub Team</p>
            </body>
            </html>
            """.formatted(verificationLink, verificationLink, verificationLink);
        
        return sendEmail(toEmail, subject, htmlContent);
    }
    
    //Gửi email đặt lại mật khẩu
    public static boolean sendPasswordResetEmail(String toEmail, String token) {
        String subject = "JLPTHub - Đặt lại mật khẩu";
        String resetLink = APP_BASE_URL + "/auth/reset-password?token=" + token;
        String htmlContent = """
            <html>
            <body style="font-family: Arial, sans-serif; padding: 20px;">
                <h2 style="color: #333;">Đặt lại mật khẩu JLPTHub</h2>
                <p>Xin chào,</p>
                <p>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản JLPTHub. Click vào link dưới đây để đặt lại mật khẩu:</p>
                <p>
                    <a href="%s" style="background-color: #2196F3; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
                        Đặt lại mật khẩu
                    </a>
                </p>
                <p>Hoặc copy link sau vào trình duyệt:</p>
                <p><a href="%s">%s</a></p>
                <p>Link này sẽ hết hạn sau 1 giờ.</p>
                <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>
                <br>
                <p>Trân trọng,<br>JLPTHub Team</p>
            </body>
            </html>
            """.formatted(resetLink, resetLink, resetLink);
        
        return sendEmail(toEmail, subject, htmlContent);
    }
    
    private static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        try {
            Session session = getMailSession();
            MimeMessage message = new MimeMessage(session);
            //người gửi
            message.setFrom(new InternetAddress(SMTP_USERNAME, "JLPTHub"));
            //người nhận
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            //tiêu đề - hỗ trợ Unicode
            message.setSubject(subject, "UTF-8");
            //nội dung
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            
            return true;
        } catch (Exception e) {
            ExceptionLogger.logError(EmailUtil.class.getName(), "sendEmail", "Failed to send email to: " + toEmail + e.getMessage());
            return false;
        }
    }
}
