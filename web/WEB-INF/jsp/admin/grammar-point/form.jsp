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

                    <ui:card title="${not empty grammarPoint ? 'Chỉnh sửa ngữ pháp' : 'Thêm ngữ pháp mới'}"
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
                                        <a href="${pageContext.request.contextPath}/admin/lessons?groupId=${lesson.groupId}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            Bài học
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
                                        <a href="${pageContext.request.contextPath}/admin/grammar-points?lessonId=${lessonId}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${lesson.title}
                                        </a>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="grammar-point-form"
                            action="${pageContext.request.contextPath}/admin/grammar-points/${not empty grammarPoint ? 'edit' : 'create'}"
                            method="POST">
                            <c:if test="${not empty grammarPoint}">
                                <input type="hidden" name="id" value="${grammarPoint.id}" />
                            </c:if>
                            <input type="hidden" name="lessonId" value="${lessonId}" />

                            <div class="mb-4">
                                <ui:label label="Tiêu đề" htmlFor="title" required="true" />
                                <ui:input id="title" name="title" type="text" value="${grammarPoint.title}"
                                    placeholder="Nhập tiêu đề ngữ pháp..." />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Cấu trúc" htmlFor="structure" />
                                <ui:input id="structure" name="structure" type="text" value="${grammarPoint.structure}"
                                    placeholder="VD: V-te + kudasai..." />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Giải thích" htmlFor="explanation" />
                                <ui:textarea id="explanation" name="explanation" rows="4"
                                    placeholder="Nhập giải thích chi tiết...">${grammarPoint.explanation}</ui:textarea>
                            </div>

                            <div class="mb-6">
                                <ui:label label="Ví dụ" htmlFor="example" />
                                <ui:textarea id="example" name="example" rows="4"
                                    placeholder="Nhập các ví dụ minh họa...">${grammarPoint.example}</ui:textarea>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/grammar-points?lessonId=${lessonId}'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty grammarPoint ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <!-- Confirmation Dialog -->
                    <ui:alertDialog id="alert-grammar-point-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty grammarPoint ? 'cập nhật' : 'tạo'} điểm ngữ pháp này
                                không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('grammar-point-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const titleValidation = (value) => {
                            if (value.length <= 0) {
                                return "Tiêu đề là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('title', titleValidation);

                            if (isValid) {
                                openDialog('alert-grammar-point-form');
                            }
                        };
                    </script>
                </layout:mainLayout>