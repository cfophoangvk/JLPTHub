<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <layout:mainLayout>
                        <div class="min-h-screen bg-gradient-to-br from-slate-50 to-purple-50 py-8">
                            <div class="max-w-3xl mx-auto px-6">
                                <!-- Result Card -->
                                <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                                    <!-- Header -->
                                    <div
                                        class="${result.passed ? 'bg-gradient-to-r from-green-400 to-emerald-500' : 'bg-gradient-to-r from-red-400 to-rose-500'} p-8 text-white text-center">
                                        <div
                                            class="w-24 h-24 mx-auto mb-4 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center">
                                            <c:choose>
                                                <c:when test="${result.passed}">
                                                    <i class="fa-solid fa-trophy text-5xl text-yellow-300"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-rotate-right text-5xl text-white"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <h1 class="text-3xl font-bold mb-2">
                                            <c:choose>
                                                <c:when test="${result.passed}">Chúc mừng! Bạn đã đạt!</c:when>
                                                <c:otherwise>Chưa đạt - Hãy thử lại!</c:otherwise>
                                            </c:choose>
                                        </h1>
                                        <p class="text-white/80">${test.title} - ${test.level}</p>
                                    </div>

                                    <!-- Score Summary -->
                                    <div class="p-8">
                                        <div class="text-center mb-8">
                                            <div
                                                class="text-6xl font-bold ${result.passed ? 'text-green-500' : 'text-red-500'} mb-2">
                                                ${result.scoreObtained}
                                            </div>
                                            <div class="text-gray-500 text-lg">
                                                / ${totalMaxScore} điểm
                                            </div>
                                            <c:if test="${result.durationSeconds != null}">
                                                <p class="text-gray-400 mt-2">
                                                    <i class="fa-solid fa-clock mr-1"></i>
                                                    Thời gian:
                                                    <c:set var="minutes" value="${result.durationSeconds / 60}" />
                                                    <c:set var="seconds" value="${result.durationSeconds % 60}" />
                                                    <fmt:formatNumber value="${minutes}" maxFractionDigits="0" />:
                                                    <fmt:formatNumber value="${seconds}" pattern="00" />
                                                </p>
                                            </c:if>
                                        </div>

                                        <!-- Section Scores -->
                                        <h3 class="text-lg font-bold text-gray-900 mb-4">
                                            <i class="fa-solid fa-chart-bar text-indigo-500 mr-2"></i>
                                            Điểm theo từng phần
                                        </h3>

                                        <div class="space-y-4">
                                            <c:forEach var="sectionResult" items="${sectionResults}" varStatus="status">
                                                <c:set var="section" value="${sections[status.index]}" />
                                                <div class="bg-gray-50 rounded-xl p-5">
                                                    <div class="flex items-center justify-between mb-3">
                                                        <div class="flex items-center">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${sectionResult.sectionType == 'Moji/Goi'}">
                                                                    <span
                                                                        class="w-10 h-10 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center mr-3">
                                                                        <i class="fa-solid fa-language"></i>
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${sectionResult.sectionType == 'Bunpou'}">
                                                                    <span
                                                                        class="w-10 h-10 bg-purple-100 text-purple-600 rounded-lg flex items-center justify-center mr-3">
                                                                        <i class="fa-solid fa-spell-check"></i>
                                                                    </span>
                                                                </c:when>
                                                                <c:when
                                                                    test="${sectionResult.sectionType == 'Choukai'}">
                                                                    <span
                                                                        class="w-10 h-10 bg-orange-100 text-orange-600 rounded-lg flex items-center justify-center mr-3">
                                                                        <i class="fa-solid fa-headphones"></i>
                                                                    </span>
                                                                </c:when>
                                                            </c:choose>
                                                            <div>
                                                                <h4 class="font-semibold text-gray-900">
                                                                    ${sectionResult.sectionType}</h4>
                                                                <p class="text-sm text-gray-500">
                                                                    ${sectionResult.correctAnswers}/${sectionResult.totalQuestions}
                                                                    câu đúng
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <div class="text-right">
                                                            <div
                                                                class="text-xl font-bold ${sectionResult.passed ? 'text-green-600' : 'text-red-600'}">
                                                                ${sectionResult.scoreObtained}/${section.totalScore}
                                                            </div>
                                                            <span
                                                                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${sectionResult.passed ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                                                <c:choose>
                                                                    <c:when test="${sectionResult.passed}">Đạt</c:when>
                                                                    <c:otherwise>Chưa đạt</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <!-- Progress Bar -->
                                                    <div class="w-full bg-gray-200 rounded-full h-2">
                                                        <c:set var="percentage"
                                                            value="${sectionResult.scoreObtained * 100 / section.totalScore}" />
                                                        <div class="h-2 rounded-full ${sectionResult.passed ? 'bg-green-500' : 'bg-red-500'}"
                                                            style="width: ${percentage}%"></div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Actions -->
                                        <div class="flex justify-center space-x-4 mt-8">
                                            <a href="${pageContext.request.contextPath}/test/take?testId=${test.id}"
                                                class="px-6 py-3 bg-indigo-500 hover:bg-indigo-600 text-white font-medium rounded-lg transition-colors">
                                                <i class="fa-solid fa-rotate-right mr-2"></i>
                                                Làm lại
                                            </a>
                                            <a href="${pageContext.request.contextPath}/test"
                                                class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium rounded-lg transition-colors">
                                                <i class="fa-solid fa-list mr-2"></i>
                                                Danh sách bài kiểm tra
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </layout:mainLayout>