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

                    <ui:card title="${not empty test ? 'Chỉnh sửa bài test' : 'Thêm bài test mới'}"
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
                                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">
                                            ${not empty test ? 'Chỉnh sửa' : 'Tạo mới'}
                                        </span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <form id="test-form"
                            action="${pageContext.request.contextPath}/admin/tests/${not empty test ? 'edit' : 'create'}"
                            method="POST">
                            <c:if test="${not empty test}">
                                <input type="hidden" name="id" value="${test.id}" />
                            </c:if>

                            <div class="mb-4">
                                <ui:label label="Tiêu đề" htmlFor="title" required="true" />
                                <ui:input id="title" name="title" type="text" value="${test.title}"
                                    placeholder="Nhập tiêu đề bài test (tối đa 255 ký tự)..." />
                            </div>

                            <div class="mb-6">
                                <ui:label label="Cấp độ" htmlFor="level" required="true" />
                                <ui:select name="level" id="level" defaultValue="${test.level}">
                                    <ui:selectTrigger
                                        placeholder="${not empty test.level ? test.level : 'Chọn cấp độ'}"
                                        className="w-full" />
                                    <ui:selectContent>
                                        <c:forEach items="${levels}" var="i">
                                            <ui:selectItem value="${i}">${i}</ui:selectItem>
                                        </c:forEach>
                                    </ui:selectContent>
                                </ui:select>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button" onclick="location.href='${pageContext.request.contextPath}/admin/tests'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty test ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <!-- Confirmation Dialog -->
                    <ui:alertDialog id="alert-test-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty test ? 'cập nhật' : 'tạo'} bài test này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('test-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const titleValidation = (value) => {
                            if (value.trim().length <= 0) {
                                return "Tiêu đề bài test là bắt buộc!";
                            } else if (value.length > 255) {
                                return "Tiêu đề không được vượt quá 255 ký tự!";
                            } else
                                return "";
                        };

                        const levelValidation = (value) => {
                            if (!value.trim()) {
                                return "Cấp độ là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('title', titleValidation);
                            isValid &= validateSelect('level', levelValidation);

                            if (isValid) {
                                openDialog('alert-test-form');
                            }
                        };
                    </script>
                </layout:mainLayout>