<%@page contentType="text/html" pageEncoding="UTF-8" import="model.TargetLevel" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
                <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <layout:mainLayout>
                        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                            <div class="flex justify-between items-center mb-6">
                                <div>
                                    <h1 class="text-2xl font-bold text-gray-900">Quản lý bài test JLPT</h1>
                                    <p class="text-sm text-gray-500 mt-1">Quản lý các bài test theo cấp độ</p>
                                </div>
                                <ui:button
                                    onclick="location.href='${pageContext.request.contextPath}/admin/tests/create'"
                                    className="space-x-2">
                                    <jsp:include page="/assets/icon/plus.jsp">
                                        <jsp:param name="size" value="6" />
                                    </jsp:include>
                                    <span>Tạo bài test mới</span>
                                </ui:button>
                            </div>

                            <div class="mb-4 flex items-center gap-4">
                                <div class="flex items-center gap-2">
                                    <span class="whitespace-nowrap">Tiêu đề:</span>
                                    <ui:input id="title" name="title" placeholder="Tiêu đề..." searchIcon="true" className="!w-70" value="${title}"/>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="whitespace-nowrap">Cấp độ:</span>
                                    <ui:select name="level" id="level" defaultValue="${level}">
                                        <ui:selectTrigger className="w-70" placeholder="${not empty level ? level : 'Tất cả'}" />
                                        <ui:selectContent>
                                            <ui:selectItem value="">Tất cả</ui:selectItem>
                                            <c:forEach items="${TargetLevel.values()}" var="i">
                                                <ui:selectItem value="${i}">${i}</ui:selectItem>
                                            </c:forEach>
                                        </ui:selectContent>
                                    </ui:select>
                                </div>
                                <ui:button onclick="filter()">Tìm</ui:button>
                            </div>

                            <c:if test="${not empty param.success}">
                                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                    role="alert">
                                    <span class="block sm:inline">
                                        <c:choose>
                                            <c:when test="${param.success == 'created'}">Tạo bài test thành công!
                                            </c:when>
                                            <c:when test="${param.success == 'updated'}">Cập nhật bài test thành công!
                                            </c:when>
                                            <c:when test="${param.success == 'deleted'}">Xóa bài test thành công!
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

                            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                                <ui:table>
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <ui:th>ID</ui:th>
                                            <ui:th>
                                                <span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                    onclick="sortTable('${(empty sort || sort.split('_')[0] != 'title') ? 'title_asc' : sort}')">Tiêu đề
                                                    <span class="text-gray-400 text-xs">
                                                        ${(empty sort || sort.split('_')[0] != 'title') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                    </span>
                                                </span>
                                            </ui:th>
                                            <ui:th>Cấp độ</ui:th>
                                            <ui:th>Số phần thi</ui:th>
                                            <ui:th>
                                                <span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                    onclick="sortTable('${(empty sort || sort.split('_')[0] != 'createdAt') ? 'createdAt_asc' : sort}')">Ngày tạo
                                                    <span class="text-gray-400 text-xs">
                                                        ${(empty sort || sort.split('_')[0] != 'createdAt') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                    </span>
                                                </span>
                                            </ui:th>
                                            <ui:th className="!text-center">Hành động</ui:th>
                                        </tr>
                                    </thead>
                                    <tbody id="tableBody">
                                        <c:forEach items="${tests}" var="test">
                                            <tr>
                                                <ui:td>${test.id}</ui:td>
                                                <ui:td>
                                                    <span class="font-medium text-gray-900">${test.title}</span>
                                                </ui:td>
                                                <ui:td>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                                    <c:choose>
                                                        <c:when test="${test.level == 'N5'}">bg-green-100 text-green-800</c:when>
                                                        <c:when test="${test.level == 'N4'}">bg-blue-100 text-blue-800</c:when>
                                                        <c:when test="${test.level == 'N3'}">bg-yellow-100 text-yellow-800</c:when>
                                                        <c:when test="${test.level == 'N2'}">bg-orange-100 text-orange-800</c:when>
                                                        <c:when test="${test.level == 'N1'}">bg-red-100 text-red-800</c:when>
                                                    </c:choose>
                                                    ">${test.level}
                                                    </span>
                                                </ui:td>
                                                <ui:td>${sectionCounts[test.id]}</ui:td>
                                                <ui:td>
                                                    <fmt:parseDate value="${test.createdAt}"
                                                        pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </ui:td>
                                                <ui:td
                                                    className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                    <ui:button className="!bg-teal-500 hover:!bg-teal-700 text-white"
                                                        onclick="goToSections('${test.id}')">
                                                        Phần thi
                                                    </ui:button>
                                                    <ui:separator orientation="vertical" />
                                                    <ui:button size="icon"
                                                        className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                        onclick="goToEdit('${test.id}')">
                                                        <jsp:include page="/assets/icon/pencil.jsp">
                                                            <jsp:param name="size" value="6" />
                                                        </jsp:include>
                                                    </ui:button>
                                                    <ui:separator orientation="vertical" />
                                                    <ui:button type="button" variant="secondary" size="icon"
                                                        className="space-x-2" onclick="confirmDelete('${test.id}')">
                                                        <jsp:include page="/assets/icon/trash.jsp">
                                                            <jsp:param name="size" value="6" />
                                                        </jsp:include>
                                                    </ui:button>
                                                </ui:td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty tests}">
                                            <tr class="empty-row">
                                                <td colspan="6"
                                                    class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                    Không có bài test nào.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </ui:table>
                            </div>

                            <form id="deleteForm" action="${pageContext.request.contextPath}/admin/tests/delete"
                                method="POST">
                                <input type="hidden" name="id" id="deleteTestId" value="" />
                            </form>

                            <ui:alertDialog id="alert-test">
                                <ui:alertDialogHeader>
                                    <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                    <ui:alertDialogDescription>
                                        <div class="text-center text-muted-foreground">
                                            Bạn có chắc chắn muốn xóa bài test này?<br />
                                            <span class="text-red-600 font-semibold">(LƯU Ý: Tất cả các phần thi trong
                                                bài test cũng sẽ bị ẩn.)</span>
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
                            const goToSections = (id) => {
                                location.href = '${pageContext.request.contextPath}/admin/test-sections?testId=' + id;
                            };

                            const goToEdit = (id) => {
                                location.href = '${pageContext.request.contextPath}/admin/tests/edit?id=' + id;
                            };

                            const confirmDelete = (id) => {
                                document.getElementById('deleteTestId').value = id;
                                openDialog('alert-test');
                            };

                            function onLevelChange(value) {
                                document.getElementById('levelForm').submit();
                            };

                            const sortTable = (field) => {
                                const urlString = location.href;
                                const url = new URL(urlString);
                                url.searchParams.set('sort', field.split("_")[0]);
                                url.searchParams.set('asc', field.split("_")[1] === "asc");
                                location.href = url.toString();
                            };

                            const filter = () => {
                                const title = document.getElementById("title").value;
                                const level = document.getElementById("level-input").value;
                                const urlString = location.href;
                                const url = new URL(urlString);
                                url.search = '';
                                url.searchParams.set('title', title);
                                url.searchParams.set('level', level);
                                location.href = url.toString();
                            };
                        </script>
                    </layout:mainLayout>