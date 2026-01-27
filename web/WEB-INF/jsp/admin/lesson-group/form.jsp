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

                    <ui:card title="${not empty group ? 'Chỉnh sửa nhóm bài học' : 'Thêm nhóm bài học mới'}"
                        className="max-w-2xl mx-auto my-4 px-4 py-8">
                        <form id="lesson-group-form"
                            action="${pageContext.request.contextPath}/admin/lesson-groups/${not empty group ? 'edit' : 'create'}"
                            method="POST">
                            <c:if test="${not empty group}">
                                <input type="hidden" name="id" value="${group.id}" />
                            </c:if>

                            <div class="mb-4">
                                <ui:label label="Tên nhóm" htmlFor="name" required="true" />
                                <ui:input id="name" name="name" type="text" value="${group.name}"
                                    placeholder="Nhập tên nhóm bài học..." />
                            </div>

                            <div class="mb-4">
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

                            <div class="mb-6">
                                <ui:label label="Thứ tự hiển thị" htmlFor="orderIndex" />
                                <ui:input id="orderIndex" name="orderIndex" type="number"
                                    value="${not empty group.orderIndex ? group.orderIndex : 0}"
                                    placeholder="Nhập thứ tự (số)..." />
                            </div>

                            <div class="flex items-center justify-end space-x-3">
                                <ui:button variant="secondary" type="button"
                                    onclick="location.href='${pageContext.request.contextPath}/admin/lesson-groups'">
                                    Hủy
                                </ui:button>
                                <ui:button type="button" onclick="doValidation()">
                                    ${not empty group ? 'Cập nhật' : 'Tạo'}
                                </ui:button>
                            </div>
                        </form>
                    </ui:card>

                    <!-- Confirmation Dialog -->
                    <ui:alertDialog id="alert-lesson-group-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có chắc chắn muốn ${not empty group ? 'cập nhật' : 'tạo'} nhóm bài học này không?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('lesson-group-form')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>

                    <script>
                        const nameValidation = (value) => {
                            if (value.length <= 0) {
                                return "Tên nhóm là bắt buộc!";
                            } else if (value.length > 100) {
                                return "Tên nhóm không được vượt quá 100 ký tự!";
                            } else
                                return "";
                        };

                        const levelValidation = (value) => {
                            if (value === "") {
                                return "Cấp độ là bắt buộc!";
                            }
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
                            isValid &= validateInput('name', nameValidation);
                            isValid &= validateInput('level', levelValidation);
                            isValid &= validateInput('orderIndex', orderIndexValidation);

                            if (isValid) {
                                openDialog('alert-lesson-group-form');
                            }
                        };
                    </script>
                </layout:mainLayout>