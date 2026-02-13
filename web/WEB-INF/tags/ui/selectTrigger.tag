<%@ tag description="Select Trigger" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="placeholder" required="false" type="java.lang.String" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>

<c:set var="id" value="${requestScope.selectId}" />

<button type="button" 
        id="${id}"
        onclick="toggleSelect('${id}')"
        aria-expanded="false"
        ${disabled ? 'disabled' : ''}
        class="border-input data-[placeholder]:text-muted-foreground [&_svg:not([class*='text-'])]:text-muted-foreground focus:border-ring focus:ring-ring/50 flex items-center justify-between gap-2 rounded-md border bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs transition-[color,box-shadow] outline-none focus:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50 data-[size=default]:h-9 data-[size=sm]:h-8 *:data-[slot=select-value]:line-clamp-1 *:data-[slot=select-value]:flex *:data-[slot=select-value]:items-center *:data-[slot=select-value]:gap-2 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 ${className}">

    <span id="${id}-value" class="truncate">
        ${empty placeholder ? 'Chọn...' : placeholder}
    </span>
    <jsp:include page="/assets/icon/chevronDown.jsp">
        <jsp:param name="size" value="4"/>
        <jsp:param name="className" value="opacity-50"/>
    </jsp:include>
</button>
<p class="mt-1 text-sm text-red-500 hidden" id="error-${id}">Error Message</p>