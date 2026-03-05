<%@ page import="com.gymtracker.model.User" %>
<%
User user = (User) session.getAttribute("user");
if(user != null){
    response.sendRedirect("dashboard/dashboard.jsp");
} else {
    response.sendRedirect("auth/login.jsp");
}
%>
