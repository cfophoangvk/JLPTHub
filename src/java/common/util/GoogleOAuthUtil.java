package common.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import common.constant.BaseURL;
import common.logger.ExceptionLogger;
import io.github.cdimascio.dotenv.Dotenv;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class GoogleOAuthUtil {

    private static final String GOOGLE_CLIENT_ID;
    private static final String GOOGLE_CLIENT_SECRET;
    private static final String GOOGLE_REDIRECT_URI;
    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    private static final Gson gson = new Gson();

    static {
        Dotenv dotenv = Dotenv.configure()
                .directory(BaseURL.ENV_DIRECTORY)
                .load();
        GOOGLE_CLIENT_ID = dotenv.get("GOOGLE_CLIENT_ID");
        GOOGLE_CLIENT_SECRET = dotenv.get("GOOGLE_CLIENT_SECRET");
        GOOGLE_REDIRECT_URI = dotenv.get("GOOGLE_REDIRECT_URI");
    }

    //Lấy URL đến trang đăng nhập Google
    public static String getAuthorizationUrl() {
        String scope = URLEncoder.encode("email profile", StandardCharsets.UTF_8);
        return GOOGLE_AUTH_URL
                + "?client_id=" + GOOGLE_CLIENT_ID
                + "&redirect_uri=" + URLEncoder.encode(GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&scope=" + scope
                + "&access_type=offline"
                + "&prompt=consent";
    }

    //Lấy token từ code sau khi đăng nhập Google
    public static String exchangeCodeForToken(String code) {
        try {
            URL url = new URL(GOOGLE_TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String params = "client_id=" + URLEncoder.encode(GOOGLE_CLIENT_ID, StandardCharsets.UTF_8)
                    + "&client_secret=" + URLEncoder.encode(GOOGLE_CLIENT_SECRET, StandardCharsets.UTF_8)
                    + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                    + "&grant_type=authorization_code"
                    + "&redirect_uri=" + URLEncoder.encode(GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes(StandardCharsets.UTF_8));
            }

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }
                    JsonObject jsonResponse = gson.fromJson(response.toString(), JsonObject.class);
                    return jsonResponse.get("access_token").getAsString();
                }
            } else {
                ExceptionLogger.logError(GoogleOAuthUtil.class.getName(), "exchangeCodeForToken", "Failed to exchange code for token: " + conn.getResponseCode());
            }
        } catch (IOException e) {
            ExceptionLogger.logError(GoogleOAuthUtil.class.getName(), "exchangeCodeForToken", "Error exchanging code for token: " + e.getMessage());
        }
        return null;
    }

    // Lấy thông tin người dùng Google từ token
    public static GoogleUserInfo getUserInfo(String accessToken) {
        try {
            URL url = new URL(GOOGLE_USERINFO_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                try (Reader reader = new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)) {
                    return gson.fromJson(reader, GoogleUserInfo.class);
                }
            } else {
                ExceptionLogger.logError(GoogleOAuthUtil.class.getName(), "getUserInfo", "Failed to get user info: " + conn.getResponseCode());
            }
        } catch (IOException e) {
            ExceptionLogger.logError(GoogleOAuthUtil.class.getName(), "getUserInfo", "Error getting user info: " + e.getMessage());
        }
        return null;
    }

    public static class GoogleUserInfo {

        private String id;
        private String email;
        private String name;
        private String picture;
        private boolean verified_email;

        public String getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public String getPicture() {
            return picture;
        }

        public boolean isVerifiedEmail() {
            return verified_email;
        }
    }
}
