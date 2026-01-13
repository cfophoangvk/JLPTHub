<%@ tag description="Carousel" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="true" type="java.lang.String" description="Required for button linkage" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<div class="relative w-full ${className}">
    <c:set var="carouselId" value="${id}" scope="request" />
    <jsp:doBody/>
</div>