<%@ tag description="Alert Dialog Action" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="onclick" required="false" type="java.lang.String" %>
<%@ attribute name="type" required="false" type="java.lang.String" %>

<button type="${empty type ? 'button' : type}" onclick="${onclick}" class="inline-flex h-10 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground ring-offset-background transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 ${className}">
    <jsp:doBody/>
</button>