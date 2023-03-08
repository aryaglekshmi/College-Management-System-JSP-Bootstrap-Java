<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="dbConn.DbManager"%>

<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="header.jsp" %>


<%
DbManager dbmanager = new DbManager();

String name = request.getParameter("name");
String id = request.getParameter("id");
if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 
%>
<html>

<body style="height: 100%;">
	<div class="container my-4">
		<h2 class="my-2">Student Attendance Report - <%=name%> </h2>
		<% 
		if(session.getAttribute("userType").equals("Admin")||session.getAttribute("userType").equals("Teacher")){
		%>
		<!-- <div style="float: right;margin-bottom: 5px;">
			<a href="addStudentAttendence.jsp?id=<%=id%>&name=<%=name%>"
				class="btn btn-lg btn-block btn-outline-primary" style="border-color: #212529;">Add Attendance</a>
				<a href="attendanceReport.jsp?id=<%=id%>&name=<%=name%>"
					class="btn btn-lg btn-block btn-outline-primary" style="border-color: #212529;">Attendance Report</a>
		</div> -->
		<div class="row" style="padding-bottom: 10px;">
			<div class="col-md-6">
							</div>
			<div class="col-md-6" style="
			display: flex;
			flex-direction: row;
			align-items: flex-end;
			justify-content: space-evenly;
		">
				<a href="addStudentAttendence.jsp?id=<%=id%>&name=<%=name%>"
					class="btn btn-lg btn-block btn-outline-primary float-right" style="border-color: #212529;">Add Attendance</a>
				<a href="attendanceReport.jsp?id=<%=id%>&name=<%=name%>"
					class="btn btn-lg btn-block btn-outline-primary  float-right mr-2" style="border-color: #212529;margin-left: 4px;">Attendance Report</a>			</div>
		  </div>
		<% } %>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">
				<tr>
					<!-- <th>Student Id</th>
					<th>Student</th> -->
					<th>Course</th>
					<th>Semester</th>
					<th>Date</th>
					<th>Attendance</th>
				</tr>
			</thead>
			<tbody>
				<%
				ResultSet presentResultSet = dbmanager.excuteGetQuery("SELECT * FROM PresentReport WHERE studentRegNumber ="+id);
				while(presentResultSet.next()){
				%>
				<tr>
					<!-- <td><%=id%></td>
					<td><%=name%></td> -->
					<td><%=presentResultSet.getString("course")%></td>
					<td><%=presentResultSet.getString("semester")%></td>
					<td><%= new SimpleDateFormat("yyyy-MM-dd").format(presentResultSet.getDate("date")) %></td>
					<td>Present</td>

				</tr>
				<%
				}
				%>
				<%
				ResultSet absentResultSet = dbmanager.excuteGetQuery("SELECT * FROM AbsentReport WHERE studentRegNumber ="+id);
				while(absentResultSet.next()){
				%>
				<tr>
					<!-- <td><%=id%></td>
					<td><%=name%></td> -->
					<td><%=absentResultSet.getString("course")%></td>
					<td><%=absentResultSet.getString("semester")%></td>
					<td><%= new SimpleDateFormat("yyyy-MM-dd").format(absentResultSet.getDate("date")) %></td>
					<td>Absent</td>

				</tr>
				<%
				}
				%>

			</tbody>
		</table>
	</div>
</body>

</html>