package common.util;

import common.constant.BaseURL;
import common.constant.Configuration;
import common.logger.ExceptionLogger;
import io.github.cdimascio.dotenv.Dotenv;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import model.User;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.UUID;

public class JwtUtil {
    private static final SecretKey SECRET_KEY;
    
    static {
        Dotenv dotenv = Dotenv.configure()
                .directory(BaseURL.ENV_DIRECTORY)
                .load();
        String secretKeyString = dotenv.get("JWT_SECRET_KEY");
        if (secretKeyString == null || secretKeyString.length() < 32) {
            throw new RuntimeException("JWT_SECRET_KEY must be at least 32 characters");
        }
        SECRET_KEY = Keys.hmacShaKeyFor(secretKeyString.getBytes(StandardCharsets.UTF_8));
    }
    
    //Tạo JWT token cho người dùng
    public static String generateToken(User user) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + Configuration.JWT_EXPIRATION_TIME);
        
        return Jwts.builder()
                .setSubject(user.getId().toString())
                .claim("email", user.getEmail())
                .claim("fullName", user.getFullName())
                .claim("role", user.getRole())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact();
    }
    
    //Kiểm tra JWT Token
    public static boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (SignatureException e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "validateToken", "Invalid JWT signature: " + e.getMessage());
        } catch (MalformedJwtException e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "validateToken", "Invalid JWT token: " + e.getMessage());
        } catch (ExpiredJwtException e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "validateToken", "JWT token is expired: " + e.getMessage());
        } catch (UnsupportedJwtException e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "validateToken", "JWT token is unsupported: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "validateToken", "JWT claims string is empty: " + e.getMessage());
        }
        return false;
    }
    
    //Lấy ID người dùng từ JWT Token
    public static UUID getUserIdFromToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return UUID.fromString(claims.getSubject());
        } catch (Exception e) {
            ExceptionLogger.logError(JwtUtil.class.getName(), "getUserIdFromToken", "Error parsing JWT token: " + e.getMessage());
            return null;
        }
    }
}
