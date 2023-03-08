<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*"%>
<%@ page import="dbConn.DbManager"%>

<%@ include file="header.jsp" %>


<%
DbManager dbmanager = new DbManager();

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 
%>
<%@ page import="java.sql.*" %>
<html>

<head>
    <title>Attendance Report</title>
</head>

<body style="height: 100%;">
    <div class="container my-4">
        <h2 class="my-2">Attendance Report - <%=request.getParameter("name")%></h2>
        <%
String id = request.getParameter("id");
if (id == null) {
%>
        <h2 class="my-2">Invalid student ID</h2>
        <%
} else {
    try {
        // Query the database to get attendance report data for the specified student ID
        ResultSet rs = DbManager.excuteGetQuery("SELECT course, semester, totalPresent, totalAbsent FROM AttendanceReports WHERE studentRegNumber='" + id + "'");
%>
        <table class="table table-striped table-hover">
            <thead class="thead-dark">
                <tr>
                    <th>Course</th>
                    <th>Semester</th>
                    <th>Total Present</th>
                    <th>Total Absent</th>
                </tr>
            </thead>
            <%
        while (rs.next()) {
            String course = rs.getString("course");
            String semester = rs.getString("semester");
            int totalPresent = rs.getInt("totalPresent");
            int totalAbsent = rs.getInt("totalAbsent");
%>
            <tr>
                <td><%= course %></td>
                <td><%= semester %></td>
                <td><%= totalPresent %></td>
                <td><%= totalAbsent %></td>
            </tr>
            <%
        }
%>
        </table>
        <%
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>
    </div>
</body>

</html>