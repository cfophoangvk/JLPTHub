<%@ tag description="Select Content" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="className" required="false" type="java.lang.String" %>

<c:set var="id" value="${requestScope.selectId}" />

<div id="${id}-content" 
     class="hidden absolute top-[calc(100%+5px)] z-50 min-w-[8rem] w-full overflow-hidden rounded-md border border-input bg-popover text-popover-foreground shadow-md animate-in ${className}">
    <div class="p-1">
        <jsp:doBody/>
    </div>
</div>