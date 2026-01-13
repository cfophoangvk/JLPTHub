<%@ tag description="Table Data" pageEncoding="UTF-8"%>
<%@ attribute name="className" required="false" type="java.lang.String" %>
<td class="p-4 py-2 align-middle [&:has([role=checkbox])]:pr-0 ${className}">
    <jsp:doBody/>
</td>