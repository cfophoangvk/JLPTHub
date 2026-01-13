<%@ tag description="Dialog Trigger" pageEncoding="UTF-8"%>
<%@ attribute name="targetId" required="true" type="java.lang.String" %>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<%@ attribute name="variant" required="false" type="java.lang.String" %>

<button onclick="openDialog('${targetId}')" class="${className}">
    <jsp:doBody/>
</button>