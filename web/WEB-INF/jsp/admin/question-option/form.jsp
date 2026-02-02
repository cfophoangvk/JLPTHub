<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <c:if test="${not empty error}">
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4 max-w-4xl mx-auto mt-4"
                            role="alert">
                            <span class="block sm:inline">${error}</span>
                        </div>
                    </c:if>

                    <ui:card title="${not empty option ? 'Chỉnh sửa lựa chọn' : 'Thêm lựa chọn mới'}"
                        className="max-w-4xl mx-auto my-4 px-4 py-8">

                        <!-- Breadcrumb -->
                        <nav class="flex mb-6" aria-label="Breadcrumb">
                            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                                <li class="inline-flex items-center">
                                    <a href="${pageContext.request.contextPath}/admin/tests"
                                        class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600">
                                        Bài test
                                    </a>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/test-sections?testId=${test.id}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${test.title}
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/questions?sectionId=${section.id}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${section.sectionType}
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/question-options?questionId=${questionId}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            Câu ${question.id}
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">
                                            ${not empty option ? 'Chỉnh sửa' : 'Tạo mới'}
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="option-form"
                            action="${pageContext.request.contextPath}/admin/question-options/${not empty option ? 'edit' : 'create'}"
                            method="POST" enctype="multipart/form-data">
                            <c:if test="${not empty option}">
                                <input type="hidden" name="id" value="${option.id}" />
                            </c:if>
                            <input type="hidden" name="questionId" value="${questionId}" />
                            <input type="hidden" name="existingImageUrl" value="${option.imageUrl}" />

                            <div class="mb-4">
                                <ui:label label="Nội dung lựa chọn" htmlFor="content" />
                                <ui:textarea id="content" name="content" rows="3"
                                    placeholder="Nhập nội dung lựa chọn...">${option.content}</ui:textarea>
                                <p class="mt-1 text-sm text-gray-500">Có thể để trống nếu lựa chọn chỉ có hình ảnh</p>
                            </div>

                            <div class="mb-4">
                                <ui:label label="Hình ảnh câu trả lời (Định dạng: JPG, PNG, GIF. Tối đa: 10MB)" htmlFor="image" />
                                <c:if test="${not empty option.imageUrl}">
                                    <div class="mb-2 p-3 bg-gray-50 rounded-lg">
                                        <p class="text-sm text-gray-600 mb-2">Hình ảnh hiện tại:</p>
                                        <img src="${option.imageUrl}" alt="Current image" class="max-h-32 object-contain rounded" />
                                    </div>
                                </c:if>
                                <div class="mt-1 flex items-center">
                                    <input type="file" id="image" name="image" accept="image/*" class="block w-full text-sm text-gray-500
                                        file:mr-4 file:py-2 file:px-4
                                        file:rounded-md file:border-0
                                        file:text-sm file:font-semibold
                                        file:bg-blue-50 file:text-blue-700
                                        hover:file:bg-blue-100" />
                                </div>
                            </div>

                            <div class="mb-6">
                                <div class="flex items-center">
                                    <input type="checkbox" id="isCorrect" name="isCorrect"
                                        class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                                        ${option.correct ? 'checked' : '' } />
                                    <label for="isCorrect" class="ml-2 block text-sm text-gray-900">
                                        Đây là đáp án đúng
                                    </label>
                                </div>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/question-options?questionId=${questionId}'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty option ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-option-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty option ? 'cập nhật' : 'tạo'} lựa chọn này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('option-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const doValidation = () => {
                            const content = document.getElementById('content').value.trim();
                            const imageInput = document.getElementById('image');
                            const existingImage = document.querySelector('input[name="existingImageUrl"]').value;

                            const hasContent = content.length > 0;
                            const hasNewImage = imageInput.files && imageInput.files.length > 0;
                            const hasExistingImage = existingImage && existingImage.trim() !== '';

                            if (!hasContent && !hasNewImage && !hasExistingImage) {
                                alert('Nội dung lựa chọn hoặc hình ảnh là bắt buộc!');
                                return;
                            }

                            openDialog('alert-option-form');
                        };
                    </script>
                </layout:mainLayout>