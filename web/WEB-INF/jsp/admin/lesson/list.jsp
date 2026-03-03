<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <nav class="flex mb-4" aria-label="Breadcrumb">
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
                                        <span
                                            class="ml-1 text-sm font-medium text-gray-500 md:ml-2">${group.name}</span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <div class="flex justify-between items-center mb-6">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900">Bài học trong nhóm: ${group.name}</h1>
                                <p class="text-sm text-gray-500 mt-1">
                                    Cấp độ: <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">${group.level}</span>
                                </p>
                            </div>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/lessons/create?groupId=${group.id}'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Tạo bài học mới</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">
                                    <c:choose>
                                        <c:when test="${param.success == 'created'}">Tạo bài học thành công!</c:when>
                                        <c:when test="${param.success == 'updated'}">Cập nhật bài học thành công!</c:when>
                                        <c:when test="${param.success == 'deleted'}">Xóa bài học thành công!</c:when>
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

                        <div class="mb-4 flex items-center gap-4">
                            <div class="flex items-center gap-2">
                                <span class="whitespace-nowrap">Tiêu đề:</span>
                                <ui:input id="title" name="title" placeholder="Tiêu đề..." searchIcon="true" className="!w-70" value="${title}"/>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="whitespace-nowrap">Mô tả:</span>
                                <ui:input id="description" name="description" placeholder="Mô tả..." searchIcon="true" className="!w-70" value="${description}"/>
                            </div>
                            <ui:button onclick="filter()">Tìm</ui:button>
                        </div>

                        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                            <ui:table>
                                <thead class="bg-gray-50">
                                    <tr>
                                        <ui:th>
                                            <span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                onclick="sortTable('${(empty sort || sort.split('_')[0] != 'title') ? 'title_asc' : sort}')">Tiêu đề
                                                <span class="text-gray-400 text-xs">
                                                    ${(empty sort || sort.split('_')[0] != 'title') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                </span>
                                            </span>
                                        </ui:th>
                                        <ui:th>
                                            <span class="cursor-pointer select-none inline-flex items-center gap-1"
                                                onclick="sortTable('${(empty sort || sort.split('_')[0] != 'description') ? 'description_asc' : sort}')">Mô tả
                                                <span class="text-gray-400 text-xs">
                                                    ${(empty sort || sort.split('_')[0] != 'description') ? '▲▼' : sort.split('_')[1] == 'asc' ? '▲' : '▼'}
                                                </span>
                                            </span>
                                        </ui:th>
                                        <ui:th>Audio</ui:th>
                                        <ui:th>Thứ tự</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody id="tableBody">
                                    <c:forEach items="${lessons}" var="lesson">
                                        <tr>
                                            <ui:td>${lesson.title}</ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty lesson.description}">
                                                        <span class="truncate max-w-xs block"
                                                            title="${lesson.description}">
                                                            ${lesson.description.length() > 50 ?
                                                            lesson.description.substring(0, 50).concat('...') :
                                                            lesson.description}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty lesson.audioUrl}">
                                                        <audio controls class="h-8">
                                                            <source src="${lesson.audioUrl}" type="audio/mpeg">
                                                            Trình duyệt không hỗ trợ audio.
                                                        </audio>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có audio</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>${lesson.orderIndex}</ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button className="!bg-teal-500 hover:!bg-teal-700 text-white"
                                                    onclick="goToGrammarPoints('${lesson.id}')">
                                                    Ngữ pháp
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEditLesson('${lesson.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button type="button" variant="secondary" size="icon"
                                                    className="space-x-2" onclick="confirmDelete('${lesson.id}')">
                                                    <jsp:include page="/assets/icon/trash.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty lessons}">
                                        <tr class="empty-row">
                                            <td colspan="5"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có bài học nào trong nhóm này.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/lessons/delete"
                            method="POST">
                            <input type="hidden" name="id" id="deleteLessonId" value="" />
                            <input type="hidden" name="groupId" value="${group.id}" />
                        </form>

                        <ui:alertDialog id="alert-lesson">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa bài học này?<br />
                                        <span class="text-red-600 font-semibold">(LƯU Ý: Tất cả điểm ngữ pháp trong bài
                                            học cũng sẽ bị xóa.)</span>
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
                        const goToGrammarPoints = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/grammar-points?lessonId=' + id;
                        };

                        const goToEditLesson = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/lessons/edit?id=' + id;
                        };

                        const confirmDelete = (id) => {
                            document.getElementById('deleteLessonId').value = id;
                            openDialog('alert-lesson');
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
                            const description = document.getElementById("description").value;
                            const urlString = location.href;
                            const url = new URL(urlString);
                            url.search = '';
                            url.searchParams.set('groupId', '${group.id}');
                            url.searchParams.set('title', title);
                            url.searchParams.set('description', description);
                            location.href = url.toString();
                        };
                    </script>
                </layout:mainLayout>