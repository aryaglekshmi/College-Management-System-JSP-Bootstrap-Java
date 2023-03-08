<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
  integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dbConn.StudentDbManager" %>
<%@ page import="dbConn.DbManager" %>
<%@ page import="dbConn.LoginController" %>
<%@ include file="header.jsp" %>


<%
StudentDbManager studentDbManager = new StudentDbManager();

DbManager dbmanager= new DbManager();

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 

String id=request.getParameter("id");
String name=request.getParameter("name");
String course=request.getParameter("course");
int noOfSemesters = 0;

if(request.getParameter("submit") != null){
  String subject1 = "", subject2="",subject3="";
  if(course.equals("BTech")){
   subject1 = "DigitalElectronics";
   subject2="AnalogElectronics";
   subject3="ComputerScience";
  } else if(course.equals("BSC")){
    subject1="Physics";
    subject2="English";
    subject3="Maths";
  } else if(course.equals("BA")){
    subject1="Malayalam";
    subject2="English";
    subject3="Psychology";
  } else if(course.equals("LLB")){
    subject1="IndustrialLaw";
    subject2="EnvironmentalLaw";
    subject3="LabourLaw";
  }
  String marksId = null;
  ResultSet existingResultset = DbManager.excuteGetQuery("SELECT marksId FROM " + course + "Marks WHERE studentRegNumber=" + id + " AND semester=" + request.getParameter("semester"));
  if(existingResultset.next()){
    marksId = existingResultset.getString("marksId");
    String query = "UPDATE " + course + "Marks SET " + subject1 +"="+request.getParameter(subject1) + "," + subject2 +"="+request.getParameter(subject2) + "," + subject3 +"="+request.getParameter(subject3) + " WHERE marksId=" + marksId;
    Statement marksTableStatement = DbManager.getDbConnection().createStatement();
    marksTableStatement.executeUpdate(query);   
  } else {
    String query = "INSERT INTO " + course + "Marks (studentRegNumber, name, semester, " + subject1 + ", " + subject2 + ", " + subject3 + ") VALUES (?, ?, ?, ?, ?, ?) " + "ON DUPLICATE KEY UPDATE " + subject1 + " = VALUES(" + subject1 + ")," + subject2 + " = VALUES(" + subject2 + ")," + subject3 + " = VALUES(" + subject3 + ")";
    PreparedStatement marksTableStatement = DbManager.getDbConnection().prepareStatement(query);
    marksTableStatement.setString(1, id);
    marksTableStatement.setString(2, name);
    marksTableStatement.setString(3, request.getParameter("semester"));
    marksTableStatement.setString(4, request.getParameter(subject1));
    marksTableStatement.setString(5, request.getParameter(subject2));
    marksTableStatement.setString(6, request.getParameter(subject3));
    marksTableStatement.executeUpdate();

  }
response.sendRedirect("studentMarksLists.jsp?id=" + id + "&name=" + name + "&course=" + course);
} else{
// Semester count
ResultSet courseResultSet = dbmanager.excuteGetQuery("SELECT * FROM Courses WHERE courseName='" + course + "'");
while(courseResultSet.next()){
    noOfSemesters = courseResultSet.getInt("noOfSemesters");
}
}


%>

<html>

<head>
  <title>Student Marks</title>
</head>

<body style="height: 100%;">
  <div class="container my-4">
    <h3 class="text-primary">Enter Student Marks</h3>
    <form method="post">


      <div class="form-group">
        <label for="name">Name: </label>
        <input type="text" class="form-control form-control-lg col-sm-5" id="name" type="text" name="name"
          value="<%=name%>" disabled>
      </div>

      <div class="form-group">
        <label for="course">Course: </label>
        <input type="text" class="form-control form-control-lg col-sm-5" value="<%=course%>" disabled>
        <input type="hidden" name="course" id="course" name="course" value="<%=course%>">
      </div>



      <div class="form-group">
        <label for="course">Semester: </label>
        <select class="form-control form-control-lg col-sm-5" id="semester" name="semester" id="semester">
          <option>Select Semester</option>
          <%
          for(int i=1;i<=noOfSemesters;i++){
            %>
          <option value="<%=i%>"> Semester <%=i%></option>
          <%
          }
          %>
        </select>
      </div>
      <%
      // Get subjects
      ResultSet subjectResultSet = dbmanager.excuteGetQuery("SELECT * FROM " + course+"Subjects");
      while(subjectResultSet.next()){
          String subject = subjectResultSet.getString("subjectName");
          %>
      <div class="form-group">
        <label for="course"><%=subject%> Marks</label>

        <input type="number" min="0" max="100" class="form-control form-control-lg col-sm-5"
          name="<%= subject.replaceAll("\\s+","") %>" placeholder="Enter <%=subject%> Marks" required>


      </div>
      <%
      }
      %>


      <button type="submit" class="btn btn-primary mb-2" value="Submit" name="submit"> Submit</button>
    </form>
  </div>

</body>

</html>