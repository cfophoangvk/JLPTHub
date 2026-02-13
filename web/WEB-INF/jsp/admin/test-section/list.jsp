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
                                        <span
                                            class="ml-1 text-sm font-medium text-gray-500 md:ml-2">${test.title}</span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <div class="flex justify-between items-center mb-6">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900">Các phần thi của: ${test.title}</h1>
                                <p class="text-sm text-gray-500 mt-1">
                                    Cấp độ: <span
                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">${test.level}</span>
                                </p>
                            </div>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/test-sections/create?testId=${test.id}'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Thêm phần thi</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">
                                    <c:choose>
                                        <c:when test="${param.success == 'created'}">Tạo phần thi thành công!</c:when>
                                        <c:when test="${param.success == 'updated'}">Cập nhật phần thi thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'deleted'}">Xóa phần thi thành công!</c:when>
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
                                        <ui:th>Loại phần thi</ui:th>
                                        <ui:th>Thời gian (phút)</ui:th>
                                        <ui:th>Điểm đạt</ui:th>
                                        <ui:th>Tổng điểm</ui:th>
                                        <ui:th>Audio</ui:th>
                                        <ui:th>Số câu hỏi</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${sections}" var="section">
                                        <tr>
                                            <ui:td>
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                                    <c:choose>
                                                        <c:when test="${section.sectionType=='Moji/Goi'
                                                    }">bg-purple-100 text-purple-800</c:when>
                                                    <c:when test="${section.sectionType == 'Bunpou'}">bg-blue-100
                                                        text-blue-800</c:when>
                                                    <c:when test="${section.sectionType == 'Choukai'}">bg-green-100
                                                        text-green-800</c:when>
                                                    <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                    </c:choose>
                                                    ">${section.sectionType}
                                                </span>
                                            </ui:td>
                                            <ui:td>${section.timeLimitMinutes}</ui:td>
                                            <ui:td>${section.passScore}</ui:td>
                                            <ui:td>${section.totalScore}</ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty section.audioUrl}">
                                                        <audio controls class="h-8">
                                                            <source src="${section.audioUrl}" type="audio/mpeg">
                                                            Trình duyệt không hỗ trợ audio.
                                                        </audio>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có audio</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>${questionCounts[section.id]}</ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button className="!bg-teal-500 hover:!bg-teal-700 text-white"
                                                    onclick="goToQuestions('${section.id}')">
                                                    Câu hỏi
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEdit('${section.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button type="button" variant="secondary" size="icon"
                                                    className="space-x-2" onclick="confirmDelete('${section.id}')">
                                                    <jsp:include page="/assets/icon/trash.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty sections}">
                                        <tr>
                                            <td colspan="7"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có phần thi nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/test-sections/delete"
                            method="POST">
                            <input type="hidden" name="id" id="deleteSectionId" value="" />
                            <input type="hidden" name="testId" value="${test.id}" />
                        </form>

                        <ui:alertDialog id="alert-section">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa phần thi này?<br />
                                        <span class="text-red-600 font-semibold">(LƯU Ý: Phần thi sẽ bị ẩn khỏi danh
                                            sách.)</span>
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
                        const goToQuestions = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/questions?sectionId=' + id;
                        };

                        const goToEdit = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/test-sections/edit?id=' + id;
                        };

                        const confirmDelete = (id) => {
                            document.getElementById('deleteSectionId').value = id;
                            openDialog('alert-section');
                        };
                    </script>
                </layout:mainLayout>