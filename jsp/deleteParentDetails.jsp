<%@ page import="java.sql.*"%>
<%@ page import="dbConn.DbManager"%>
<%@ page import="dbConn.LoginController" %>
<%@ include file="header.jsp" %>


<%

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 
%>
<div class="container my-4">
	<h4><%=request.getParameter("back")%></h4>

	<%
if(request.getParameter("id")!=null)
{	
	DbManager.excuteDeleteQuery("DELETE FROM Parents WHERE parentId=" + request.getParameter("id"));
	DbManager.excuteDeleteQuery("DELETE FROM ParentStudents WHERE parentId=" + request.getParameter("id"));
	DbManager.excuteDeleteQuery("DELETE FROM Login WHERE id=" + request.getParameter("id"));
    response.sendRedirect("parentLists.jsp");                   
}
%>
</div>