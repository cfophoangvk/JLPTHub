<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <div class="flex justify-between items-center mb-6">
                            <h1 class="text-2xl font-bold text-gray-900">Quản lý nhóm bài học</h1>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/lesson-groups/create'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Tạo nhóm mới</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">
                                    <c:choose>
                                        <c:when test="${param.success == 'created'}">Tạo nhóm bài học thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'updated'}">Cập nhật nhóm bài học thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'deleted'}">Xóa nhóm bài học thành công!
                                        </c:when>
                                        <c:otherwise>Thành công!</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">Đã xảy ra lỗi. Vui lòng thử lại.</span>
                            </div>
                        </c:if>

                        <!-- Search -->
                        <div class="mb-4">
                            <ui:input id="searchInput" name="searchInput" placeholder="Tìm kiếm theo tên nhóm..." searchIcon="true" onInput="filterTable()" />
                        </div>

                        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                            <ui:table>
                                <thead class="bg-gray-50">
                                    <tr>
                                        <ui:th><span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                onclick="sortTable(0, 'text')">Tên nhóm <span id="sort-arrow-0"
                                                    class="text-gray-400 text-xs">▲▼</span></span></ui:th>
                                        <ui:th><span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                onclick="sortTable(1, 'text')">Cấp độ <span id="sort-arrow-1"
                                                    class="text-gray-400 text-xs">▲▼</span></span></ui:th>
                                        <ui:th>Số bài học</ui:th>
                                        <ui:th><span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                onclick="sortTable(3, 'number')">Thứ tự <span id="sort-arrow-3"
                                                    class="text-gray-400 text-xs">▲▼</span></span></ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody id="tableBody">
                                    <c:forEach items="${groups}" var="group">
                                        <tr>
                                            <ui:td>${group.name}</ui:td>
                                            <ui:td>
                                                <span
                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">
                                                    ${group.level}
                                                </span>
                                            </ui:td>
                                            <ui:td>
                                                <span
                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                    ${lessonCounts[group.id]} bài
                                                </span>
                                            </ui:td>
                                            <ui:td>${group.orderIndex}</ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button className="!bg-sky-400 hover:!bg-sky-600"
                                                    onclick="goToViewLessons('${group.id}')">
                                                    Xem bài học...
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEditGroup('${group.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button type="button" variant="secondary" size="icon"
                                                    className="space-x-2" onclick="confirmDelete('${group.id}')">
                                                    <jsp:include page="/assets/icon/trash.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty groups}">
                                        <tr class="empty-row">
                                            <td colspan="5"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có dữ liệu.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <!-- Delete Form -->
                        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/lesson-groups/delete"
                            method="POST">
                            <input type="hidden" name="id" id="deleteGroupId" value="" />
                        </form>

                        <!-- Delete Confirmation Dialog -->
                        <ui:alertDialog id="alert-lesson-group">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa nhóm bài học này?<br />
                                        <span class="text-red-600 font-semibold">(LƯU Ý: Tất cả bài học và điểm ngữ pháp
                                            bên trong cũng sẽ bị xóa.)</span>
                                    </div>
                                </ui:alertDialogDescription>
                            </ui:alertDialogHeader>

                            <ui:alertDialogFooter>
                                <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                                <ui:alertDialogAction onclick="submitForm('deleteForm')">
                                    Xóa
                                </ui:alertDialogAction>
                            </ui:alertDialogFooter>
                        </ui:alertDialog>
                    </div>

                    <script>
                        const goToViewLessons = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/lessons?groupId=' + id;
                        };

                        const goToEditGroup = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/lesson-groups/edit?id=' + id;
                        };

                        const confirmDelete = (id) => {
                            document.getElementById('deleteGroupId').value = id;
                            openDialog('alert-lesson-group');
                        };

                        // Search
                        const searchCols = [0]; // Tên nhóm
                        function filterTable() {
                            const query = document.getElementById('searchInput').value.toLowerCase();
                            const rows = document.querySelectorAll('#tableBody tr:not(.empty-row)');
                            rows.forEach(row => {
                                const cells = row.querySelectorAll('td');
                                const match = searchCols.some(i => cells[i] && cells[i].textContent.toLowerCase().includes(query));
                                row.style.display = match ? '' : 'none';
                            });
                        }

                        // Sort
                        let sortDir = {};
                        function sortTable(colIdx, type) {
                            const tbody = document.getElementById('tableBody');
                            const rows = Array.from(tbody.querySelectorAll('tr:not(.empty-row)'));
                            const dir = sortDir[colIdx] === 'asc' ? 'desc' : 'asc';
                            sortDir[colIdx] = dir;

                            rows.sort((a, b) => {
                                const aText = a.querySelectorAll('td')[colIdx]?.textContent.trim() || '';
                                const bText = b.querySelectorAll('td')[colIdx]?.textContent.trim() || '';
                                if (type === 'number') {
                                    return dir === 'asc' ? parseFloat(aText) - parseFloat(bText) : parseFloat(bText) - parseFloat(aText);
                                }
                                return dir === 'asc' ? aText.localeCompare(bText, 'vi') : bText.localeCompare(aText, 'vi');
                            });

                            rows.forEach(row => tbody.appendChild(row));

                            document.querySelectorAll('[id^="sort-arrow-"]').forEach(el => el.textContent = '▲▼');
                            const arrow = document.getElementById('sort-arrow-' + colIdx);
                            if (arrow) arrow.textContent = dir === 'asc' ? '▲' : '▼';
                        }
                    </script>
                </layout:mainLayout>