<%@ tag description="Avatar" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="src" required="false" type="java.lang.String" %>
<%@ attribute name="alt" required="false" type="java.lang.String" %>
<%@ attribute name="fallback" required="true" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<div class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full ${className}">
    <c:choose>
        <c:when test="${not empty src}">
            <img class="aspect-square h-full w-full" src="${src}" alt="${alt}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
            <div class="flex h-full w-full items-center justify-center rounded-full bg-muted hidden">
                ${fallback}
            </div>
        </c:when>
        <c:otherwise>
            <div class="flex h-full w-full items-center justify-center rounded-full bg-muted">
                ${fallback}
            </div>
        </c:otherwise>
    </c:choose>
</div>