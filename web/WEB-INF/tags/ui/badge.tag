<%@ tag description="Badge" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="variant" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<c:set var="baseClass" value="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2" />

<c:choose>
    <c:when test="${variant == 'secondary'}">
        <c:set var="variantClass" value="border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80" />
    </c:when>
    <c:when test="${variant == 'outline'}">
        <c:set var="variantClass" value="border-input text-foreground" />
    </c:when>
    <c:otherwise>
        <c:set var="variantClass" value="border-transparent bg-primary text-primary-foreground hover:bg-primary/80" />
    </c:otherwise>
</c:choose>

<div class="${baseClass} ${variantClass} ${className}">
    <jsp:doBody/>
</div>