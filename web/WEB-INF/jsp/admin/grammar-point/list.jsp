<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

                <layout:mainLayout>
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <!-- Breadcrumb -->
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
                                        <span
                                            class="ml-1 text-sm font-medium text-gray-500 md:ml-2">${lesson.title}</span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <div class="flex justify-between items-center mb-6">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900">Điểm ngữ pháp: ${lesson.title}</h1>
                            </div>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/grammar-points/create?lessonId=${lesson.id}'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Thêm ngữ pháp</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">
                                    <c:choose>
                                        <c:when test="${param.success == 'created'}">Thêm điểm ngữ pháp thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'updated'}">Cập nhật điểm ngữ pháp thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'deleted'}">Xóa điểm ngữ pháp thành công!
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
                                        <ui:th>Tiêu đề</ui:th>
                                        <ui:th>Cấu trúc</ui:th>
                                        <ui:th>Giải thích</ui:th>
                                        <ui:th>Ví dụ</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${grammarPoints}" var="gp">
                                        <tr>
                                            <ui:td>${gp.title}</ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty gp.structure}">
                                                        <code
                                                            class="bg-gray-100 px-2 py-1 rounded text-sm">${gp.structure}</code>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty gp.explanation}">
                                                        <span class="truncate max-w-xs block" title="${gp.explanation}">
                                                            ${gp.explanation.length() > 50 ? gp.explanation.substring(0,
                                                            50).concat('...') : gp.explanation}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty gp.example}">
                                                        <span class="truncate max-w-xs block" title="${gp.example}">
                                                            ${gp.example.length() > 50 ? gp.example.substring(0,
                                                            50).concat('...') : gp.example}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEditGrammarPoint('${gp.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button type="button" variant="secondary" size="icon"
                                                    className="space-x-2" onclick="confirmDelete('${gp.id}')">
                                                    <jsp:include page="/assets/icon/trash.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty grammarPoints}">
                                        <tr>
                                            <td colspan="5"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có điểm ngữ pháp nào trong bài học này.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <!-- Delete Form -->
                        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/grammar-points/delete"
                            method="POST">
                            <input type="hidden" name="id" id="deleteGrammarPointId" value="" />
                            <input type="hidden" name="lessonId" value="${lesson.id}" />
                        </form>

                        <!-- Delete Confirmation Dialog -->
                        <ui:alertDialog id="alert-grammar-point">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    Bạn có chắc chắn muốn xóa điểm ngữ pháp này không?
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
                        const goToEditGrammarPoint = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/grammar-points/edit?id=' + id;
                        };

                        const confirmDelete = (id) => {
                            document.getElementById('deleteGrammarPointId').value = id;
                            openDialog('alert-grammar-point');
                        };
                    </script>
                </layout:mainLayout>