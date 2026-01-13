<%@ tag description="Input" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="name" required="true" type="java.lang.String" %>
<%@ attribute name="type" required="false" type="java.lang.String" %>
<%@ attribute name="placeholder" required="false" type="java.lang.String" %>
<%@ attribute name="value" required="false" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>

<input 
    type="${empty type ? 'text' : type}" 
    name="${name}"
    id="${id}"
    value="${value}"
    placeholder="${placeholder}"
    ${disabled ? 'disabled' : ''}
    class="file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground border-input h-9 w-full min-w-0 rounded-md border bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] ${className}"
    />
<p class="text-sm text-red-500 hidden" id="error-${id}">Error Message</p>