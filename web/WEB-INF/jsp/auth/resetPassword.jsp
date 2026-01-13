<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <layout:mainLayout>
                    <div class="bg-gray-100 h-screen flex flex-col justify-center items-center space-y-3">
                        <jsp:include page="/assets/icon/logo.jsp" />

                        <div class="bg-white rounded-lg shadow-lg w-[400px] p-8">
                            <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Đặt lại mật khẩu</h2>

                            <c:if test="${not empty error}">
                                <div class="bg-red-100 text-red-700 p-2 mb-4 rounded text-sm text-center">
                                    <c:out value="${error}" />
                                </div>
                            </c:if>

                            <form id="resetPasswordForm" action="${pageContext.request.contextPath}/auth/reset-password"
                                method="post">
                                <input type="hidden" name="token" value="${token}" />

                                <div class="mb-4">
                                    <ui:label htmlFor="password" label="Mật khẩu mới" />
                                    <ui:input id="password" type="password" name="password" placeholder="********" />
                                </div>

                                <div class="mb-6">
                                    <ui:label htmlFor="confirmPassword" label="Xác nhận mật khẩu" />
                                    <ui:input id="confirmPassword" type="password" name="confirmPassword"
                                        placeholder="********" />
                                </div>

                                <ui:button className="w-full !font-bold mb-4" onclick="validateReset()">
                                    Đổi mật khẩu
                                </ui:button>
                            </form>

                            <script>
                                const passwordValidation = (value) => {
                                    if (value === "") {
                                        return "Mật khẩu là bắt buộc!";
                                    }
                                    console.log(value.length);
                                    if (value.length < 8) {
                                        return "Mật khẩu phải chứa ít nhất 8 ký tự!";
                                    }

                                    const hasLowercase = /[a-z]/.test(value);
                                    const hasUppercase = /[A-Z]/.test(value);
                                    const hasNumber = /\d/.test(value);
                                    const hasSpecialChar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value);

                                    let passwordInvalidFormatMsg = "";
                                    if (!hasLowercase) {
                                        passwordInvalidFormatMsg += "Mật khẩu phải có ít nhất một chữ thường!\n";
                                    }
                                    if (!hasUppercase) {
                                        passwordInvalidFormatMsg += "Mật khẩu phải có ít nhất một chữ hoa!\n";
                                    }
                                    if (!hasNumber) {
                                        passwordInvalidFormatMsg += "Mật khẩu phải có ít nhất một số!\n";
                                    }
                                    if (!hasSpecialChar) {
                                        passwordInvalidFormatMsg += "Mật khẩu phải có ít nhất một ký tự đặc biệt!\n";
                                    }

                                    return passwordInvalidFormatMsg;
                                };

                                const confirmPasswordValidation = (value) => {
                                    if (value === "") {
                                        return "Mật khẩu xác nhận là bắt buộc!";
                                    }
                                    //Trường hợp này phải lấy element password để so sánh kết quả
                                    const passwordValue = document.getElementById("password").value;
                                    return value !== passwordValue ? "Mật khẩu xác nhận không khớp!" : "";
                                };

                                const validateReset = () => {
                                    let isValid = true;
                                    isValid &= validateInput("password", passwordValidation);
                                    isValid &= validateInput("confirmPassword", confirmPasswordValidation);

                                    if (isValid) {
                                        submitForm('resetPasswordForm');
                                    }
                                };
                            </script>
                        </div>
                    </div>
                </layout:mainLayout>