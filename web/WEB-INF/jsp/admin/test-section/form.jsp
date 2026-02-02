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

                    <ui:card title="${not empty section ? 'Chỉnh sửa phần thi' : 'Thêm phần thi mới'}"
                        className="max-w-4xl mx-auto my-4 px-4 py-8">

                        <!-- Breadcrumb -->
                        <nav class="flex mb-6" aria-label="Breadcrumb">
                            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                                <li class="inline-flex items-center">
                                    <a href="${pageContext.request.contextPath}/admin/tests"
                                        class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600">
                                        Quản lý bài test
                                    </a>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/test-sections?testId=${testId}"
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
                                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">
                                            ${not empty section ? 'Chỉnh sửa' : 'Tạo mới'}
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="section-form"
                            action="${pageContext.request.contextPath}/admin/test-sections/${not empty section ? 'edit' : 'create'}"
                            method="POST" enctype="multipart/form-data">
                            <c:if test="${not empty section}">
                                <input type="hidden" name="id" value="${section.id}" />
                            </c:if>
                            <input type="hidden" name="testId" value="${testId}" />
                            <input type="hidden" name="existingAudioUrl" value="${section.audioUrl}" />

                            <div class="mb-4">
                                <ui:label label="Loại phần thi" htmlFor="sectionType" required="true" />
                                <ui:select name="sectionType" id="sectionType" defaultValue="${section.sectionType}" onChange="toggleAudioRequired">
                                    <ui:selectTrigger
                                        placeholder="${not empty type ? type : 'Chọn loại phần thi'}"
                                        className="w-full" />
                                    <ui:selectContent>
                                        <c:forEach items="${sectionTypes}" var="type">
                                            <ui:selectItem value="${type}">${type}</ui:selectItem>
                                        </c:forEach>
                                    </ui:selectContent>
                                </ui:select>
                            </div>

                            <div class="grid grid-cols-3 gap-4 mb-4">
                                <div>
                                    <ui:label label="Thời gian (phút)" htmlFor="timeLimitMinutes" />
                                    <ui:input id="timeLimitMinutes" name="timeLimitMinutes" type="number"
                                        value="${section.timeLimitMinutes}" placeholder="0" />
                                </div>
                                <div>
                                    <ui:label label="Điểm đạt" htmlFor="passScore" />
                                    <ui:input id="passScore" name="passScore" type="number" value="${section.passScore}" placeholder="0" />
                                </div>
                                <div>
                                    <ui:label label="Tổng điểm" htmlFor="totalScore" />
                                    <ui:input id="totalScore" name="totalScore" type="number"
                                        value="${section.totalScore}" placeholder="0" />
                                </div>
                            </div>

                            <div class="mb-4 hidden" id="audioField">
                                <ui:label label="File nghe" htmlFor="audio" required="true"/>
                                <c:if test="${not empty section.audioUrl}">
                                    <div class="mb-2 p-3 bg-gray-50 rounded-lg">
                                        <p class="text-sm text-gray-600 mb-2">Audio hiện tại:</p>
                                        <audio controls class="w-full">
                                            <source src="${section.audioUrl}" type="audio/mpeg">
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
                                <p id="audioError" class="mt-1 text-sm text-red-600"></p>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/test-sections?testId=${testId}'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty section ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-section-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty section ? 'cập nhật' : 'tạo'} phần thi này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('section-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        // Maximum file size: 100MB
                        const MAX_AUDIO_SIZE = 100 * 1024 * 1024;
                        let audioFileValid = true;

                        function toggleAudioRequired(sectionType) {
                            const label = document.getElementById('audioField');
                            if (sectionType === 'Choukai') {
                                label.classList.remove('hidden');
                            } else {
                                label.classList.add('hidden');
                            }
                        };

                        document.addEventListener('DOMContentLoaded', toggleAudioRequired);

                        const validateAudioFile = (input) => {
                            const errorEl = document.getElementById('audioError');
                            if (input.files && input.files[0]) {
                                const file = input.files[0];
                                if (file.size > MAX_AUDIO_SIZE) {
                                    errorEl.textContent = 'File nghe quá lớn! Kích thước tối đa là 100MB. File hiện tại: ' +
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
                        
                        const sectionTypeValidation = (value) => {
                            if (!value) {
                                return "Loại phần thi là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('sectionType', sectionTypeValidation);

                            if (document.getElementById('sectionType').value === 'Choukai') {
                                const audioInput = document.getElementById('audio');
                                const existingAudio = document.querySelector('input[name="existingAudioUrl"]').value;
                                const hasNewAudio = audioInput.files && audioInput.files.length > 0;
                                const hasExistingAudio = existingAudio && existingAudio.trim() !== '';

                                if (!hasNewAudio && !hasExistingAudio) {
                                    document.getElementById('audioError').innerText = "Phần Choukai (聴解) bắt buộc phải có file nghe!";
                                    isValid = false;
                                } else {
                                    document.getElementById('audioError').innerText = "";
                                }
                            }

                            if (!audioFileValid) {
                                isValid = false;
                            }

                            if (isValid) {
                                openDialog('alert-section-form');
                            }
                        };
                    </script>
                </layout:mainLayout>