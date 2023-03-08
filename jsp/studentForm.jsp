<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
  integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*" %>
<%@ page import="dbConn.StudentDbManager" %>
<%@ page import="dbConn.DbManager" %>

<%@ include file="header.jsp" %>


<%
StudentDbManager studentDbManager = new StudentDbManager();
DbManager dbmanager= new DbManager();
String name="";
String course="";
String permanentAddress="";
String presentAddress="";
String studentEmail="";
String studentPassword="";
String regNumber = "";
String selectedStudentId=request.getParameter("id");

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 
%>
<%       
 if(request.getParameter("bulkEdit")!=null){
  response.sendRedirect("bulkStudentDetailsOperation.jsp");  
}
if(selectedStudentId!=null){
  request.setAttribute("selectedStudentId",selectedStudentId);
  ResultSet resultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM Students JOIN StudentAddress ON Students.studentRegNumber=StudentAddress.studentRegNumber WHERE Students.studentRegNumber="+ selectedStudentId);
  while(resultSet.next()){
      name=resultSet.getString("name");
      course=resultSet.getString("course");
            permanentAddress=resultSet.getString("permanentAddress");
            presentAddress=resultSet.getString("presentAddress");
            studentEmail=resultSet.getString("studentEmail");
            

  }
} 
if (request.getParameter("submit") != null) {
  ResultSet duplicateMailIdSet = null;
  if(selectedStudentId!=null){
    duplicateMailIdSet = dbmanager.excuteGetQuery("SELECT * FROM Login WHERE userName='" + request.getParameter("studentEmail") + "' AND id != " + selectedStudentId);
  } else{
   duplicateMailIdSet = dbmanager.excuteGetQuery("SELECT * FROM Login WHERE userName='"+request.getParameter("studentEmail")+"'");
  }
  if(duplicateMailIdSet.next()){
%>
<div class="warning">
  <p>Email id already registered...</p>
</div>
<%
  } else {
boolean isSaved = false;
 if(selectedStudentId!=null){
   isSaved = studentDbManager.updateStudentData(selectedStudentId,request.getParameter("name"),request.getParameter("course"), request.getParameter("permanentAddress"), request.getParameter("presentAddress"), request.getParameter("studentEmail"));
   if(isSaved){
    response.sendRedirect("studentLists.jsp"); 
}else {
  %>
  <div class="warning">
    <p>Registration number already exists...</p>
  </div>
  
  <%
  }
}
  else {
    studentDbManager.saveStudentData(request.getParameter("regNumber"),request.getParameter("name"),request.getParameter("course"),request.getParameter("permanentAddress"), request.getParameter("presentAddress"), request.getParameter("studentEmail"), request.getParameter("studentPassword"));
    response.sendRedirect("studentLists.jsp"); 
  }



}
}
%>
<html>

<head>
  <title>Student Form</title>
</head>

<body style="height: 100%;">
  <div class="container my-4">
    <%if(request.getParameter("action")==null){
          %>
    <h3 class="text-primary">Enter Student Deatils</h3>
    <%
        } else {
        %>
    <h3 class="text-primary"> Update Student Deatils</h3>
    <%
        } 
        %>
    <form method="post">
      <div class="form-group">
        <label for="regNumber"> Registration Number: </label>
        <input type="number" class="form-control form-control-lg col-sm-5" id="regNumber" name="regNumber" 
          id="regNumber" value="<%=selectedStudentId%>" <%= selectedStudentId==null ? "" : "disabled" %> placeholder="Enter Registration Number" required>
      </div>

      <div class="form-group">
        <label for="name">Name</label>
        <input type="text" class="form-control form-control-lg col-sm-5" id="name" type="text" name="name"
          value="<%=name%>" placeholder="Enter Name" required>
      </div>

      <div class="form-group">
        <label for="course">Course</label>
        <select class="form-control form-control-lg col-sm-5" id="course" name="course" value="<%=course%>" id="course">
          <option>Select course</option>
          <%
          ResultSet courseResultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM Courses");
          while(courseResultSet.next()){
          %>
          <option value="<%=courseResultSet.getString("courseName")%>"
            <%= course.equals(courseResultSet.getString("courseName")) ? "selected" : "" %>>
            <%=courseResultSet.getString("courseName")%></option>
          <%
          }
          %>
        </select>
      </div>

      <div class="form-group">
        <label for="permanentAddress">Permanent Address</label>
        <input type="text" class="form-control form-control-lg col-sm-5" id="permanentAddress" type="text"
          name="permanentAddress" id="permanentAddress" value="<%=permanentAddress%>"
          placeholder="Enter Permanent Address" required>
      </div>

      <div class="form-group">
        <label for="presentAddress">Present Address</label>
        <input type="text" class="form-control form-control-lg col-sm-5" id="presentAddress" type="text"
          name="presentAddress" id="presentAddress" value="<%=presentAddress%>" placeholder="Enter Present Address"
          required>
      </div>

      <div class="form-group">
        <label for="studentEmail">Student Email</label>
        <input type="text" class="form-control form-control-lg col-sm-5" id="studentEmail" type="text"
          name="studentEmail" id="studentEmail" value="<%=studentEmail%>" placeholder="Enter Student Email" required>
      </div>
      <%if(request.getParameter("action")==null){
        %>

      <div class="form-group">
        <label for="studentPassword"> Password</label>
        <input type="password" class="form-control form-control-lg col-sm-5" id="studentPassword" type="text"
          name="studentPassword" id="studentPassword" value="<%=studentPassword%>" placeholder="Enter Student Password"
          required>
      </div>
      <% } %>


      <button type="submit" class="btn btn-primary mb-2" value="Submit" name="submit"> Submit</button>
    </form>
  </div>

</body>
<style>
  .warning {
    background-color: #ffeeba;
    border: 1px solid #ffc107;
    color: #856404;
    padding: 1rem;
    margin-bottom: 1rem;
  }
</style>

</html>