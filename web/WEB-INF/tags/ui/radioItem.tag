<%@ tag description="Radio Item" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" type="java.lang.String" %>
<%@ attribute name="value" required="true" type="java.lang.String" %>
<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="checked" required="false" type="java.lang.Boolean" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>

<div class="flex items-center space-x-2">
    <input 
        type="radio" 
        value="${value}" 
        id="${id}" 
        name="${name}" 
        class="peer sr-only" 
        ${checked ? 'checked' : ''}
        ${disabled ? 'disabled' : ''}
        />

    <label for="${id}" class="aspect-square size-4 rounded-full border border-primary text-primary ring-offset-background focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 peer-disabled:cursor-not-allowed peer-disabled:opacity-50 flex items-center justify-center cursor-pointer peer-checked:[&_svg]:block">
        <svg width="8" height="8" viewBox="0 0 24 24" fill="currentColor" class="hidden peer-checked:block text-current">
        <circle cx="12" cy="12" r="12" />
        </svg>
    </label>

    <label for="${id}" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer">
        <jsp:doBody/>
    </label>
</div>