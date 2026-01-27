<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

            <layout:mainLayout>
                <div class="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
                    <!-- Header -->
                    <div class="bg-white border-b border-gray-200 shadow-sm">
                        <div class="max-w-7xl mx-auto px-6 py-8">
                            <nav class="flex items-center text-sm text-gray-500 mb-4">
                                <a href="${pageContext.request.contextPath}/lesson"
                                    class="hover:text-indigo-600 transition-colors">
                                    <i class="fa-solid fa-book-open mr-1"></i> Nhóm Bài Học
                                </a>
                                <i class="fa-solid fa-chevron-right mx-2 text-xs"></i>
                                <span class="text-gray-900 font-medium">${group.name}</span>
                            </nav>

                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="flex items-center gap-3 mb-2">
                                        <span
                                            class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-sm font-medium">
                                            ${group.level}
                                        </span>
                                    </div>
                                    <h1 class="text-3xl font-bold text-gray-900">
                                        ${group.name}
                                    </h1>
                                    <p class="text-gray-600 mt-2">
                                        <i class="fa-solid fa-book mr-2"></i>
                                        ${lessons.size()} bài học
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Lesson List -->
                    <div class="max-w-7xl mx-auto px-6 py-8">
                        <c:choose>
                            <c:when test="${empty lessons}">
                                <div class="text-center py-16 bg-white rounded-2xl shadow-lg">
                                    <div
                                        class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 flex items-center justify-center">
                                        <i class="fa-solid fa-file-circle-xmark text-gray-400 text-4xl"></i>
                                    </div>
                                    <h3 class="text-xl font-semibold text-gray-700 mb-2">Chưa có bài học nào</h3>
                                    <p class="text-gray-500">Các bài học sẽ sớm được cập nhật.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-4">
                                    <c:forEach var="lesson" items="${lessons}" varStatus="status">
                                        <a href="${pageContext.request.contextPath}/lesson/study?id=${lesson.id}"
                                            class="group block bg-white rounded-xl shadow-md hover:shadow-lg transition-all duration-300 overflow-hidden border border-gray-100 hover:border-indigo-200">

                                            <div class="flex items-center p-5">
                                                <!-- Order Number -->
                                                <div
                                                    class="flex-shrink-0 w-12 h-12 rounded-full flex items-center justify-center mr-4
                                        ${completedLessonIds.contains(lesson.id) ? 'bg-green-100 text-green-600' : 'bg-indigo-100 text-indigo-600'}">
                                                    <c:choose>
                                                        <c:when test="${completedLessonIds.contains(lesson.id)}">
                                                            <i class="fa-solid fa-check text-xl"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="font-bold text-lg">${status.index + 1}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Content -->
                                                <div class="flex-grow min-w-0">
                                                    <h3
                                                        class="text-lg font-semibold text-gray-900 group-hover:text-indigo-600 transition-colors truncate">
                                                        ${lesson.title}
                                                    </h3>
                                                    <c:if test="${not empty lesson.description}">
                                                        <p class="text-gray-600 text-sm mt-1 line-clamp-2">
                                                            ${lesson.description}
                                                        </p>
                                                    </c:if>
                                                    <div class="flex items-center gap-4 mt-2 text-sm text-gray-500">
                                                        <c:if test="${not empty lesson.audioUrl}">
                                                            <span><i class="fa-solid fa-headphones mr-1"></i>
                                                                Nghe</span>
                                                        </c:if>
                                                        <c:if test="${not empty lesson.contentHtml}">
                                                            <span><i class="fa-solid fa-book-open mr-1"></i> Đọc</span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Arrow -->
                                                <div class="flex-shrink-0 ml-4">
                                                    <i
                                                        class="fa-solid fa-arrow-right text-gray-400 group-hover:text-indigo-500 group-hover:translate-x-1 transition-all"></i>
                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Back Button -->
                        <div class="mt-8">
                            <a href="${pageContext.request.contextPath}/lesson"
                                class="inline-flex items-center text-indigo-600 hover:text-indigo-800 font-medium transition-colors">
                                <i class="fa-solid fa-arrow-left mr-2"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </layout:mainLayout>