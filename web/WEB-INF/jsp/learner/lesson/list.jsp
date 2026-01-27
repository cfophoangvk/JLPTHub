<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

<layout:mainLayout>
    <div class="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
        <div class="bg-white border-b border-gray-200 shadow-sm">
            <div class="max-w-7xl mx-auto px-6 py-8">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900">
                            <i class="fa-solid fa-book-open text-indigo-500 mr-3"></i>
                            Nhóm Bài Học
                        </h1>
                        <p class="text-gray-600 mt-2">
                            Học tiếng Nhật với các bài học được thiết kế cho các cấp độ
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-6 py-8">
            <c:choose>
                <c:when test="${empty groups}">
                    <div class="text-center py-16">
                        <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 flex items-center justify-center">
                            <i class="fa-solid fa-folder-open text-gray-400 text-4xl"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-2">Chưa có nhóm bài học nào</h3>
                        <p class="text-gray-500">Các nhóm bài học sẽ sớm được cập nhật.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:forEach var="group" items="${groups}">
                            <a href="${pageContext.request.contextPath}/lesson/group?id=${group.id}"
                                class="group block bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 hover:border-indigo-200 hover:-translate-y-1">

                                <div class="h-32 bg-gradient-to-br from-indigo-400 via-indigo-500 to-purple-500 relative overflow-hidden">
                                    <div class="absolute inset-0 bg-black/10"></div>
                                    <div class="absolute top-4 right-4">
                                        <span class="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-white text-sm font-medium">
                                            ${group.level}
                                        </span>
                                    </div>
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <div class="flex items-center text-white/90 text-sm">
                                            <i class="fa-solid fa-book mr-2"></i>
                                            <span>${lessonCounts[group.id]} bài học</span>
                                        </div>
                                    </div>

                                    <div class="absolute -top-10 -right-10 w-32 h-32 bg-white/10 rounded-full"></div>
                                    <div class="absolute -bottom-8 -left-8 w-24 h-24 bg-white/10 rounded-full"></div>
                                </div>

                                <div class="p-5">
                                    <h3 class="text-lg font-bold text-gray-900 group-hover:text-indigo-600 transition-colors mb-3 line-clamp-2">
                                        ${group.name}
                                    </h3>

                                    <!-- Progress bar -->
                                    <div class="mb-4">
                                        <div class="flex justify-between text-sm text-gray-600 mb-1">
                                            <span>Tiến trình</span>
                                            <span>${completedCounts[group.id]}/${lessonCounts[group.id]}</span>
                                        </div>
                                        <div class="w-full bg-gray-200 rounded-full h-2">
                                            <c:set var="progressPercent" value="${lessonCounts[group.id] > 0 ? (completedCounts[group.id] * 100 / lessonCounts[group.id]) : 0}" />
                                            <div class="bg-gradient-to-r from-indigo-500 to-purple-500 h-2 rounded-full transition-all duration-300" 
                                                style="width: ${progressPercent}%"></div>
                                        </div>
                                    </div>

                                    <div class="flex items-center text-indigo-500 font-medium text-sm group-hover:text-indigo-600 transition-colors">
                                        <span>Xem bài học</span>
                                        <i class="fa-solid fa-arrow-right ml-2 group-hover:translate-x-1 transition-transform"></i>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</layout:mainLayout>
