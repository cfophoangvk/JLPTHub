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

                    <ui:card title="${not empty question ? 'Chỉnh sửa câu hỏi' : 'Thêm câu hỏi mới'}"
                        className="max-w-4xl mx-auto my-4 px-4 py-8">

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
                                            ${not empty question ? 'Chỉnh sửa' : 'Tạo mới'}
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="question-form"
                            action="${pageContext.request.contextPath}/admin/questions/${not empty question ? 'edit' : 'create'}"
                            method="POST" enctype="multipart/form-data">
                            <c:if test="${not empty question}">
                                <input type="hidden" name="id" value="${question.id}" />
                            </c:if>
                            <input type="hidden" name="sectionId" value="${sectionId}" />
                            <input type="hidden" name="existingImageUrl" value="${question.imageUrl}" />

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
                                <ui:label label="Câu trả lời: (Tích vào ô nếu là câu trả lời đúng)" htmlFor=""
                                    required="true" />
                                <div id="answer-container">
                                    <div class="flex mb-2 space-x-2 items-center">
                                        <input type="checkbox"
                                            class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                                            name="answerIsCorrect"
                                            onchange="this.setAttribute('checked', this.checked)" />
                                        <div
                                            class="w-36 h-36 relative overflow-hidden rounded-lg border border-gray-300">
                                            <button id="remove-image-0" type="button"
                                                class="absolute top-2 right-2 bg-white bg-opacity-75 rounded-full p-1 hover:bg-opacity-100 transition-colors z-10 hidden"
                                                onclick="removeImage(0)">
                                                <jsp:include page="/assets/icon/x.jsp">
                                                    <jsp:param name="size" value="4" />
                                                </jsp:include>
                                            </button>
                                            <input type="file" class="hidden" id="file-input-0" name="answerImage"
                                                accept="image/*" onchange="previewImage(event, this.id)">

                                            <label for="file-input-0" class="cursor-pointer w-full h-full block">
                                                <div id="image-fallback-0"
                                                    class="h-full w-full bg-gray-200 flex justify-center items-center">
                                                    <i class="fa fa-image text-3xl"></i>
                                                </div>
                                                <img id="image-preview-0" alt="Preview"
                                                    class="w-full h-full object-cover hidden">
                                                <div
                                                    class="absolute inset-0 w-full h-full bg-black/50 text-white flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                                                    <span>Thay đổi ảnh</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="flex-1">
                                            <ui:textarea name="answerContent" placeholder="Nhập câu trả lời..."
                                                className="h-36 resize-none" onInput="this.innerText=this.value" />
                                        </div>
                                    </div>
                                </div>

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
                                    ${not empty question ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-question-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty question ? 'cập nhật' : 'tạo'} câu hỏi này không?
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
                        const contentValidation = (value) => {
                            if (value.length <= 0) {
                                return "Nội dung câu hỏi là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('questionContent', contentValidation);

                            if (isValid) {
                                openDialog('alert-question-form');
                            }
                        };

                        const prepareForSubmit = () => {
                            const isCorrectCheckboxes = document.querySelectorAll("input[name='answerIsCorrect']");
                            Array.from(isCorrectCheckboxes).forEach((c, index) => {
                                c.value = index;
                            });
                            submitForm('question-form');
                        };

                        let answerItemCount = 1;

                        const addAnswer = () => {
                            const answerElement = `<div class="flex mb-2 space-x-2 items-center" id="answerItem-\${answerItemCount}">
                                <input type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded" name="answerIsCorrect" onchange="this.setAttribute('checked', this.checked)">
                                <div class="w-36 h-36 relative overflow-hidden rounded-lg border border-gray-300">
                                  <button id="remove-image-\${answerItemCount}" type="button" class="absolute top-2 right-2 bg-white bg-opacity-75 rounded-full p-1 hover:bg-opacity-100 transition-colors z-10 hidden" onclick="removeImage(\${answerItemCount})">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
                                      <path d="M18 6 6 18"></path>
                                      <path d="m6 6 12 12"></path>
                                    </svg>
                                  </button>
                                  <input type="file" class="hidden" accept="image/*" name="answerImage" id="file-input-\${answerItemCount}" onchange="previewImage(event, this.id)">
                                  <label for="file-input-\${answerItemCount}" class="cursor-pointer w-full h-full block">
                                    <div id="image-fallback-\${answerItemCount}" class="h-full w-full bg-gray-200 flex justify-center items-center"><i class="fa fa-image text-3xl"></i></div>
                                    <img id="image-preview-\${answerItemCount}" alt="Preview" class="w-full h-full object-cover hidden">
                                    <div class="absolute inset-0 w-full h-full bg-black/50 text-white flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                                      <span>Thay đổi ảnh</span>
                                    </div>
                                  </label>
                                </div>
                                <div class="flex-1">
                                  <textarea name="answerContent" id="answer-\${answerItemCount}" oninput="this.innerText=this.value" placeholder="Nhập câu trả lời..." rows="3" class="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 h-36 resize-none"></textarea>
                                </div>
                                <button type="button" class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-10 w-10 text-red-500 hover:text-red-700" onclick="removeAnswer(\${answerItemCount})">
                                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="">
                                    <path d="M18 6 6 18"></path>
                                    <path d="m6 6 12 12"></path>
                                  </svg>
                                </button>
                              </div>`;
                            document.getElementById('answer-container').innerHTML += answerElement;
                            answerItemCount++;
                        };

                        const removeAnswer = (index) => {
                            document.getElementById("answerItem-" + index).remove();
                        };

                        const previewImage = (event, id) => {
                            const matches = id.match(/\d+/);
                            const number = matches ? parseInt(matches[0]) : 0;

                            const reader = new FileReader();
                            reader.onload = function () {
                                document.getElementById("image-preview-" + number).src = reader.result;
                                document.getElementById("remove-image-" + number).classList.remove("hidden");
                                document.getElementById("image-fallback-" + number).classList.add("hidden");
                                document.getElementById("image-preview-" + number).classList.remove("hidden");
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
                        };
                    </script>
                </layout:mainLayout>