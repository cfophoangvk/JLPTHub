<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <div class="mb-4">
                            <a href="${pageContext.request.contextPath}/admin/flashcard-groups"
                                class="text-indigo-600 hover:text-indigo-900 flex items-center space-x-2">
                                <jsp:include page="/assets/icon/arrowLeft.jsp">
                                    <jsp:param name="size" value="5" />
                                </jsp:include>
                                <span>Quay lại danh sách bộ thẻ</span>
                            </a>
                        </div>
                        <div class="flex justify-between items-center mb-6">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900">Quản lý thẻ trong bộ thẻ: ${group.name}</h1>
                                <div class="text-gray-600 flex space-x-2">
                                    <span>Cấp độ:</span>
                                    <ui:badge variant="secondary">${group.level}</ui:badge>
                                </div>
                            </div>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/flashcards/create?groupId=${group.id}'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Thêm thẻ mới</span>
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

                        <!-- Search -->
                        <div class="mb-4 flex items-center gap-4">
                            <div class="flex items-center gap-2">
                                <span class="whitespace-nowrap">Thuật ngữ: </span>
                                <ui:input id="term" name="term" placeholder="Nhập thuật ngữ..." searchIcon="true" className="!w-70" value="${term}"/>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="whitespace-nowrap">Định nghĩa: </span>
                                <ui:input id="definition" name="definition" placeholder="Nhập định nghĩa..." searchIcon="true" className="!w-70" value="${definition}"/>
                            </div>
                            <ui:button onclick="filter()">Tìm</ui:button>
                        </div>

                        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                            <ui:table>
                                <thead class="bg-gray-50">
                                    <tr>
                                        <ui:th>
                                            <span class="cursor-pointer select-none inline-flex items-center gap-1" onClick="sortTable('${(empty sort || sort.split('_')[0] != 'term') ? 'term_asc' : sort}')">Thuật ngữ
                                                <span class="text-gray-400 text-xs">
                                                    ${(empty sort || sort.split('_')[0] != 'term') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                </span>
                                            </span>
                                        </ui:th>
                                        <ui:th>
                                            <span class="cursor-pointer select-none inline-flex items-center gap-1" onClick="sortTable('${(empty sort || sort.split('_')[0] != 'definition') ? 'definition_asc' : sort}')">Định nghĩa
                                                <span class="text-gray-400 text-xs">
                                                    ${(empty sort || sort.split('_')[0] != 'definition') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                </span>
                                            </span>
                                        </ui:th>
                                        <ui:th>Ảnh thuật ngữ</ui:th>
                                        <ui:th>Thứ tự</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody id="tableBody">
                                    <c:forEach items="${flashcards}" var="card">
                                        <tr>
                                            <ui:td>${card.term}</ui:td>
                                            <ui:td>${card.definition}</ui:td>
                                            <ui:td>
                                                <c:if test="${not empty card.termImageUrl}">
                                                    <img src="${card.termImageUrl}" alt="Term Image"
                                                        class="h-10 w-10 object-cover rounded">
                                                </c:if>
                                                <c:if test="${empty card.termImageUrl }">
                                                    <span class="text-gray-400 text-xs">Không có hình ảnh</span>
                                                </c:if>
                                            </ui:td>
                                            <ui:td>${card.orderIndex}</ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEditFlashcard('${card.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <form id="deleteForm"
                                                    action="${pageContext.request.contextPath}/admin/flashcards/delete"
                                                    method="POST">
                                                    <input type="hidden" name="id" value="${card.id}" />
                                                    <input type="hidden" name="groupId" value="${group.id}" />
                                                    <ui:button type="button" variant="secondary" size="icon"
                                                        className="space-x-2" onclick="openDialog('alert-flashcard')">
                                                        <jsp:include page="/assets/icon/trash.jsp">
                                                            <jsp:param name="size" value="6" />
                                                        </jsp:include>
                                                    </ui:button>
                                                </form>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty flashcards}">
                                        <tr class="empty-row">
                                            <td colspan="5"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Chưa có thẻ nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <ui:alertDialog id="alert-flashcard">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa thẻ này?
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
                        const goToEditFlashcard = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/flashcards/edit?id=' + id;
                        };

                        const sortTable = (field) => {
                            const urlString = location.href;
                            const url = new URL(urlString);
                            url.searchParams.set('sort', field.split("_")[0]);
                            url.searchParams.set('asc', field.split("_")[1] === "asc");
                            location.href = url.toString();
                        };

                        const filter = () => {
                            const term = document.getElementById("term").value;
                            const definition = document.getElementById("definition").value;
                            const urlString = location.href;
                            const url = new URL(urlString);
                            url.search = '';
                            url.searchParams.set('groupId', '${group.id}');
                            url.searchParams.set('term', term);
                            url.searchParams.set('definition', definition);
                            location.href = url.toString();
                        };
                    </script>
                </layout:mainLayout>