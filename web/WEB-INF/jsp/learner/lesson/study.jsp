<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>

            <layout:mainLayout>
                <div class="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
                    <!-- Header -->
                    <div class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-40">
                        <div class="max-w-full mx-auto px-6 py-4">
                            <nav class="flex items-center text-sm text-gray-500">
                                <a href="${pageContext.request.contextPath}/lesson"
                                    class="hover:text-indigo-600 transition-colors">
                                    <i class="fa-solid fa-book-open mr-1"></i> Nhóm Bài Học
                                </a>
                                <i class="fa-solid fa-chevron-right mx-2 text-xs"></i>
                                <a href="${pageContext.request.contextPath}/lesson/group?id=${group.id}"
                                    class="hover:text-indigo-600 transition-colors">
                                    ${group.name}
                                </a>
                                <i class="fa-solid fa-chevron-right mx-2 text-xs"></i>
                                <span class="text-gray-900 font-medium">${lesson.title}</span>
                            </nav>
                        </div>
                    </div>

                    <!-- Main Content - Split Layout -->
                    <div class="flex flex-col lg:flex-row min-h-[calc(100vh-73px)]">
                        <!-- Left Side - Lesson Content (70%) -->
                        <div class="flex-1 lg:w-[70%] overflow-y-auto">
                            <div class="max-w-4xl mx-auto px-6 py-8">
                                <!-- Lesson Title -->
                                <div class="mb-8">
                                    <div class="flex items-center gap-3 mb-3">
                                        <span
                                            class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-sm font-medium">
                                            ${group.level}
                                        </span>
                                        <c:if test="${isCurrentCompleted}">
                                            <span
                                                class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                                                <i class="fa-solid fa-check mr-1"></i> Đã hoàn thành
                                            </span>
                                        </c:if>
                                    </div>
                                    <h1 class="text-3xl font-bold text-gray-900">${lesson.title}</h1>
                                    <c:if test="${not empty lesson.description}">
                                        <p class="text-gray-600 mt-2">${lesson.description}</p>
                                    </c:if>
                                </div>

                                <!-- Audio Section -->
                                <c:if test="${not empty lesson.audioUrl}">
                                    <div class="mb-8 bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                                        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                                            <i class="fa-solid fa-headphones text-indigo-500 mr-3"></i>
                                            Nghe
                                        </h2>
                                        <audio controls class="w-full" preload="metadata">
                                            <source src="${lesson.audioUrl}" type="audio/mpeg">
                                            Trình duyệt của bạn không hỗ trợ audio.
                                        </audio>
                                    </div>
                                </c:if>

                                <!-- Reading Content Section -->
                                <c:if test="${not empty lesson.contentHtml}">
                                    <div class="mb-8 bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                                        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                                            <i class="fa-solid fa-book-open text-indigo-500 mr-3"></i>
                                            Nội dung bài học
                                        </h2>
                                        <div class="prose prose-lg max-w-none lesson-content">
                                            ${lesson.contentHtml}
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Grammar Points Section -->
                                <c:if test="${not empty grammarPoints}">
                                    <div class="mb-8 bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                                        <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                                            <i class="fa-solid fa-language text-indigo-500 mr-3"></i>
                                            Điểm ngữ pháp
                                        </h2>
                                        <div class="space-y-6">
                                            <c:forEach var="grammar" items="${grammarPoints}" varStatus="status">
                                                <div class="border-l-4 border-indigo-500 pl-4 py-2">
                                                    <h3 class="text-lg font-semibold text-gray-900 mb-2">
                                                        ${status.index + 1}. ${grammar.title}
                                                    </h3>
                                                    <c:if test="${not empty grammar.structure}">
                                                        <div class="mb-2">
                                                            <span class="text-sm font-medium text-gray-600">Cấu
                                                                trúc:</span>
                                                            <code
                                                                class="ml-2 px-2 py-1 bg-indigo-50 text-indigo-700 rounded text-sm">
                                                    ${grammar.structure}
                                                </code>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty grammar.explanation}">
                                                        <p class="text-gray-700 mb-2">${grammar.explanation}</p>
                                                    </c:if>
                                                    <c:if test="${not empty grammar.example}">
                                                        <div class="bg-gray-50 rounded-lg p-3 mt-2">
                                                            <span class="text-sm font-medium text-gray-600">Ví
                                                                dụ:</span>
                                                            <p class="text-gray-800 mt-1 italic">${grammar.example}</p>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Action Buttons -->
                                <div class="bg-white rounded-2xl shadow-lg p-6 border border-gray-100 sticky bottom-4">
                                    <div class="flex flex-col sm:flex-row gap-4 items-center justify-between">
                                        <div class="flex items-center gap-4">
                                            <c:choose>
                                                <c:when test="${isCurrentCompleted}">
                                                    <button disabled
                                                        class="px-6 py-3 bg-green-100 text-green-700 rounded-xl font-semibold cursor-not-allowed flex items-center">
                                                        <i class="fa-solid fa-check mr-2"></i>
                                                        Đã hoàn thành
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button id="markCompleteBtn"
                                                        class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all shadow-lg hover:shadow-xl flex items-center">
                                                        <i class="fa-solid fa-check mr-2"></i>
                                                        Đánh dấu hoàn thành
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:if test="${not empty nextLesson}">
                                            <a href="${pageContext.request.contextPath}/lesson/study?id=${nextLesson.id}"
                                                class="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl font-semibold hover:bg-gray-200 transition-all flex items-center">
                                                Bài tiếp theo
                                                <i class="fa-solid fa-arrow-right ml-2"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Side - Navigation Sidebar (30%) -->
                        <div
                            class="lg:w-[30%] bg-white border-l border-gray-200 lg:sticky lg:top-[73px] lg:h-[calc(100vh-73px)] overflow-y-auto">
                            <div class="p-6">
                                <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                                    <i class="fa-solid fa-list text-indigo-500 mr-2"></i>
                                    Danh sách bài học
                                </h2>

                                <div class="space-y-2">
                                    <c:forEach var="navLesson" items="${allLessons}" varStatus="status">
                                        <a href="${pageContext.request.contextPath}/lesson/study?id=${navLesson.id}"
                                            class="block p-3 rounded-xl transition-all ${navLesson.id eq lesson.id ? 'bg-indigo-100 border-2 border-indigo-300' : 'hover:bg-gray-50 border border-transparent'}">
                                            <div class="flex items-center">
                                                <div
                                                    class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center mr-3 text-sm
                                        ${completedLessonIds.contains(navLesson.id) ? 'bg-green-100 text-green-600' : 
                                          (navLesson.id eq lesson.id ? 'bg-indigo-500 text-white' : 'bg-gray-100 text-gray-600')}">
                                                    <c:choose>
                                                        <c:when test="${completedLessonIds.contains(navLesson.id)}">
                                                            <i class="fa-solid fa-check"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${status.index + 1}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="flex-grow min-w-0">
                                                    <p
                                                        class="text-sm font-medium truncate ${navLesson.id eq lesson.id ? 'text-indigo-700' : 'text-gray-700'}">
                                                        ${navLesson.title}
                                                    </p>
                                                </div>
                                                <c:if test="${navLesson.id eq lesson.id}">
                                                    <i class="fa-solid fa-play text-indigo-500 ml-2"></i>
                                                </c:if>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- JavaScript for marking complete -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const markCompleteBtn = document.getElementById('markCompleteBtn');
                        if (markCompleteBtn) {
                            markCompleteBtn.addEventListener('click', async function () {
                                const lessonId = '${lesson.id}';

                                try {
                                    markCompleteBtn.disabled = true;
                                    markCompleteBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin mr-2"></i> Đang xử lý...';

                                    const response = await fetch('${pageContext.request.contextPath}/lesson/complete', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                        },
                                        body: 'lessonId=' + encodeURIComponent(lessonId)
                                    });

                                    const data = await response.json();

                                    if (data.success) {
                                        markCompleteBtn.className = 'px-6 py-3 bg-green-100 text-green-700 rounded-xl font-semibold cursor-not-allowed flex items-center';
                                        markCompleteBtn.innerHTML = '<i class="fa-solid fa-check mr-2"></i> Đã hoàn thành';

                                        // Reload page to update sidebar
                                        window.location.reload();
                                    } else {
                                        alert('Có lỗi xảy ra. Vui lòng thử lại.');
                                        markCompleteBtn.disabled = false;
                                        markCompleteBtn.innerHTML = '<i class="fa-solid fa-check mr-2"></i> Đánh dấu hoàn thành';
                                    }
                                } catch (error) {
                                    console.error('Error:', error);
                                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                                    markCompleteBtn.disabled = false;
                                    markCompleteBtn.innerHTML = '<i class="fa-solid fa-check mr-2"></i> Đánh dấu hoàn thành';
                                }
                            });
                        }
                    });
                </script>

                <style>
                    .lesson-content {
                        line-height: 1.8;
                    }

                    .lesson-content p {
                        margin-bottom: 1rem;
                    }

                    .lesson-content h1,
                    .lesson-content h2,
                    .lesson-content h3 {
                        margin-top: 1.5rem;
                        margin-bottom: 0.75rem;
                        font-weight: 600;
                    }
                </style>
            </layout:mainLayout>