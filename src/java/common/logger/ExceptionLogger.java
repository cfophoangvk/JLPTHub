package common.logger;

import java.util.logging.Level;
import java.util.logging.Logger;

public class ExceptionLogger {
    public static void logError(String className, String methodName, String message) {
        Logger.getLogger(className).logp(Level.SEVERE, className, methodName, message);
    }
}
