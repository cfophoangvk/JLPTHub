<%@ tag description="Select" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" type="java.lang.String" description="Form input name" %>
<%@ attribute name="id" required="true" type="java.lang.String" description="Unique ID for JS logic" %>
<%@ attribute name="defaultValue" required="false" type="java.lang.String" %>

<div class="relative custom-select-container w-full">
    <input type="hidden" name="${name}" id="${id}" value="${defaultValue}" />
    
    <c:set var="selectId" value="${id}" scope="request" /> 
    
    <jsp:doBody/>
</div>