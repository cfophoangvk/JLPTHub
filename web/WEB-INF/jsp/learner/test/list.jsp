<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>

<layout:mainLayout>
    <div class="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
        <div class="bg-white border-b border-gray-200 shadow-sm">
            <div class="max-w-7xl mx-auto px-6 py-8">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900">
                            <i class="fa-solid fa-file-pen text-indigo-500 mr-3"></i>
                            Bài kiểm tra JLPT
                        </h1>
                        <p class="text-gray-600 mt-2">
                            Luyện tập với các đề thi thử cho cấp độ của bạn (N5 - ${userLevel})
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-6 py-8">
            <div class="mb-6">
                <form id="levelForm" method="GET" action="${pageContext.request.contextPath}/test" class="flex items-center space-x-4">
                    <ui:label htmlFor="level" label="Lọc theo cấp độ:" className="text-sm font-medium text-gray-700" />
                    <div class="w-50">
                        <ui:select id="level" name="level" defaultValue="${selectedLevel}" onChange="onLevelChange">
                            <ui:selectTrigger className="w-full bg-white !shadow-md" placeholder="${not empty selectedLevel ? selectedLevel : 'Tất cả'}" />
                            <ui:selectContent>
                                <ui:selectItem value="">Tất cả</ui:selectItem>
                                <c:forEach items="${levels}" var="level">
                                    <ui:selectItem value="${level}">${level}</ui:selectItem>
                                </c:forEach>
                            </ui:selectContent>
                        </ui:select>
                    </div>
                </form>
            </div>

            <c:if test="${not empty param.error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline">
                        <c:choose>
                            <c:when test="${param.error == 'level_restricted'}">Bạn chưa đạt cấp độ này.</c:when>
                            <c:when test="${param.error == 'submit_failed'}">Không thể nộp bài. Vui lòng thử lại.</c:when>
                            <c:otherwise>Đã xảy ra lỗi.</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty tests}">
                    <div class="text-center py-16">
                        <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 flex items-center justify-center">
                            <i class="fa-solid fa-file-circle-question text-gray-400 text-4xl"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-2">Chưa có bài kiểm tra nào</h3>
                        <p class="text-gray-500">Các bài kiểm tra sẽ sớm được cập nhật.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="test" items="${tests}">
                            <div class="group bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 hover:border-indigo-200 hover:-translate-y-1">
                                <div class="h-32 relative overflow-hidden
                                    <c:choose>
                                        <c:when test="${test.level == 'N5'}">bg-gradient-to-br from-green-400 via-green-500 to-emerald-500</c:when>
                                        <c:when test="${test.level == 'N4'}">bg-gradient-to-br from-blue-400 via-blue-500 to-cyan-500</c:when>
                                        <c:when test="${test.level == 'N3'}">bg-gradient-to-br from-yellow-400 via-amber-500 to-orange-500</c:when>
                                        <c:when test="${test.level == 'N2'}">bg-gradient-to-br from-orange-400 via-orange-500 to-red-500</c:when>
                                        <c:when test="${test.level == 'N1'}">bg-gradient-to-br from-red-400 via-red-500 to-rose-600</c:when>
                                        <c:otherwise>bg-gradient-to-br from-indigo-400 via-indigo-500 to-purple-500</c:otherwise>
                                    </c:choose>
                                ">
                                    <div class="absolute inset-0 bg-black/10"></div>
                                    <div class="absolute top-4 right-4">
                                        <span class="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-white text-sm font-medium">
                                            ${test.level}
                                        </span>
                                    </div>
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <div class="flex items-center text-white/90 text-sm">
                                            <i class="fa-solid fa-list-check mr-2"></i>
                                            <span>${sectionCounts[test.id]} phần thi</span>
                                        </div>
                                    </div>
                                    <div class="absolute -top-10 -right-10 w-32 h-32 bg-white/10 rounded-full"></div>
                                    <div class="absolute -bottom-8 -left-8 w-24 h-24 bg-white/10 rounded-full"></div>
                                </div>

                                <div class="p-5">
                                    <h3 class="text-lg font-bold text-gray-900 group-hover:text-indigo-600 transition-colors mb-2 line-clamp-2">
                                        ${test.title}
                                    </h3>
                                    <p class="text-gray-600 text-sm mb-4">
                                        <i class="fa-solid fa-clock mr-1"></i>
                                        Thời gian giới hạn theo từng phần
                                    </p>
                                    
                                    <a href="${pageContext.request.contextPath}/test/take?testId=${test.id}"
                                        class="w-full inline-flex items-center justify-center px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white font-medium rounded-lg transition-colors">
                                        <i class="fa-solid fa-play mr-2"></i>
                                        Bắt đầu làm bài
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function onLevelChange(value) {
            document.getElementById('levelForm').submit();
        }
    </script>
</layout:mainLayout>
