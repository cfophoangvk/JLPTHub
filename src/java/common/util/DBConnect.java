package common.util;

import common.constant.BaseURL;
import common.logger.ExceptionLogger;
import io.github.cdimascio.dotenv.Dotenv;
import java.sql.*;

public class DBConnect {

    private static Connection con = null;

    static {
        Dotenv dotenv = Dotenv.configure()
                .directory(BaseURL.ENV_DIRECTORY)
                .load();
        String url = dotenv.get("DB_URL");
        String user = dotenv.get("DB_USER");
        String pass = dotenv.get("DB_PASS");
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            ExceptionLogger.logError(DBConnect.class.getName(), "Connection", "Error during connection! " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        return con;
    }
}
