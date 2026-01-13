<%@tag description="Label" pageEncoding="UTF-8"%>
<%@ attribute name="htmlFor" required="true" type="java.lang.String" %>
<%@ attribute name="label" required="true" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="required" required="false" type="java.lang.Boolean" %>
<label for="${htmlFor}" class="block my-2 text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 ${className}">
    ${label} <span class="text-red-500 ${required ? '' : 'hidden'}">*</span>
</label>