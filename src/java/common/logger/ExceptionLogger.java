package common.logger;

public class ExceptionLogger {
    public static void logError(String className, String methodName, String message) {
        System.err.println("ERROR [" + className + ", method " + methodName + "]: " + message);
    }
}
