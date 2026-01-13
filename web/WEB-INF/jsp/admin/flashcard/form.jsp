<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <c:if test="${not empty error}">
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                            role="alert">
                            <span class="block sm:inline">${error}</span>
                        </div>
                    </c:if>

                    <ui:card title="${not empty flashcard ? 'Chỉnh sửa thẻ trong bộ thẻ' : 'Thêm thẻ vào bộ thẻ'}"
                        className="max-w-2xl mx-auto my-4 px-4 py-8">
                        <form id="flashcard-form"
                            action="${pageContext.request.contextPath}/admin/flashcards/${not empty flashcard ? 'edit' : 'create'}"
                            method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="groupId" value="${groupId}" />

                            <c:if test="${not empty flashcard}">
                                <input type="hidden" name="id" value="${flashcard.id}" />
                                <input type="hidden" name="existingTermImage" value="${flashcard.termImageUrl}" />
                                <input type="hidden" name="existingDefinitionImage"
                                    value="${flashcard.definitionImageUrl}" />
                            </c:if>

                            <div class="mb-4">
                                <ui:label label="Thuật ngữ" htmlFor="term" required="true" />
                                <ui:input id="term" name="term" type="text" value="${flashcard.term}" />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Định nghĩa/Cách đọc" htmlFor="definition" required="true" />
                                <ui:input id="definition" name="definition" type="text"
                                    value="${flashcard.definition}" />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Ảnh thuật ngữ (không bắt buộc)" htmlFor="termImage" />
                                <c:if test="${not empty flashcard.termImageUrl}">
                                    <div class="mb-2">
                                        <img src="${flashcard.termImageUrl}" alt="Current Term Image"
                                            class="h-40 w-auto rounded border">
                                    </div>
                                </c:if>
                                <input type="file" name="termImage" id="termImage" accept="image/*"
                                    class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                            </div>

                            <div class="mb-6">
                                <ui:label label="Ảnh định nghĩa (không bắt buộc)" htmlFor="definitionImage" />
                                <c:if test="${not empty flashcard.definitionImageUrl}">
                                    <div class="mb-2">
                                        <img src="${flashcard.definitionImageUrl}" alt="Current Definition Image"
                                            class="h-40 w-auto rounded border">
                                    </div>
                                </c:if>
                                <input type="file" name="definitionImage" id="definitionImage" accept="image/*"
                                    class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/flashcards?groupId=${groupId}'">
                                    Hủy
                                </ui:button>
                                <ui:button onclick="doValidation()">
                                    ${not empty group ? 'Cập nhật' : 'Thêm'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-flashcard">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn lưu những thay đổi này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('flashcard-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const termValidation = (value) => {
                            if (value.length <= 0) {
                                return "Thuật ngữ là bắt buộc!";
                            } else if (value.length > 100) {
                                return "Thuật ngữ phải chứa không quá 100 ký tự!";
                            } else
                                return "";
                        };

                        const definitionValidation = (value) => {
                            if (value.length <= 0) {
                                return "Định nghĩa/Cách đọc là bắt buộc!";
                            } else if (value.length > 100) {
                                return "Định nghĩa/Cách đọc phải chứa không quá 100 ký tự!";
                            } else
                                return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('term', termValidation);
                            isValid &= validateInput('definition', definitionValidation);

                            if (isValid) {
                                openDialog('alert-flashcard');
                            }
                        };
                    </script>
                </layout:mainLayout>