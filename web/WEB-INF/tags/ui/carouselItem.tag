<%@ tag description="Carousel Item" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<div role="group" aria-roledescription="slide" 
     class="min-w-0 shrink-0 grow-0 basis-full pl-4 snap-start ${className}">
    <jsp:doBody/>
</div>