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

                    <ui:card title="Chỉnh sửa câu hỏi" className="max-w-4xl mx-auto my-4 px-4 py-8">

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
                                        <a href="${pageContext.request.contextPath}/admin/questions?sectionId=${sectionId}"
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
                                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">
                                            Chỉnh sửa
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="question-form" action="${pageContext.request.contextPath}/admin/questions/edit"
                            method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="${question.id}" />
                            <input type="hidden" name="sectionId" value="${sectionId}" />
                            <input type="hidden" name="existingImageUrl" value="${question.imageUrl}" />
                            <input type="hidden" name="deletedOptionIds" id="deletedOptionIds" value="" />

                            <div class="mb-4">
                                <ui:label label="Nội dung câu hỏi" htmlFor="questionContent" required="true" />
                                <ui:textarea id="questionContent" name="content" rows="5"
                                    placeholder="Nhập nội dung câu hỏi...">${question.content}</ui:textarea>
                            </div>

                            <div class="mb-4">
                                <ui:label label="Hình ảnh câu hỏi (Định dạng: JPG, PNG, GIF. Tối đa: 10MB)"
                                    htmlFor="image" />
                                <c:if test="${not empty question.imageUrl}">
                                    <div class="mb-2 p-3 bg-gray-50 rounded-lg">
                                        <p class="text-sm text-gray-600 mb-2">Hình ảnh hiện tại:</p>
                                        <img src="${question.imageUrl}" alt="Current image"
                                            class="max-h-48 object-contain rounded" />
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

                            <div class="mb-4">
                                <ui:label label="Câu trả lời: (Tích vào ô nếu là câu trả lời đúng)" htmlFor="" required="true" />
                                <input type="hidden" name="answerIsCorrect" value="${correctOption}">
                                <div id="answer-container">
                                    <c:forEach items="${options}" var="option" varStatus="status">
                                        <div class="flex mb-2 space-x-2 items-center"
                                            id="answerItem-existing-${option.id}">
                                            <%-- Track cái id và ảnh của từng thằng option --%>
                                                <input type="hidden" name="optionId" value="${option.id}" />
                                                <input type="hidden" name="existingOptionImageUrl"
                                                    value="${option.imageUrl}" />
                                                <input type="radio"
                                                    class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                                                    name="answerOption" ${option.correct ? 'checked' : '' }
                                                    onchange="this.setAttribute('checked', this.checked)" />
                                                <div
                                                    class="w-36 h-36 relative overflow-hidden rounded-lg border border-gray-300">
                                                    <button id="remove-image-existing-${option.id}" type="button"
                                                        class="absolute top-2 right-2 bg-white bg-opacity-75 rounded-full p-1 hover:bg-opacity-100 transition-colors z-10 ${empty option.imageUrl ? 'hidden' : ''}"
                                                        onclick="removeImage('existing-${option.id}')">
                                                        <jsp:include page="/assets/icon/x.jsp">
                                                            <jsp:param name="size" value="4" />
                                                        </jsp:include>
                                                    </button>
                                                    <input type="file" class="hidden"
                                                        id="file-input-existing-${option.id}" name="answerImage"
                                                        accept="image/*" onchange="previewImage(event, this.id)">

                                                    <label for="file-input-existing-${option.id}"
                                                        class="cursor-pointer w-full h-full block">
                                                        <div id="image-fallback-existing-${option.id}"
                                                            class="h-full w-full bg-gray-200 flex justify-center items-center ${empty option.imageUrl ? '' : 'hidden'}">
                                                            <i class="fa fa-image text-3xl"></i>
                                                        </div>
                                                        <img id="image-preview-existing-${option.id}"
                                                            src="${option.imageUrl}" alt="Preview"
                                                            class="w-full h-full object-cover ${empty option.imageUrl ? 'hidden' : ''}">
                                                        <div
                                                            class="absolute inset-0 w-full h-full bg-black/50 text-white flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                                                            <span>Thay đổi ảnh</span>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div class="flex-1">
                                                    <ui:textarea id="answerContent-${option.id}" name="answerContent"
                                                        placeholder="Nhập câu trả lời..." className="h-36 resize-none"
                                                        onInput="this.innerText=this.value">${option.content}</ui:textarea>
                                                </div>
                                                <button type="button"
                                                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-10 w-10 text-red-500 hover:text-red-700"
                                                    onclick="removeExistingAnswer(${option.id})">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                                        viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M18 6 6 18"></path>
                                                        <path d="m6 6 12 12"></path>
                                                    </svg>
                                                </button>
                                        </div>
                                    </c:forEach>
                                </div>
                                <p class="text-sm text-red-500" id="error-notEnoughAns"></p>

                                <ui:button className="space-x-2" onclick="addAnswer()">
                                    <jsp:include page="/assets/icon/plus.jsp">
                                        <jsp:param name="size" value="6" />
                                    </jsp:include>
                                    <span>Thêm câu trả lời...</span>
                                </ui:button>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/questions?sectionId=${sectionId}'">
                                    Hủy
                                </ui:button>
                                <ui:button onclick="doValidation()">
                                    Cập nhật
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-question-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn cập nhật câu hỏi này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="prepareForSubmit()">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        let deletedOptionIds = [];

                        const contentValidation = (value) => {
                            if (value.trim().length <= 0) {
                                return "Nội dung câu hỏi là bắt buộc!";
                            }
                            return "";
                        };

                        const answerValidation = (value) => {
                            if (value.trim().length <= 0) {
                                return "Câu trả lời là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('questionContent', contentValidation);
                            Array.from(document.querySelectorAll('textarea[name="answerContent"]')).forEach(el => {
                                const id = el.id;
                                isValid &= validateInput(id, answerValidation);
                            });

                            let numberOfAnswers = document.getElementById("answer-container").children.length;
                            if (numberOfAnswers < 2) {
                                document.getElementById("error-notEnoughAns").innerText = "Phải có ít nhất 2 đáp án!";
                                isValid = false;
                            } else {
                                document.getElementById("error-notEnoughAns").innerText = "";
                            }

                            if (isValid) {
                                openDialog('alert-question-form');
                            }
                        };

                        const prepareForSubmit = () => {
                            document.getElementById('deletedOptionIds').value = deletedOptionIds.join(',');

                            const isCorrectRadios = document.querySelectorAll("input[name='answerOption']");
                            Array.from(isCorrectRadios).forEach((c, index) => {
                                if (c.checked) document.querySelector("input[name='answerIsCorrect']").value = index;
                            });
                            submitForm('question-form');
                        };

                        let answerItemCount = 0;

                        const addAnswer = () => {
                            const answerElement = `<div class="flex mb-2 space-x-2 items-center" id="answerItem-new-\${answerItemCount}">
                                <input type="hidden" name="optionId" value="new" />
                                <input type="hidden" name="existingOptionImageUrl" value="" />
                                <input type="radio" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded" name="answerOption" onchange="this.setAttribute('checked', this.checked)">
                                <div class="w-36 h-36 relative overflow-hidden rounded-lg border border-gray-300">
                                  <button id="remove-image-new-\${answerItemCount}" type="button" class="absolute top-2 right-2 bg-white bg-opacity-75 rounded-full p-1 hover:bg-opacity-100 transition-colors z-10 hidden" onclick="removeImage('new-\${answerItemCount}')">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
                                      <path d="M18 6 6 18"></path>
                                      <path d="m6 6 12 12"></path>
                                    </svg>
                                  </button>
                                  <input type="file" class="hidden" accept="image/*" name="answerImage" id="file-input-new-\${answerItemCount}" onchange="previewImage(event, this.id)">
                                  <label for="file-input-new-\${answerItemCount}" class="cursor-pointer w-full h-full block">
                                    <div id="image-fallback-new-\${answerItemCount}" class="h-full w-full bg-gray-200 flex justify-center items-center"><i class="fa fa-image text-3xl"></i></div>
                                    <img id="image-preview-new-\${answerItemCount}" alt="Preview" class="w-full h-full object-cover hidden">
                                    <div class="absolute inset-0 w-full h-full bg-black/50 text-white flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                                      <span>Thay đổi ảnh</span>
                                    </div>
                                  </label>
                                </div>
                                <div class="flex-1">
                                  <textarea name="answerContent" id="answer-new-\${answerItemCount}" oninput="this.innerText=this.value" placeholder="Nhập câu trả lời..." rows="3" class="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 h-36 resize-none"></textarea>
                                  <p class="text-sm text-red-500 hidden" id="error-answer-new-\${answerItemCount}">Câu trả lời là bắt buộc!</p>
                                </div>
                                <button type="button" class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-10 w-10 text-red-500 hover:text-red-700" onclick="removeNewAnswer('new-\${answerItemCount}')">
                                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="">
                                    <path d="M18 6 6 18"></path>
                                    <path d="m6 6 12 12"></path>
                                  </svg>
                                </button>
                              </div>`;
                            document.getElementById('answer-container').insertAdjacentHTML('beforeend', answerElement);
                            answerItemCount++;
                        };

                        const removeNewAnswer = (id) => {
                            document.getElementById("answerItem-" + id).remove();
                        };

                        const removeExistingAnswer = (optionId) => {
                            deletedOptionIds.push(optionId);
                            document.getElementById("answerItem-existing-" + optionId).remove();
                        };

                        const previewImage = (event, id) => {
                            const idSuffix = id.replace('file-input-', '');

                            const reader = new FileReader();
                            reader.onload = function () {
                                document.getElementById("image-preview-" + idSuffix).src = reader.result;
                                document.getElementById("remove-image-" + idSuffix).classList.remove("hidden");
                                document.getElementById("image-fallback-" + idSuffix).classList.add("hidden");
                                document.getElementById("image-preview-" + idSuffix).classList.remove("hidden");
                            };
                            reader.readAsDataURL(event.target.files[0]);
                        };

                        const removeImage = (id) => {
                            const output = document.getElementById("image-preview-" + id);
                            output.src = "";
                            document.getElementById('file-input-' + id).value = "";
                            document.getElementById("remove-image-" + id).classList.add("hidden");
                            document.getElementById("image-fallback-" + id).classList.remove("hidden");
                            document.getElementById("image-preview-" + id).classList.add("hidden");

                            const answerItem = document.getElementById("answerItem-" + id);
                            if (answerItem) {
                                const hiddenField = answerItem.querySelector('input[name="existingOptionImageUrl"]');
                                if (hiddenField) {
                                    hiddenField.value = "";
                                }
                            }
                        };
                    </script>
                </layout:mainLayout>