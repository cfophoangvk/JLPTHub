<%@ tag description="Button" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="false" type="java.lang.String" %>
<%@ attribute name="variant" required="false" type="java.lang.String" %>
<%@ attribute name="size" required="false" type="java.lang.String" %>
<%@ attribute name="type" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="onclick" required="false" type="java.lang.String" %>

<%-- Defaults --%>
<c:set var="btnType" value="${empty type ? 'button' : type}" />
<c:set var="baseClass" value="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50" />

<%-- Variants --%>
<c:choose>
    <c:when test="${variant == 'outline'}">
        <c:set var="variantClass" value="border border-input bg-background hover:bg-accent hover:text-accent-foreground" />
    </c:when>
    <c:when test="${variant == 'secondary'}">
        <c:set var="variantClass" value="bg-secondary text-secondary-foreground hover:bg-secondary/80" />
    </c:when>
    <c:when test="${variant == 'ghost'}">
        <c:set var="variantClass" value="hover:bg-accent hover:text-accent-foreground" />
    </c:when>
    <c:when test="${variant == 'link'}">
        <c:set var="variantClass" value="text-primary underline-offset-4 hover:underline" />
    </c:when>
    <c:otherwise>
        <c:set var="variantClass" value="bg-primary text-primary-foreground hover:bg-primary/90" />
    </c:otherwise>
</c:choose>

<%-- Sizes --%>
<c:choose>
    <c:when test="${size == 'sm'}">
        <c:set var="sizeClass" value="h-9 rounded-md px-3" />
    </c:when>
    <c:when test="${size == 'lg'}">
        <c:set var="sizeClass" value="h-11 rounded-md px-8" />
    </c:when>
    <c:when test="${size == 'icon'}">
        <c:set var="sizeClass" value="h-10 w-10" />
    </c:when>
    <c:otherwise>
        <c:set var="sizeClass" value="h-10 px-4 py-2" />
    </c:otherwise>
</c:choose>

<button id="${id}" type="${btnType}" class="${baseClass} ${variantClass} ${sizeClass} ${className}" onclick="${onclick}">
    <jsp:doBody/>
</button>