<%@ tag description="Alert Dialog" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="true" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<dialog id="${id}" class="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 z-50 max-w-lg gap-4 border bg-background p-6 shadow-lg duration-200 sm:rounded-lg text-foreground backdrop:bg-black/80 m-0 open:!mt-0 ${className}">
    <button onclick="closeDialog(this)" class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground">
        <jsp:include page="/assets/icon/x.jsp">
            <jsp:param name="size" value="4"/>
        </jsp:include>
        <span class="sr-only">Close</span>
    </button>
    <div class="grid gap-4">
        <jsp:doBody/>
    </div>
</dialog>