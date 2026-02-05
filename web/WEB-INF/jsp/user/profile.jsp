<%@page contentType="text/html" pageEncoding="UTF-8" import="model.TargetLevel" %>
    <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <layout:mainLayout>
                    <div class="container mx-auto px-4 py-8">
                        <div class="max-w-2xl mx-auto bg-white rounded-lg shadow-lg">
                            <div class="px-6 py-4 flex justify-between items-center">
                                <ui:badge variant="secondary">
                                    <h2 class="font-bold">Thông tin cá nhân</h2>
                                </ui:badge>
                                <ui:button className="text-white !font-bold">
                                    <a href="${pageContext.request.contextPath}/auth/logout">
                                        <i class="fa-solid fa-right-from-bracket mr-1"></i> Đăng xuất
                                    </a>
                                </ui:button>
                            </div>

                            <div class="p-6">
                                <div class="flex items-center space-x-4 mb-6">
                                    <div
                                        class="h-20 w-20 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 text-3xl">
                                        <c:choose>
                                            <c:when test="${not empty currentUser.googleId}">
                                                <i class="fa-brands fa-google"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-user"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <h3 class="text-xl font-bold text-gray-800">${currentUser.fullName}</h3>
                                        <p class="text-gray-600">${currentUser.email}</p>
                                        <c:if test="${currentUser.isEmailVerified}">
                                            <span
                                                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800 mt-1">
                                                <i class="fa-solid fa-check-circle mr-1"></i> Đã xác thực
                                            </span>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="border-t pt-6">
                                    <h4 class="text-lg font-semibold mb-4 text-gray-700">Cập nhật thông tin</h4>

                                    <c:if test="${not empty error}">
                                        <div class="bg-red-100 text-red-700 p-2 mb-4 rounded text-sm">
                                            <c:out value="${error}" />
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty success}">
                                        <div class="bg-green-100 text-green-700 p-2 mb-4 rounded text-sm">
                                            <c:out value="${success}" />
                                        </div>
                                    </c:if>

                                    <form action="/JLPTHub/user/profile" method="post" id="userProfileForm">
                                        <input type="hidden" name="id" value="${currentUser.id}" />
                                        <div class="grid grid-cols-1 gap-6">
                                            <div>
                                                <ui:label htmlFor="fullName" label="Họ và tên" required="true"/>
                                                <ui:input id="fullName" name="fullName" value="${currentUser.fullName}" />
                                            </div>

                                            <div>
                                                <ui:label htmlFor="targetLevel" label="Mục tiêu JLPT" required="true"/>
                                                <ui:select name="targetLevel" id="targetLevel" defaultValue="${currentUser.targetLevel}">
                                                    <ui:selectTrigger
                                                        placeholder="${not empty currentUser.targetLevel ? currentUser.targetLevel : 'Chọn cấp độ'}"
                                                        className="w-full" />
                                                    <ui:selectContent>
                                                        <c:forEach items="${TargetLevel.values()}" var="i">
                                                            <ui:selectItem value="${i}">${i}</ui:selectItem>
                                                        </c:forEach>
                                                    </ui:selectContent>
                                                </ui:select>
                                            </div>

                                            <div class="flex justify-end pt-4">
                                                <ui:button onclick="doValidation()" className="w-full sm:w-auto">
                                                    Lưu thay đổi
                                                </ui:button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                                                
                    <ui:alertDialog id="alert-question-form">
                        <ui:alertDialogHeader>
                            <ui:alertDialogTitle>Xác nhận</ui:alertDialogTitle>
                            <ui:alertDialogDescription>
                                Bạn có muốn cập nhật thông tin cá nhân?
                            </ui:alertDialogDescription>
                        </ui:alertDialogHeader>

                        <ui:alertDialogFooter>
                            <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                            <ui:alertDialogAction onclick="submitForm('userProfileForm')">
                                OK
                            </ui:alertDialogAction>
                        </ui:alertDialogFooter>
                    </ui:alertDialog>
                                
                    <script>
                        const fullNameValidation = (value) => {
                            if (!value.trim()) {
                                return "Vui lòng điền họ và tên!";
                            }
                            return "";
                        };
                        
                        const doValidation = () => {
                            let isValid = true;
                            isValid &= validateInput('fullName', fullNameValidation);
                            
                            if (isValid) {
                                openDialog('alert-question-form');
                            }
                        };
                    </script>
                </layout:mainLayout>