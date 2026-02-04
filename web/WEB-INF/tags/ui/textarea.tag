<%@ tag description="Textarea" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" type="java.lang.String" %>
<%@ attribute name="id" required="false" type="java.lang.String" %>
<%@ attribute name="placeholder" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="rows" required="false" type="java.lang.String" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="onInput" required="false" type="java.lang.String" %>

<textarea
    name="${name}"
    id="${empty id ? name : id}"
    placeholder="${placeholder}"
    rows="${empty rows ? '3' : rows}"
    oninput="${empty onInput ? '' : onInput}"
    ${disabled ? 'disabled' : ''}
    class="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 ${className}"
><jsp:doBody/></textarea>
<c:if test="${not empty id}">
    <p class="text-sm text-red-500 hidden" id="error-${id}">Error Message</p>
</c:if>