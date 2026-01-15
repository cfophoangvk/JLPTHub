<%@ tag description="Carousel Previous" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="id" value="${requestScope.carouselId}" />

<button onclick="scrollCarousel('${id}', false)" class="absolute size-10 rounded-full border border-input bg-background -left-12 top-1/2 -translate-y-1/2 inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50">
    <jsp:include page="/assets/icon/chevronLeft.jsp">
        <jsp:param name="size" value="6" />
    </jsp:include>
    <span class="sr-only">Previous slide</span>
</button>