<%@page contentType="text/html" pageEncoding="UTF-8" import="model.TargetLevel" %>
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

                    <ui:card title="${not empty group ? 'Chỉnh sửa bộ thẻ' : 'Thêm bộ thẻ mới'}"
                        className="max-w-2xl mx-auto my-4 px-4 py-8">
                        <form id="flashcard-group-form"
                            action="${pageContext.request.contextPath}/admin/flashcard-groups/${not empty group ? 'edit' : 'create'}"
                            method="POST">
                            <c:if test="${not empty group}">
                                <input type="hidden" name="id" value="${group.id}" />
                            </c:if>

                            <div class="mb-4">
                                <ui:label label="Tên" htmlFor="name" required="true" />
                                <ui:input id="name" name="name" type="text" value="${group.name}" />
                            </div>

                            <div class="mb-4">
                                <ui:label label="Mô tả" htmlFor="description" required="true" />
                                <ui:input id="description" name="description" type="text"
                                    value="${group.description}" />
                            </div>

                            <div class="mb-6">
                                <ui:label label="Cấp độ" htmlFor="level" required="true" />
                                <ui:select name="level" id="level" defaultValue="${group.level}">
                                    <ui:selectTrigger
                                        placeholder="${not empty group.level ? group.level : 'Chọn cấp độ'}"
                                        className="w-full mb-2" />

                                    <ui:selectContent>
                                        <c:forEach items="${TargetLevel.values()}" var="lvl">
                                            <ui:selectItem value="${lvl}">${lvl}</ui:selectItem>
                                        </c:forEach>
                                    </ui:selectContent>
                                </ui:select>
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/flashcard-groups'">
                                    Hủy
                                </ui:button>
                                <ui:button onclick="doValidation()">
                                    ${not empty group ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <ui:alertDialog id="alert-flashcard-group">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn lưu những thay đổi này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('flashcard-group-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const nameValidation = (value) => {
                            if (value.length <= 0) {
                                return "Tên là bắt buộc!";
                            } else if (value.length > 100) {
                                return "Tên phải chứa không quá 100 ký tự!";
                            } else
                                return "";
                        };

                        const descriptionValidation = (value) => {
                            if (value.length <= 0) {
                                return "Mô tả là bắt buộc!";
                            } else if (value.length > 100) {
                                return "Mô tả phải chứa không quá 100 ký tự!";
                            } else
                                return "";
                        };

                        const levelValidation = (value) => {
                            if (value === "") {
                                return "Cấp độ là bắt buộc!";
                            }
                            return "";
                        };

                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('name', nameValidation);
                            isValid &= validateInput('description', descriptionValidation);
                            isValid &= validateInput('level', levelValidation);

                            if (isValid) {
                                openDialog('alert-flashcard-group');
                            }
                        };
                    </script>
                </layout:mainLayout>