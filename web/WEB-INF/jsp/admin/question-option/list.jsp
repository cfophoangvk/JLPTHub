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
                                        Bài test
                                    </a>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <svg class="w-3 h-3 text-gray-400 mx-1" aria-hidden="true"
                                            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                stroke-width="2" d="m1 9 4-4-4-4" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/test-sections?testId=${test.id}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${test.title}
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
                                        <a href="${pageContext.request.contextPath}/admin/questions?sectionId=${section.id}"
                                            class="ml-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ml-2">
                                            ${section.sectionType}
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
                                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Câu
                                            ${question.id}</span>
                                    </div>
                                </li>
                            </ol>
                        </nav>

                        <div class="flex justify-between items-center mb-6">
                            <div>
                                <h1 class="text-2xl font-bold text-gray-900">Lựa chọn cho câu hỏi #${question.id}</h1>
                                <p class="text-sm text-gray-500 mt-1">
                                    <c:if test="${not empty question.content}">
                                        ${question.content.length() > 80 ? question.content.substring(0,
                                        80).concat('...') : question.content}
                                    </c:if>
                                </p>
                            </div>
                            <ui:button
                                onclick="location.href='${pageContext.request.contextPath}/admin/question-options/create?questionId=${question.id}'"
                                className="space-x-2">
                                <jsp:include page="/assets/icon/plus.jsp">
                                    <jsp:param name="size" value="6" />
                                </jsp:include>
                                <span>Thêm lựa chọn</span>
                            </ui:button>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4"
                                role="alert">
                                <span class="block sm:inline">
                                    <c:choose>
                                        <c:when test="${param.success == 'created'}">Tạo lựa chọn thành công!</c:when>
                                        <c:when test="${param.success == 'updated'}">Cập nhật lựa chọn thành công!
                                        </c:when>
                                        <c:when test="${param.success == 'deleted'}">Xóa lựa chọn thành công!</c:when>
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

                        <!-- Question Preview -->
                        <c:if test="${not empty question.imageUrl}">
                            <div class="bg-gray-50 rounded-lg p-4 mb-6">
                                <p class="text-sm font-medium text-gray-700 mb-2">Hình ảnh câu hỏi:</p>
                                <img src="${question.imageUrl}" alt="Question image"
                                    class="max-h-48 object-contain rounded" />
                            </div>
                        </c:if>

                        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                            <ui:table>
                                <thead class="bg-gray-50">
                                    <tr>
                                        <ui:th>ID</ui:th>
                                        <ui:th>Nội dung</ui:th>
                                        <ui:th>Hình ảnh</ui:th>
                                        <ui:th>Đáp án đúng</ui:th>
                                        <ui:th className="!text-center">Hành động</ui:th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${options}" var="option">
                                        <tr>
                                            <ui:td>${option.id}</ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty option.content}">
                                                        <span class="truncate max-w-xs block" title="${option.content}">
                                                            ${option.content.length() > 80 ?
                                                            option.content.substring(0, 80).concat('...') :
                                                            option.content}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có nội dung</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${not empty option.imageUrl}">
                                                        <img src="${option.imageUrl}" alt="Option image"
                                                            class="h-12 w-12 object-cover rounded cursor-pointer"
                                                            onclick="showImage('${option.imageUrl}')" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td>
                                                <c:choose>
                                                    <c:when test="${option.correct}">
                                                        <span
                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                            ✓ Đúng
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                            Sai
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </ui:td>
                                            <ui:td
                                                className="text-center flex justify-center items-center space-x-2 mx-auto">
                                                <ui:button size="icon"
                                                    className="space-x-2 !bg-yellow-400 hover:!bg-yellow-600"
                                                    onclick="goToEdit('${option.id}')">
                                                    <jsp:include page="/assets/icon/pencil.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                                <ui:separator orientation="vertical" />
                                                <ui:button type="button" variant="secondary" size="icon"
                                                    className="space-x-2" onclick="confirmDelete('${option.id}')">
                                                    <jsp:include page="/assets/icon/trash.jsp">
                                                        <jsp:param name="size" value="6" />
                                                    </jsp:include>
                                                </ui:button>
                                            </ui:td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty options}">
                                        <tr>
                                            <td colspan="5"
                                                class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                Không có lựa chọn nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </ui:table>
                        </div>

                        <!-- Delete Form -->
                        <form id="deleteForm" action="${pageContext.request.contextPath}/admin/question-options/delete"
                            method="POST">
                            <input type="hidden" name="id" id="deleteOptionId" value="" />
                            <input type="hidden" name="questionId" value="${question.id}" />
                        </form>

                        <!-- Delete Confirmation Dialog -->
                        <ui:alertDialog id="alert-option">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận xóa</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn xóa lựa chọn này?<br />
                                        <span class="text-red-600 font-semibold">(Lựa chọn sẽ bị xóa vĩnh viễn!)</span>
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

                        <!-- Image Preview Modal -->
                        <div id="imageModal"
                            class="fixed inset-0 bg-black bg-opacity-50 hidden z-50 flex items-center justify-center"
                            onclick="hideImage()">
                            <img id="previewImage" src="" alt="Preview" class="max-w-4xl max-h-screen object-contain" />
                        </div>
                    </div>

                    <script>
                        const goToEdit = (id) => {
                            location.href = '${pageContext.request.contextPath}/admin/question-options/edit?id=' + id;
                        };

                        const confirmDelete = (id) => {
                            document.getElementById('deleteOptionId').value = id;
                            openDialog('alert-option');
                        };

                        const showImage = (url) => {
                            document.getElementById('previewImage').src = url;
                            document.getElementById('imageModal').classList.remove('hidden');
                        };

                        const hideImage = () => {
                            document.getElementById('imageModal').classList.add('hidden');
                        };
                    </script>
                </layout:mainLayout>