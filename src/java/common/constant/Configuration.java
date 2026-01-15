package common.constant;

public class Configuration {

    public static final String JWT_COOKIE_NAME = "jwt_token";
    public static final long JWT_EXPIRATION_TIME = 24 * 60 * 60 * 1000;

    public static final int COOKIE_MAX_AGE = 24 * 60 * 60;
    public static final int EMAIL_VERIFICATION_HOURS = 24;
    public static final int PASSWORD_RESET_HOURS = 1;

    public static final long MAX_AUDIO_SIZE = 100L * 1024 * 1024;
}
