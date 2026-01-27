<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>

                <layout:mainLayout>
                    <div class="min-h-screen bg-gradient-to-br from-rose-50 to-orange-50">
                        <div class="bg-white border-b border-gray-200 shadow-sm">
                            <div class="max-w-7xl mx-auto px-6 py-8">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h1 class="text-3xl font-bold text-gray-900">
                                            <i class="fa-solid fa-layer-group text-rose-500 mr-3"></i>
                                            Bộ thẻ Flashcard
                                        </h1>
                                        <p class="text-gray-600 mt-2">
                                            Học từ vựng với các bộ thẻ được thiết kế cho các cấp độ
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="max-w-7xl mx-auto px-6 py-8">
                            <c:choose>
                                <c:when test="${empty groups}">
                                    <div class="text-center py-16">
                                        <div
                                            class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 flex items-center justify-center">
                                            <i class="fa-solid fa-folder-open text-gray-400 text-4xl"></i>
                                        </div>
                                        <h3 class="text-xl font-semibold text-gray-700 mb-2">Chưa có bộ thẻ nào</h3>
                                        <p class="text-gray-500">Các bộ thẻ sẽ sớm được cập nhật.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                        <c:forEach var="group" items="${groups}">
                                            <a href="${pageContext.request.contextPath}/flashcard/group?id=${group.id}"
                                                class="group block bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 hover:border-rose-200 hover:-translate-y-1">

                                                <div
                                                    class="h-32 bg-gradient-to-br from-rose-400 via-rose-500 to-orange-400 relative overflow-hidden">
                                                    <div class="absolute inset-0 bg-black/10"></div>
                                                    <div class="absolute top-4 right-4">
                                                        <span
                                                            class="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-white text-sm font-medium">
                                                            ${group.level}
                                                        </span>
                                                    </div>
                                                    <div class="absolute bottom-4 left-4 right-4">
                                                        <div class="flex items-center text-white/90 text-sm">
                                                            <i class="fa-solid fa-clone mr-2"></i>
                                                            <span>${cardCounts[group.id]} thẻ</span>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="absolute -top-10 -right-10 w-32 h-32 bg-white/10 rounded-full">
                                                    </div>
                                                    <div
                                                        class="absolute -bottom-8 -left-8 w-24 h-24 bg-white/10 rounded-full">
                                                    </div>
                                                </div>

                                                <div class="p-5">
                                                    <h3
                                                        class="text-lg font-bold text-gray-900 group-hover:text-rose-600 transition-colors mb-2 line-clamp-2">
                                                        ${group.name}
                                                    </h3>
                                                    <c:if test="${not empty group.description}">
                                                        <p class="text-gray-600 text-sm line-clamp-2 mb-3">
                                                            ${group.description}
                                                        </p>
                                                    </c:if>

                                                    <div
                                                        class="flex items-center text-rose-500 font-medium text-sm group-hover:text-rose-600 transition-colors">
                                                        <span>Bắt đầu học</span>
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