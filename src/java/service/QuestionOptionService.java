package service;

import common.constant.BaseURL;
import jakarta.servlet.http.Part;
import java.util.List;
import model.QuestionOption;
import repository.QuestionOptionRepository;

public class QuestionOptionService {

    private final QuestionOptionRepository optionRepository = new QuestionOptionRepository();
    private final CloudinaryService cloudinaryService = new CloudinaryService();

    public List<QuestionOption> findAllByQuestionId(int id) {
        return optionRepository.findAllByQuestionId(id);
    }

    public QuestionOption findById(int id) {
        return optionRepository.findById(id);
    }

    public boolean save(QuestionOption option) {
        return optionRepository.save(option);
    }

    public boolean update(QuestionOption option) {
        return optionRepository.update(option);
    }

    public boolean delete(int optionId) {
        return optionRepository.delete(optionId);
    }

    public String getUpdatedImageUrl(Part newImagePart, String oldImageUrl) {
        String updatedImageUrl = null;
        if (newImagePart != null && newImagePart.getSize() > 0 && !newImagePart.getSubmittedFileName().isEmpty()) {
            updatedImageUrl = cloudinaryService.uploadImage(newImagePart, BaseURL.CLOUDINARY_TEST_FOLDER);
        }
        if (updatedImageUrl == null) {
            updatedImageUrl = oldImageUrl;
        }
        return updatedImageUrl.equals("") ? null : updatedImageUrl;
    }
}
