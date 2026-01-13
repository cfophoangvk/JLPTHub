<%@ tag description="Table" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="caption" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<div class="relative w-full overflow-auto">
    <table class="rounded-md w-full caption-bottom text-sm ${className}">
        <c:if test="${not empty caption}">
            <caption class="mt-4 text-sm text-muted-foreground">${caption}</caption>
        </c:if>
        <jsp:doBody/>
    </table>
</div>