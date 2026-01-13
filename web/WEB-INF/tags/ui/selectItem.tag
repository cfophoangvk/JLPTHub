<%@ tag description="Select Item" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="value" required="true" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<c:set var="id" value="${requestScope.selectId}" />

<jsp:doBody var="bodyText" />

<div onclick="selectOption('${id}', '${value}', '${bodyText.trim()}')" 
     class="relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none hover:bg-accent hover:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 cursor-pointer ${className}">
    
    <span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center"></span>

    ${bodyText}
</div>