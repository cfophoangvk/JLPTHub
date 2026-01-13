<%@ tag description="Separator" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="orientation" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<c:choose>
    <c:when test="${orientation == 'vertical'}">
        <c:set var="orientClass" value="h-full w-[1px]" />
    </c:when>
    <c:otherwise>
        <c:set var="orientClass" value="h-[1px] w-full" />
    </c:otherwise>
</c:choose>
<div class="shrink-0 bg-border ${orientClass} ${className}"></div>