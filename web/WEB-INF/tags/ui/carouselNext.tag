<%@ tag description="Carousel Next" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="id" value="${requestScope.carouselId}" />

<button onclick="scrollCarousel('${id}', true)" class="absolute h-8 w-8 rounded-full border border-input bg-background -right-12 top-1/2 -translate-y-1/2 inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50">
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m9 18 6-6-6-6"/></svg>
    <span class="sr-only">Next slide</span>
</button>