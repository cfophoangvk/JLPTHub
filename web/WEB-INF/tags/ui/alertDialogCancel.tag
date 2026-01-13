<%@ tag description="Alert Dialog Cancel" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<button type="button" onclick="closeDialog(this)" class="mt-2 inline-flex h-10 items-center justify-center rounded-md border border-input bg-background px-4 py-2 text-sm font-medium ring-offset-background transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 sm:mt-0 ${className}">
    <jsp:doBody/>
</button>