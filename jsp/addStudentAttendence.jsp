<%@ page import="dbConn.DbManager" %>
<%@ page import="dbConn.StudentDbManager" %>
<%@ page import="dbConn.LoginController" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="header.jsp" %>


<%
DbManager dbmanager = new DbManager();

StudentDbManager studentDbManager = new StudentDbManager();
Connection connection =dbmanager.getDbConnection();

String studentRegNumber = request.getParameter("id");
String name = request.getParameter("name");
String course = "";
int noOfSemesters = 0;

//if (session.getAttribute("userName") == null) {
//	response.sendRedirect("notAuthenticated.jsp");
//} 


if(studentRegNumber!=null && request.getParameter("addAttendence")!=null){
try{
studentDbManager.checkStudentAttendanceReport(studentRegNumber,request.getParameter("course"),request.getParameter("semester"),request.getParameter("date"),request.getParameter("status"));
// Add Present/Absent attendance table data 
String insertQuery = "INSERT INTO Arya_DB."+ request.getParameter("status") +"Report (studentRegNumber, semester,course, date) VALUES (?, ?, ?, ?) ";
PreparedStatement statement = connection.prepareStatement(insertQuery);
statement.setString(1, studentRegNumber);
statement.setString(2, request.getParameter("semester"));
statement.setString(3, request.getParameter("course"));
statement.setString(4, request.getParameter("date"));
statement.executeUpdate();

//Add total attendance table data
studentDbManager.addAttendanceReport(studentRegNumber,request.getParameter("course"),request.getParameter("semester"),request.getParameter("date"),request.getParameter("status"));

response.sendRedirect("studentAttendanceReport.jsp?id="+studentRegNumber+"&name="+name);


}catch (Exception e) {
    %>
<h4><%=e%></h4>
<%
}
} else {
ResultSet courseResultSet = dbmanager.excuteGetQuery("SELECT course from Students WHERE Students.studentRegNumber ="+studentRegNumber);
while(courseResultSet.next()){
    course = courseResultSet.getString("course");
     ResultSet semestersResultSet = dbmanager.excuteGetQuery("SELECT * FROM Courses WHERE courseName='" + course + "'");
while(semestersResultSet.next()){
    noOfSemesters = semestersResultSet.getInt("noOfSemesters");
}

}


}
%>


<!DOCTYPE html>

<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

</head>

<body style="height: 100%;">
    <div class="container my-4" style="width: 50%;">
        <h2 class="my-2">Attendance Report - <%= name %></h2>
        <form method="post">
            <div class="form-group">
                <label for="date">Date:</label>
                <input type="date" class="form-control" id="date" name="date" min="<%=java.time.LocalDate.now()%>"
                    required>
            </div>

            <div class="form-group">
                <label for="course">Course:</label>
                <input type="text" class="form-control" value="<%=course%>" disabled>
                <input type="hidden" name="course" id="course" name="course" value="<%=course%>">
            </div>


            <div class="form-group">
                <label for="semester">Select Semester</label>
                <select class="form-control form-control-lg" id="semester" name="semester" id="semester">
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
            <div class="form-group">
                <label for="status">Status:</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="">Select status</option>
                    <option value="Present">Present</option>
                    <!-- <option value="FirstHalf">First Half</option>
                    <option value="SecondHalf">Second Half</option>  -->
                    <option value="Absent">Absent</option>
                </select>
            </div>
            <button type="submit" name="addAttendence" class="btn btn-primary">Add Attendance</button>
        </form>
    </div>
</body>

</html>