<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*"%>
<%@ page import="dbConn.DbManager"%>

<%@ include file="header.jsp" %>


<%
DbManager dbmanager = new DbManager();

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} else {
%>
<html>

<body style="height: 100%;">
	<div class="container my-4">
		<h2 class="my-2">Student Lists</h2>
		<% 
		if(session.getAttribute("userType").equals("Admin")||session.getAttribute("userType").equals("Teacher")){
		%>
		<div style="float: right;margin-bottom: 5px;"><a href="studentForm.jsp"
				class="btn btn-lg btn-block btn-outline-primary" style="border-color: #212529;">Add Student</a></div>
		<%
		}
		%>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">    
				<tr>
					<th>Id</th>
					<th>Name</th>
					<th>Course</th>
					<th>Permanent Address</th>
					<th>Present Address</th>
					<th>Email</th>
					<!-- <th>Course Fee</th>
					<th>Exam fee</th> -->

					<th colspan="5"></th>
				</tr>
			</thead>
			<tbody>
				<%
				ResultSet resultSet = null;
				if(session.getAttribute("userType").equals("Student")){
					resultSet = dbmanager.excuteGetQuery("SELECT * FROM Students JOIN StudentAddress ON Students.studentRegNumber = StudentAddress.studentRegNumber WHERE Students.studentRegNumber = '" + session.getAttribute("userId") + "'");
				} else if(session.getAttribute("userType").equals("Parent")){
					String query = "SELECT * FROM Students " 
             + "JOIN StudentAddress ON Students.studentRegNumber = StudentAddress.studentRegNumber "
             + "JOIN ParentStudents ON Students.studentRegNumber = ParentStudents.studentRegNumber "
             + "WHERE ParentStudents.parentId = ?";

PreparedStatement statement = dbmanager.getDbConnection().prepareStatement(query);
statement.setString(1, (String) session.getAttribute("userId"));
 resultSet = statement.executeQuery();		
	}
					else{
				 resultSet = dbmanager.excuteGetQuery("SELECT * FROM Students JOIN StudentAddress ON Students.studentRegNumber=StudentAddress.studentRegNumber;");
				}
                while(resultSet.next()){
                    String selectedId = resultSet.getString("studentRegNumber");
					String name = resultSet.getString("name");
                %>
				<tr>
					<td><%=resultSet.getString("studentRegNumber") %></td>
					<td><%=name%></td>
					<td><%=resultSet.getString("course") %></td>
					<td><%=resultSet.getString("permanentAddress") %></td>
					<td><%=resultSet.getString("presentAddress") %></td>
					<td><%=resultSet.getString("studentEmail") %></td>
					<!-- <td><%=resultSet.getString("courseFee") %></td>
					<td><%=resultSet.getString("examFee") %></td> -->


					<td><a href="studentForm.jsp?id=<%=selectedId%>&action=edit" class="link-primary">Edit</a></td>

					<% 
if(session.getAttribute("userType").equals("Admin")||session.getAttribute("userType").equals("Teacher")){
%>

					<td><a href="deleteStudentDetails.jsp?id=<%=selectedId%>" class="link-danger">Delete</a></td>
					<%
}
%>
					<td><a href="studentMarksLists.jsp?id=<%=selectedId%>&name=<%=name%>&course=<%=resultSet.getString("course")%>"
							class="link-danger">Show Marks </a></td>
					<td><a href="studentAttendanceReport.jsp?id=<%=selectedId%>&name=<%=name%>" class="link-danger">Show
							Attendence </a></td>

							<td><a href="parentLists.jsp?getParentDetails&id=<%=selectedId%>&name=<%=name%>" class="link-danger">Show
								Parents </a></td>
	

				</tr>
				<%
				}
                %>

			</tbody>
		</table>
	</div>
</body>

</html>
<%
}%>