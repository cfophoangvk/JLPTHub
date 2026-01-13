<%@ tag description="Card" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="title" required="false" type="java.lang.String" %>
<%@ attribute name="description" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="footer" required="false" fragment="true" %>

<div class="rounded-lg border border-input bg-card text-card-foreground shadow-sm ${className}">
    <c:if test="${not empty title or not empty description}">
        <div class="flex flex-col space-y-1.5 p-6">
            <c:if test="${not empty title}">
                <h3 class="text-2xl font-semibold leading-none tracking-tight">${title}</h3>
            </c:if>
            <c:if test="${not empty description}">
                <p class="text-sm text-muted-foreground">${description}</p>
            </c:if>
        </div>
    </c:if>

    <div class="p-6 pt-0">
        <jsp:doBody/>
    </div>

    <c:if test="${not empty footer}">
        <div class="flex items-center p-6 pt-0">
            <jsp:invoke fragment="footer"/>
        </div>
    </c:if>
</div>