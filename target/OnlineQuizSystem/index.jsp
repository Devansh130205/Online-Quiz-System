<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect root URL to login
    response.sendRedirect(request.getContextPath() + "/login");
%>
