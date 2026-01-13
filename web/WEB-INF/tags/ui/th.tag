<%@ tag description="Table Header" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<th class="p-4 py-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 ${className}">
    <jsp:doBody/>
</th>