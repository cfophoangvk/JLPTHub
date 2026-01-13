<%@page contentType="text/html" pageEncoding="UTF-8" import="model.TargetLevel" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
            <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
                <layout:mainLayout>
                    <div class="bg-gray-100 h-screen flex flex-col justify-center items-center space-y-3">
                        <jsp:include page="/assets/icon/logo.jsp" />

                        <div class="flex bg-white rounded-lg shadow-lg w-[800px] gap-4 relative">
                            <div id="imageSlider"
                                class="absolute top-0 bottom-0 w-1/2 transition-all duration-200 ease-linear translate-x-[100%] z-1">
                                <img src="${pageContext.request.contextPath}/assets/images/login.jpg"
                                    class="w-full h-full" alt="Login Image" />
                            </div>
                            <div class="w-1/2 p-8">
                                <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Đăng nhập</h2>

                                <c:if test="${not empty param.error or not empty error}">
                                    <div class="bg-red-100 text-red-700 p-2 mb-4 rounded text-sm text-center">
                                        <c:out value="${param.error}" />
                                        <c:out value="${error}" />
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.success or not empty success}">
                                    <div class="bg-green-100 text-green-700 p-2 mb-4 rounded text-sm text-center">
                                        <c:out value="${param.success}" />
                                        <c:out value="${success}" />
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.message}">
                                    <div class="bg-blue-100 text-blue-700 p-2 mb-4 rounded text-sm text-center">
                                        <c:if test="${param.message == 'logout_success'}">Đăng xuất thành công</c:if>
                                        <c:if test="${param.message != 'logout_success'}">
                                            <c:out value="${param.message}" />
                                        </c:if>
                                    </div>
                                </c:if>

                                <form id="loginForm" action="${pageContext.request.contextPath}/auth/login"
                                    method="post">
                                    <div class="mb-4">
                                        <ui:label htmlFor="loginEmail" label="Email" />
                                        <ui:input id="loginEmail" name="username" placeholder="example@gmail.com"
                                            value="${not empty isRegister ? '' : (not empty email ? email : param.username)}" />
                                    </div>
                                    <div class="mb-6">
                                        <ui:label htmlFor="loginPassword" label="Mật khẩu" />
                                        <ui:input id="loginPassword" type="password" name="password"
                                            placeholder="********" />
                                    </div>

                                    <div class="flex justify-end mb-4">
                                        <a href="${pageContext.request.contextPath}/auth/forgot-password"
                                            class="text-sm text-blue-500 hover:underline">Quên mật khẩu?</a>
                                    </div>

                                    <ui:button className="w-full !font-bold mb-2" onclick="loginSubmit()">
                                        Đăng nhập
                                    </ui:button>

                                    <a href="${pageContext.request.contextPath}/auth/google" class="w-full">
                                        <ui:button variant="outline" type="button" className="w-full space-x-2">
                                            <i class="fa-brands fa-google"></i>
                                            <span>Đăng nhập với Google</span>
                                        </ui:button>
                                    </a>
                                </form>

                                <p class="mt-4 text-center text-sm text-gray-600">
                                    Chưa có tài khoản? <button onclick="slideToRegister()"
                                        class="text-blue-500 hover:underline">Đăng ký</button>
                                </p>
                            </div>

                            <div class="w-1/2 p-8">
                                <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Đăng ký tài khoản</h2>

                                <form id="registerForm" action="${pageContext.request.contextPath}/auth/register"
                                    method="post">
                                    <div class="mb-4">
                                        <ui:label htmlFor="registerEmail" label="Email" />
                                        <ui:input id="registerEmail" name="username" placeholder="example@gmail.com"
                                            value="${not empty isRegister ? (not empty email ? email : param.username) : ''}" />
                                    </div>
                                    <div class="mb-4">
                                        <ui:label htmlFor="registerFullName" label="Họ và tên" />
                                        <ui:input id="registerFullName" name="fullName" placeholder="Nguyen Van A"
                                            value="${param.fullName}" />
                                    </div>
                                    <div class="mb-4">
                                        <ui:label htmlFor="registerPassword" label="Mật khẩu" />
                                        <ui:input id="registerPassword" type="password" name="password"
                                            placeholder="********" />
                                    </div>
                                    <ui:label htmlFor="targetLevel-trigger" label="Chọn cấp độ"></ui:label>

                                    <ui:select name="targetLevel" id="targetLevel">
                                        <ui:selectTrigger placeholder="Chọn cấp độ" className="w-full mb-2" />

                                        <ui:selectContent>
                                            <c:forEach items="${TargetLevel.values()}" var="i">
                                                <ui:selectItem value="${i}">${i}</ui:selectItem>
                                            </c:forEach>
                                        </ui:selectContent>
                                    </ui:select>

                                    <ui:button className="w-full !font-bold mb-2" onclick="registerSubmit()">
                                        Đăng ký
                                    </ui:button>

                                    <a href="${pageContext.request.contextPath}/auth/google" class="w-full">
                                        <ui:button variant="outline" type="button" className="w-full space-x-2">
                                            <i class="fa-brands fa-google"></i>
                                            <span>Đăng ký với Google</span>
                                        </ui:button>
                                    </a>
                                </form>

                                <p class="mt-4 text-center text-sm text-gray-600">
                                    Đã có tài khoản? <button onclick="slideToLogin()"
                                        class="text-blue-500 hover:underline">Đăng nhập</button>
                                </p>
                            </div>
                        </div>

                        <script>
                            const imageSlider = document.getElementById("imageSlider");
                            const slideToRegister = () => {
                                imageSlider.classList.remove('translate-x-[100%]');
                            };

                            const slideToLogin = () => {
                                imageSlider.classList.add('translate-x-[100%]');
                            };

                            const url = location.href;
                            const urlParams = new URL(url).searchParams;
                            if (url.includes("register") || urlParams.get("isRegister")) {
                                slideToRegister();
                            }

                            const emailValidation = (value) => {
                                if (value === "") {
                                    return "Email là bắt buộc!";
                                }

                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(value)) {
                                    return "Sai định dạng email!";
                                }

                                return "";
                            };

                            const passwordValidation = (value) => {
                                if (value === "") {
                                    return "Mật khẩu là bắt buộc!";
                                }

                                return "";
                            };

                            //Kiểm tra mật khẩu khi đăng ký
                            const passwordRegisterValidation = (value) => {
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

                            const targetLevelValidation = (value) => {
                                if (value === "") {
                                    return "Cấp độ là bắt buộc!";
                                }
                                return "";
                            };

                            const fullNameValidation = (value) => {
                                if (value === "") {
                                    return "Họ và tên là bắt buộc!";
                                } else if (value.length < 10) {
                                    return "Họ và tên phải có ít nhất 10 ký tự!";
                                }
                                return "";
                            };

                            const loginSubmit = () => {
                                let isValid = true;
                                isValid &= validateInput("loginEmail", emailValidation);
                                isValid &= validateInput("loginPassword", passwordValidation);

                                if (isValid) {
                                    submitForm("loginForm");
                                }
                            };

                            const registerSubmit = () => {
                                let isValid = true;
                                isValid &= validateInput("registerEmail", emailValidation);
                                isValid &= validateInput("registerPassword", passwordRegisterValidation);
                                isValid &= validateInput("registerFullName", fullNameValidation);
                                isValid &= validateInput("targetLevel", targetLevelValidation);

                                if (isValid) {
                                    submitForm("registerForm");
                                }
                            };
                        </script>
                    </div>
                </layout:mainLayout>