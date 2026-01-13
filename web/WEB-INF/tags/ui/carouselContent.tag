<%@ tag description="Carousel Content" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="id" value="${requestScope.carouselId}" />

<div id="${id}" class="flex w-full overflow-x-auto snap-x snap-mandatory scroll-smooth scrollbar-hide -ml-4">
    <jsp:doBody/>
</div>