<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <div class="flex justify-between items-center mb-6">
                            <h1 class="text-2xl font-bold text-gray-900">Quản lý bộ thẻ</h1>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/flashcard-groups/create'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Tạo bộ thẻ mới</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">Thành công!</span>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">Lỗi hệ thống!</span>
                            </div>
                        </c:if>

                        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                            <ui:table>
                                <thead class="bg-gray-50">
                                    <tr>
                                        <ui:th>Tên</ui:th>
                                        <ui:th>Mô tả</ui:th>
                                        <ui:th>Cấp độ</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${groups}" var="group">
                                        <tr>
                                            <ui:td>${group.name}</ui:td>
                                            <ui:td>${group.description}</ui:td>
                                            <ui:td>${group.level}</ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button className="!bg-sky-400 hover:!bg-sky-600"
                                                    onclick="goToViewFlashcards('${group.id}')">
                                                    Xem các thẻ...
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEditFlashcardGroup('${group.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <form id="deleteForm"
                                                    action="${pageContext.request.contextPath}/admin/flashcard-groups/delete"
                                                    method="POST">
                                                    <input type="hidden" name="id" value="${group.id}" />
                                                    <ui:button type="button" variant="secondary" size="icon"
                                                        className="space-x-2"
                                                        onclick="openDialog('alert-flashcard-group')">
                                                        <jsp:include page="/assets/icon/trash.jsp">
                                                            <jsp:param name="size" value="6" />
                                                        </jsp:include>
                                                    </ui:button>
                                                </form>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty groups}">
                                        <tr>
                                            <td colspan="4"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có dữ liệu.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <ui:alertDialog id="alert-flashcard-group">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa bộ thẻ này?<br />
                                        (LƯU Ý: Tất cả thẻ bên trong cũng sẽ bị xóa vĩnh viễn.)
                                    </div>
                                </ui:alertDialogDescription>
                            </ui:alertDialogHeader>

                            <ui:alertDialogFooter>
                                <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                                <ui:alertDialogAction onclick="submitForm('deleteForm')">
                                    OK
                                </ui:alertDialogAction>
                            </ui:alertDialogFooter>
                        </ui:alertDialog>
                    </div>
                    <script>
                        const goToViewFlashcards = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/flashcards?groupId=' + id;
                        };

                        const goToEditFlashcardGroup = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/flashcard-groups/edit?id=' + id;
                        };
                    </script>
                </layout:mainLayout>