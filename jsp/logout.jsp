<%@ page import="dbConn.LoginController"%>
<%@ page import="dbConn.DbManager"%>
<%@ include file="header.jsp" %>

<%
session.removeAttribute("userType");
session.removeAttribute("userName");
session.removeAttribute("userId");
response.sendRedirect("login.jsp");
%>