<%@ tag description="Dialog Header" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>

<div class="flex flex-col space-y-1.5 text-center sm:text-left ${className}">
    <jsp:doBody/>
</div>