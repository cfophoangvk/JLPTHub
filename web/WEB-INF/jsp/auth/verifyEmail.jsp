<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <layout:mainLayout>
                    <div class="bg-gray-100 h-screen flex flex-col justify-center items-center space-y-3">
                        <jsp:include page="/assets/icon/logo.jsp" />

                        <div class="bg-white rounded-lg shadow-lg w-[500px] p-8 text-center">
                            <c:choose>
                                <c:when test="${not empty success}">
                                    <div class="text-green-500 text-6xl mb-4">
                                        <i class="fa-solid fa-circle-check"></i>
                                    </div>
                                    <h2 class="text-2xl font-bold mb-4 text-gray-800">Xác thực thành công!</h2>
                                    <p class="text-gray-600 mb-6">
                                        <c:out value="${success}" />
                                    </p>
                                    <a href="${pageContext.request.contextPath}/auth/login">
                                        <ui:button className="w-full">Đăng nhập ngay</ui:button>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-red-500 text-6xl mb-4">
                                        <i class="fa-solid fa-circle-xmark"></i>
                                    </div>
                                    <h2 class="text-2xl font-bold mb-4 text-gray-800">Xác thực thất bại</h2>
                                    <p class="text-gray-600 mb-6">
                                        <c:out value="${error}" />
                                    </p>
                                    <a href="${pageContext.request.contextPath}/auth/login">
                                        <ui:button variant="outline" className="w-full">Quay lại trang đăng nhập
                                        </ui:button>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </layout:mainLayout>