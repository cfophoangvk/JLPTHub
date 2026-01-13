<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <layout:mainLayout>
                    <div class="bg-gray-100 h-screen flex flex-col justify-center items-center space-y-3">
                        <jsp:include page="/assets/icon/logo.jsp" />

                        <div class="bg-white rounded-lg shadow-lg w-[400px] p-8">
                            <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Quên mật khẩu</h2>

                            <c:if test="${not empty error}">
                                <div class="bg-red-100 text-red-700 p-2 mb-4 rounded text-sm text-center">
                                    <c:out value="${error}" />
                                </div>
                            </c:if>
                            <c:if test="${not empty success}">
                                <div class="bg-green-100 text-green-700 p-2 mb-4 rounded text-sm text-center">
                                    <c:out value="${success}" />
                                </div>
                            </c:if>

                            <p class="text-sm text-gray-600 mb-6 text-center">
                                Nhập email của bạn để nhận liên kết đặt lại mật khẩu.
                            </p>

                            <form id="forgotPasswordForm"
                                action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                                <div class="mb-6">
                                    <ui:label htmlFor="email" label="Email" />
                                    <ui:input id="email" name="email" placeholder="example@gmail.com" />
                                </div>

                                <ui:button className="w-full !font-bold mb-4" onclick="forgotPasswordSubmit()">
                                    Gửi liên kết
                                </ui:button>

                                <div class="text-center">
                                    <a href="${pageContext.request.contextPath}/auth/login"
                                        class="text-sm text-blue-500 hover:underline">
                                        Quay lại đăng nhập
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        const forgotPasswordSubmit = () => {
                            let isValid = true;
                            isValid &= validateInput("email", (value) => {
                                if (value === "") {
                                    return "Email là bắt buộc!";
                                }

                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(value)) {
                                    return "Sai định dạng email!";
                                }

                                return "";
                            });

                            if (isValid) {
                                submitForm("forgotPasswordForm");
                            }
                        };
                    </script>
                </layout:mainLayout>