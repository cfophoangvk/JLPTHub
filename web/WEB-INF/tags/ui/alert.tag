<%@ tag description="Alert" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="variant" required="false" type="java.lang.String" %>
<%@ attribute name="title" required="true" type="java.lang.String" %>
<%@ attribute name="icon" required="false" type="java.lang.Boolean" %>

<c:set var="baseClass" value="relative w-full rounded-lg border p-4 [&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground" />

<c:choose>
    <c:when test="${variant == 'destructive'}">
        <c:set var="variantClass" value="border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive" />
    </c:when>
    <c:otherwise>
        <c:set var="variantClass" value="bg-background text-foreground" />
    </c:otherwise>
</c:choose>

<div class="${baseClass} ${variantClass}" role="alert">
    <c:if test="${icon}">
        <%-- Sample Icon (Lucide AlertCircle) --%>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-alert-circle"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
    </c:if>
    <h5 class="mb-1 font-medium leading-none tracking-tight">${title}</h5>
    <div class="text-sm [&_p]:leading-relaxed">
        <jsp:doBody/>
    </div>
</div>