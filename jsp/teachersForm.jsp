<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="dbConn.DbManager"%>
<%@ page import="dbConn.TeacherDbManager"%>

<%@ include file="header.jsp" %>



<%
TeacherDbManager teacherDbManager = new TeacherDbManager();
DbManager dbmanager = new DbManager();



if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 


String name=" ";
String salary=" ";
String teacherEmail="";
String teacherPassword = "";
List<String> subjects = new ArrayList<String>();
String selectedTeacherId=request.getParameter("id");


if (request.getParameter("submit") != null) {
	ResultSet duplicateMailIdSet = dbmanager.excuteGetQuery("SELECT * FROM Login WHERE userName='"+request.getParameter("teacherEmail")+"'");
	if(duplicateMailIdSet.next()){
  %>
<div class="warning">
	<p>Email id already registered...</p>
</div>
<%
	} else{
	if (selectedTeacherId!=null){
	    teacherDbManager.updateTeacherData(selectedTeacherId,request.getParameter("name"),request.getParameter("salary"),request.getParameterValues("subjects"),request.getParameter("teacherEmail"));
	}else {
    teacherDbManager.saveTeachersData(request.getParameter("name"),request.getParameter("salary"),request.getParameterValues("subjects"),request.getParameter("teacherEmail"),request.getParameter("teacherPassword"));
	}
    response.sendRedirect("teachersLists.jsp");
}

} else if (selectedTeacherId!=null){
	  ResultSet teacherResultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM Teachers WHERE Teachers.teacherId="+ selectedTeacherId);
	  while(teacherResultSet.next()){
	      name=teacherResultSet.getString("name");
	      salary=teacherResultSet.getString("salary");
		  teacherEmail=teacherResultSet.getString("teacherEmail");
	  }
	  
	  ResultSet subjectResultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM TeacherSubjects WHERE TeacherSubjects.teacherId="+ selectedTeacherId);
	  while(subjectResultSet.next()){
		  subjects.add(subjectResultSet.getString("name"));
	  }
}
  %>

<html>

<head>
	<style>
		.warning {
			background-color: #ffeeba;
			border: 1px solid #ffc107;
			color: #856404;
			padding: 1rem;
			margin-bottom: 1rem;
		}
	</style>
	<title>Teachers Form</title>
</head>

<body style="height: 100%;">
	<div class="container my-4">
		<%if(request.getParameter("action")==null){
                  %>
		<h3 class="text-primary">Enter Teacher Deatils</h3>
		<%
                } else {
                %>
		<h3 class="text-primary">Update Teacher Deatils</h3>
		<%
                } 
                %>
		<form method="post">

			<div class="form-group">
				<label for="name">Name</label> <input type="text" class="form-control form-control-lg col-sm-5"
					id="name" type="text" value="<%=name%>" name="name" placeholder="Enter Name">
			</div>

			<div class="form-group">
				<label for="teacherEmail">Email</label> <input type="email"
					class="form-control form-control-lg col-sm-5" id="teacherEmail" type="text"
					value="<%=teacherEmail%>" name="teacherEmail" placeholder="Enter Email">
			</div>
			<%if(request.getParameter("action")==null){
				%>

			<div class="form-group">
				<label for="teacherPassword">Password</label> <input type="password"
					class="form-control form-control-lg col-sm-5" id="teacherPassword" type="text"
					value="<%=teacherPassword%>" name="teacherPassword" placeholder="Enter Password">
			</div>
			<% }
%>

			<div class="form-group">
				<label for="name">Salary</label> <input type="text" class="form-control form-control-lg col-sm-5"
					id="salary" value="<%=salary%>" type="text" name="salary" placeholder="Enter Salary">
			</div>

			<div class="form-group">
				<label for="course">Subjects</label>
				<div class="form-check">
					<input class="form-check-input" type="checkbox" value="science"
						<%= subjects.contains("science") ? "checked" : "" %> id="science" name="subjects"> <label
						class="form-check-label" for="science"> Science </label>
				</div>
				<div class="form-check">
					<input class="form-check-input" type="checkbox" value="maths"
						<%= subjects.contains("maths") ? "checked" : "" %> id="maths" name="subjects"> <label
						class="form-check-label" for="maths"> Maths </label>
				</div>
				<div class="form-check">
					<input class="form-check-input" type="checkbox" value="english"
						<%= subjects.contains("english") ? "checked" : "" %> id="english" name="subjects"> <label
						class="form-check-label" for="english"> English </label>
				</div>
				<div class="form-check">
					<input class="form-check-input" type="checkbox" value="malayalam"
						<%= subjects.contains("malayalam") ? "checked" : "" %> id="malayalam" name="subjects"> <label
						class="form-check-label" for="malayalam"> Malayalam </label>
				</div>
			</div>

			<button type="submit" class="btn btn-primary mb-2" value="Submit" name="submit">Submit</button>
			<!-- <button type="submit" class="btn btn-primary mb-2" value="bulkEdit" name="bulkEdit"> Go to bulk edit</button> -->
		</form>
	</div>
</body>

</html>