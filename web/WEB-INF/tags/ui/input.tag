<%@ tag description="Input" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="name" required="true" type="java.lang.String" %>
<%@ attribute name="type" required="false" type="java.lang.String" %>
<%@ attribute name="placeholder" required="false" type="java.lang.String" %>
<%@ attribute name="value" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="searchIcon" required="false" type="java.lang.Boolean" %>
<%@ attribute name="onInput" required="false" type="java.lang.String" %>

<div class="relative w-full">
    <c:if test="${searchIcon}">
        <jsp:include page="/assets/icon/search.jsp">
            <jsp:param name="size" value="4"/>
            <jsp:param name="className" value="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground"/>
        </jsp:include>
    </c:if>
    <input 
        type="${empty type ? 'text' : type}" 
        name="${name}"
        id="${id}"
        value="${value}"
        placeholder="${placeholder}"
        ${disabled ? 'disabled' : ''}
        oninput="${onInput}"
        class="file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground border-input h-9 w-full min-w-0 rounded-md border bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] ${searchIcon ? 'pl-9' : ''} ${className}"/>
</div>
<p class="text-sm text-red-500 hidden" id="error-${id}">Error Message</p>