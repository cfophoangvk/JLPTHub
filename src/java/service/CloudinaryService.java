package service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import common.constant.BaseURL;
import common.constant.Configuration;
import common.logger.ExceptionLogger;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.UUID;

public class CloudinaryService {

    private static Cloudinary cloudinary;

    static {
        try {
            Dotenv dotenv = Dotenv.configure()
                    .directory(BaseURL.ENV_DIRECTORY)
                    .load();
            String cloudName = dotenv.get("CLOUDINARY_CLOUD_NAME");
            String apiKey = dotenv.get("CLOUDINARY_API_KEY");
            String apiSecret = dotenv.get("CLOUDINARY_API_SECRET");

            cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", cloudName,
                    "api_key", apiKey,
                    "api_secret", apiSecret));
        } catch (Exception e) {
            ExceptionLogger.logError(CloudinaryService.class.getName(), "static initialization", "Error initializing Cloudinary: " + e.getMessage());
        }
    }

    //Upload hình ảnh lên cloud
    public String uploadImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        File file = null;
        try {
            file = convertPartToFile(filePart);
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "folder", BaseURL.CLOUDINARY_FLASHCARD_FOLDER
            );
            Map uploadResult = cloudinary.uploader().upload(file, uploadParams);
            return (String) uploadResult.get("secure_url");
        } catch (Exception e) {
            ExceptionLogger.logError(CloudinaryService.class.getName(), "uploadImage", "Error uploading image to Cloudinary: " + e.getMessage());
            return null;
        } finally {
            if (file != null && file.exists()) {
                file.delete();
            }
        }
    }

    // Upload audio lên cloud (sử dụng resource_type = "video" cho audio)
    public String uploadAudio(Part filePart, String folder) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        if (filePart.getSize() > Configuration.MAX_AUDIO_SIZE) {
            ExceptionLogger.logError(CloudinaryService.class.getName(), "uploadAudio", "Audio file exceeds 100MB limit: " + filePart.getSize() + " bytes");
            return null;
        }

        File file = null;
        try {
            file = convertPartToFile(filePart);
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "folder", folder,
                    "resource_type", "video"
            );
            Map uploadResult = cloudinary.uploader().upload(file, uploadParams);
            return (String) uploadResult.get("secure_url");
        } catch (Exception e) {
            ExceptionLogger.logError(CloudinaryService.class.getName(), "uploadAudio", "Error uploading audio to Cloudinary: " + e.getMessage());
            return null;
        } finally {
            if (file != null && file.exists()) {
                file.delete();
            }
        }
    }

    //Chuyển đổi các phần nhỏ thành file
    private File convertPartToFile(Part filePart) throws IOException {
        File file = new File(System.getProperty("java.io.tmpdir") + File.separator + UUID.randomUUID().toString() + "_" + getFileName(filePart));
        try (InputStream input = filePart.getInputStream(); FileOutputStream output = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        }
        return file;
    }

    //Lấy tên file
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
