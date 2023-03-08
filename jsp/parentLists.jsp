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
		<h2 class="my-2">Parents Lists</h2>
		<% 
		if(session.getAttribute("userType").equals("Admin")){
		%>
		<div style="float: right;margin-bottom: 5px;"><a href="parentForm.jsp" class="btn btn-lg btn-block btn-outline-primary">Add Parent</a></div>
		<%
		}
		%>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">
				<tr>
					<th>Id</th>
					<th>Name</th>
					<th>Email</th>
                    <th>Contact Number</th>
					<th>Students</th>
					<th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
				<%
				ResultSet parentsList = null;
				if(session.getAttribute("userType").equals("Parent")){
					parentsList = dbmanager.excuteGetQuery("SELECT * FROM Parents WHERE parentId= '" + session.getAttribute("userId") + "'");
				} else if(session.getAttribute("userType").equals("Student") || request.getParameter("getParentDetails")!=null){
					String id= "";
					if(request.getParameter("getParentDetails")!=null){
						id = request.getParameter("id");
					} else {
						id = (String) session.getAttribute("userId").toString();
					}
					parentsList = dbmanager.excuteGetQuery("SELECT * FROM ParentStudents " +
					"INNER JOIN Parents " +
					"ON ParentStudents.parentId = Parents.parentId " +
					"WHERE ParentStudents.studentid = '"+ id + "'");
				
				}else {
				 parentsList = dbmanager.excuteGetQuery("SELECT * FROM Parents");
				}
                while(parentsList.next()){
                    String selectedParentId = parentsList.getString("parentId");
    				ResultSet studentList = dbmanager.excuteGetQuery("SELECT * FROM ParentStudents INNER JOIN Students ON ParentStudents.studentRegNumber = Students.studentRegNumber WHERE ParentStudents.parentId="+selectedParentId);
    				List<String> students = new ArrayList<String>();
    				while(studentList.next()){
                        students.add(studentList.getString("name"));
    				}
                    String student = String.join(", ", students);
                %>
				<tr>
					<td><%=parentsList.getString("parentId") %></td>
					<td><%=parentsList.getString("name") %></td>
					<td><%=parentsList.getString("email") %></td>
					<td><%=parentsList.getString("contactNumber") %></td>

					<td><%=student%></td>
					<% 
					if(!session.getAttribute("userType").equals("Student")){
					%>
					<td><a href="parentForm.jsp?id=<%=selectedParentId%>&action=edit" class="link-primary">Edit</a>
					</td>
					<% }
					if(session.getAttribute("userType").equals("Admin")){
					%>
					<td><a href="deleteParentDetails.jsp?id=<%=selectedParentId%>" class="link-danger">Delete</a></td>
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