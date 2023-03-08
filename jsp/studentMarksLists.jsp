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

String id = request.getParameter("id");
String name = request.getParameter("name");
String course = request.getParameter("course");
ArrayList<String> subjects = new ArrayList<String>();

ResultSet subjectResultSet = dbmanager.excuteGetQuery("SELECT * FROM " + course+"Subjects");
while(subjectResultSet.next()){
	subjects.add(subjectResultSet.getString("subjectName"));
}

%>
<html>

<body style="height: 100%;">
	<div class="container my-4">
		<h2 class="my-2">Mark Lists - <%=name%></h2>
		<% 
if(session.getAttribute("userType").equals("Admin")||session.getAttribute("userType").equals("Teacher")){
%>
		<div style="float: right;margin-bottom: 5px;"><a
				href="addStudentMarks.jsp?id=<%=id%>&name=<%=name%>&course=<%=course%>"
				class="btn btn-lg btn-block btn-outline-primary" style="border-color: #212529;">Add Marks</a></div>

<%
		}
		%>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">
				<tr>
					<!-- <th>Student Id</th>
					<th>Student</th> -->
					<th>Course</th>
					<th>Semester</th>
					<%
   for(int i=0; i<subjects.size(); i++) {
      String subject = subjects.get(i);
%>
					<th><%=subject%></th>
					<%
				}
				%>
				</tr>
			</thead>
			<tbody>
				<%
				ResultSet markResultSet = dbmanager.excuteGetQuery("SELECT * FROM " + course+"Marks" + " where studentRegNumber=" + id);
				while(markResultSet.next()){
%>
<tr>
	<!-- <td><%=id%></td>
	<td><%=name%></td> -->
	<td><%=course%></td>
	<td><%=markResultSet.getString("semester")%></td>
	<%
	for(int i=0; i<subjects.size(); i++) {
  	%>
	<td><%=markResultSet.getString(subjects.get(i).replaceAll("\\s+",""))%></td>
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