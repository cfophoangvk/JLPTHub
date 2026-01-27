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

                    <ui:card title="${not empty lesson ? 'Chỉnh sửa bài học' : 'Thêm bài học mới'}"
                        className="max-w-4xl mx-auto my-4 px-4 py-8">

                        <!-- Breadcrumb -->
                        <nav class="flex mb-6" aria-label="Breadcrumb">
                            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                                <li class="inline-flex items-center">
                                    <a href="${pageContext.request.contextPath}/admin/lesson-groups"
                                        class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600">
                                        Nhóm bài học
                                    </a>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/lessons?groupId=${groupId}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${group.name}
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
                                            ${not empty lesson ? 'Chỉnh sửa' : 'Tạo mới'}
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="lesson-form"
                            action="${pageContext.request.contextPath}/admin/lessons/${not empty lesson ? 'edit' : 'create'}"
                            method="POST" enctype="multipart/form-data">
                            <c:if test="${not empty lesson}">
                                <input type="hidden" name="id" value="${lesson.id}" />
                            </c:if>
                            <input type="hidden" name="groupId" value="${groupId}" />
                            <input type="hidden" name="existingAudioUrl" value="${lesson.audioUrl}" />

                            <div class="mb-4">
                                <ui:label label="Tiêu đề" htmlFor="title" required="true" />
                                <ui:input id="title" name="title" type="text" value="${lesson.title}"
                                    placeholder="Nhập tiêu đề bài học (tối đa 150 ký tự)..." />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Mô tả" htmlFor="description" />
                                <ui:textarea id="description" name="description" rows="3"
                                    placeholder="Nhập mô tả bài học...">${lesson.description}</ui:textarea>
                            </div>

                            <div class="mb-4">
                                <ui:label label="File Audio" htmlFor="audio" />
                                <c:if test="${not empty lesson.audioUrl}">
                                    <div class="mb-2 p-3 bg-gray-50 rounded-lg">
                                        <p class="text-sm text-gray-600 mb-2">Audio hiện tại:</p>
                                        <audio controls class="w-full">
                                            <source src="${lesson.audioUrl}" type="audio/mpeg">
                                            Trình duyệt không hỗ trợ audio.
                                        </audio>
                                    </div>
                                </c:if>
                                <div class="mt-1 flex items-center">
                                    <input type="file" id="audio" name="audio" accept="audio/*" class="block w-full text-sm text-gray-500
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-md file:border-0
                            file:text-sm file:font-semibold
                            file:bg-blue-50 file:text-blue-700
                            hover:file:bg-blue-100" onchange="validateAudioFile(this)" />
                                </div>
                                <p class="mt-1 text-sm text-gray-500">Định dạng: MP3, WAV, OGG. Tối đa: 100MB</p>
                                <p id="audioError" class="mt-1 text-sm text-red-600 hidden"></p>
                            </div>

                            <div class="mb-4">
                                <ui:label label="Nội dung HTML (Bài đọc/Ngữ pháp)" htmlFor="contentHtml" />
                                <ui:textarea id="contentHtml" name="contentHtml" rows="10"
                                    placeholder="Nhập nội dung HTML cho bài học...">${lesson.contentHtml}</ui:textarea>
                            </div>

                            <div class="mb-6">
                                <ui:label label="Thứ tự hiển thị" htmlFor="orderIndex" />
                                <ui:input id="orderIndex" name="orderIndex" type="number"
                                    value="${not empty lesson.orderIndex ? lesson.orderIndex : 0}"
                                    placeholder="Nhập thứ tự (số)..." />
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/lessons?groupId=${groupId}'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty lesson ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <!-- Confirmation Dialog -->
                    <ui:alertDialog id="alert-lesson-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty lesson ? 'cập nhật' : 'tạo'} bài học này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('lesson-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        // Maximum file size: 100MB
                        const MAX_AUDIO_SIZE = 100 * 1024 * 1024;
                        let audioFileValid = true;

                        const validateAudioFile = (input) => {
                            const errorEl = document.getElementById('audioError');
                            if (input.files && input.files[0]) {
                                const file = input.files[0];
                                if (file.size > MAX_AUDIO_SIZE) {
                                    errorEl.textContent = 'File audio quá lớn! Kích thước tối đa là 100MB. File hiện tại: ' +
                                        (file.size / (1024 * 1024)).toFixed(2) + 'MB';
                                    errorEl.classList.remove('hidden');
                                    audioFileValid = false;
                                } else {
                                    errorEl.classList.add('hidden');
                                    audioFileValid = true;
                                }
                            } else {
                                errorEl.classList.add('hidden');
                                audioFileValid = true;
                            }
                        };

                        const titleValidation = (value) => {
                            if (value.length <= 0) {
                                return "Tiêu đề bài học là bắt buộc!";
                            } else if (value.length > 150) {
                                return "Tiêu đề không được vượt quá 150 ký tự!";
                            } else
                                return "";
                        };

                        const orderIndexValidation = (value) => {
                            if (value !== "" && isNaN(parseInt(value))) {
                                return "Thứ tự phải là số!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('title', titleValidation);
                            isValid &= validateInput('orderIndex', orderIndexValidation);

                            // Check audio file validation
                            if (!audioFileValid) {
                                isValid = false;
                            }

                            if (isValid) {
                                openDialog('alert-lesson-form');
                            }
                        };
                    </script>
                </layout:mainLayout>