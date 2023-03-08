<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="dbConn.DbManager"%>

<%@ include file="header.jsp" %>


<%
DbManager dbmanager = new DbManager();



if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 

%>
<html>

<body style="height: 100%;">
	<div class="container my-4">
		<h2 class="my-2">Teachers Lists</h2>
		<% 
		if(session.getAttribute("userType").equals("Admin")){
		%>
		<div style="float: right;margin-bottom: 5px;"><a href="teachersForm.jsp"
				class="btn btn-lg btn-block btn-outline-primary">Add Teacher</a></div>
		<%
		}
		%>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">
				<tr>
					<th>Id</th>
					<th>Name</th>
					<th>Salary</th>
					<th>Email</th>
					<th>Subjects</th>
					<th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
				<%
				ResultSet teachersList = null;
				if(session.getAttribute("userType").equals("Admin")){
					teachersList = dbmanager.excuteGetQuery("SELECT * FROM Teachers");
				} else {
				 teachersList = dbmanager.excuteGetQuery("SELECT * FROM Teachers WHERE Teachers.teacherId = '" + session.getAttribute("userId") + "'");

				}
                while(teachersList.next()){
                    String selectedTeacherId = teachersList.getString("teacherId");
    				ResultSet subjectList = dbmanager.excuteGetQuery("SELECT * FROM TeacherSubjects WHERE TeacherSubjects.teacherId="+selectedTeacherId);
    				List<String> subjects = new ArrayList<String>();
    				while(subjectList.next()){
                        subjects.add(dbmanager.toCapitalCase(subjectList.getString("name")));
    				}
                    String subject = String.join(", ", subjects);
                %>
				<tr>
					<td><%=teachersList.getString("teacherId") %></td>
					<td><%=teachersList.getString("name") %></td>
					<td><%=teachersList.getString("salary") %></td>
					<td><%=teachersList.getString("teacherEmail") %></td>

					<td><%=subject%></td>
					<% if(session.getAttribute("userType").equals("Admin") || session.getAttribute("userType").equals("Teacher")){%>
					<td><a href="teachersForm.jsp?id=<%=selectedTeacherId%>&action=edit" class="link-primary">Edit</a>
					</td>
					<% }
					if(session.getAttribute("userType").equals("Admin")){
					%>
					<td><a href="deleteTeacherDetails.jsp?id=<%=selectedTeacherId%>" class="link-danger">Delete</a></td>
					<%
					}
					%>

				</tr>
				<%
				}
                %>

			</tbody>
		</table>
	</div>
</body>

</html>