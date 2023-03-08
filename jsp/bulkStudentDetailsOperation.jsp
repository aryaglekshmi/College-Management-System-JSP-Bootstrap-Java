<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">


<%@ page import="java.sql.*" %>
<%@ page import="dbConn.StudentDbManager" %>
<%@ page import="dbConn.DbManager" %>
<%@ page import="dbConn.LoginController" %>
<%@ include file="header.jsp" %>



<%
StudentDbManager studentDbManager = new StudentDbManager();

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 

String[] selectedStudentIds=request.getParameterValues("selectedStudentIds");
Statement statement = DbManager.getDbConnection().createStatement();

if(request.getParameter("bulkDelete")!=null){
    studentDbManager.bulkDeleteStudentData(selectedStudentIds);
} else if(request.getParameter("bulkUpdate")!=null && selectedStudentIds != null && selectedStudentIds.length>1){
    for(String id: selectedStudentIds){
        statement.addBatch("UPDATE Students SET name= '" + request.getParameter(id+"_name") + "', course='" + request.getParameter(id+"_course") +"', courseFee='" + request.getParameter(id+"_courseFee")+"', examFee='" + request.getParameter(id+"_examFee")+ "' WHERE studentRegNumber=" + id + ";");
        statement.addBatch("UPDATE Marks SET maths='" + request.getParameter(id+"_maths") +"',malayalam='" + request.getParameter(id+"_malayalam") +"',science='" + request.getParameter(id+"_science") +"' WHERE Marks.studentRegNumber=" + id + ";");
        statement.addBatch("UPDATE StudentAddress SET presentAddress='" + request.getParameter(id+"_presentAddress") +"',permanentAddress='" + request.getParameter(id+"_permanentAddress") +"' WHERE studentRegNumber=" + id + ";");

    }
    statement.executeBatch();
    response.sendRedirect("studentLists.jsp");
}
%>

<html>

<body style="height: 100%;">
    <div class="container my-4">
        <h2 class="my-2">Student Lists</h2>
        <form method="post">
            <table class="table table-striped table-hover">
                <thead class="thead-dark">
                    <tr>
                        <th>Id</th>
                        <th>Name</th>
                        <th>Course</th>
                        <th>Present Address</th>
                        <th>Permanent Address</th>
                        <th>Maths</th>
                        <th>Malayalam</th>
                        <th>Science</th>
                        <th>Course Fee</th>
                        <th>Exam Fee</th>
                        <th colspan="2"></th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        try {
                            String selectQuery = "SELECT * FROM Students";
                            ResultSet resultSet = statement.executeQuery(selectQuery);
                            
                            while(resultSet.next()) {
                                String studentRegNumber = resultSet.getString("studentRegNumber");
                                String name = resultSet.getString("name");
                                String course = resultSet.getString("course");
                                String courseFee = resultSet.getString("courseFee");
                                String examFee = resultSet.getString("examFee");
                            
                    %>
                    <tr>
                        <td><%=studentRegNumber %></td>
                        <td><input class="form-control" type="text" value="<%=name%>" name="<%=studentRegNumber%>_name"> </td>
                        <td>
                            <select class="form-control form-control-lg col-sm-5" id="course"
                                name="<%=studentRegNumber%>_course" value="<%=course%>" id="course">
                                <option>Select course</option>
                                <option value="Btech" <%= course.equals("btech") ? "selected" : "" %>>Btech</option>
                                <option value="bsc" <%= course.equals("bsc") ? "selected" : "" %>>BSC</option>
                                <option value="ba" <%= course.equals("ba") ? "selected" : "" %>>BA</option>
                            </select>
                        </td>


                        <%
                                    ResultSet addressResultSet = DbManager.getDbConnection().createStatement().executeQuery("SELECT * FROM StudentAddress WHERE StudentAddress.studentRegNumber=" + studentRegNumber);
                                    while(addressResultSet.next()){
                                        String presentAddress = addressResultSet.getString("presentAddress");
                                        String permanentAddress = addressResultSet.getString("permanentAddress");
                                    %>
                        <td><input class="form-control" type="text" value="<%=presentAddress%>"
                                name="<%=studentRegNumber%>_presentAddress"> </td>
                        <td><input class="form-control" type="text" value="<%=permanentAddress%>"
                                name="<%=studentRegNumber%>_permanentAddress"> </td>
                        <%
                                        }
                                        addressResultSet.close();
                                    %>
                                    <%
                                    ResultSet marksResultSet = DbManager.getDbConnection().createStatement().executeQuery("SELECT * FROM Marks WHERE Marks.studentRegNumber=" + studentRegNumber);
                                    while(marksResultSet.next()){
                                        String maths = marksResultSet.getString("maths");
                                        String malayalam = marksResultSet.getString("malayalam");
                                        String science = marksResultSet.getString("science");

                                    %>
                                    <td><input class="form-control" type="text" value="<%=maths%>"
                                        name="<%=studentRegNumber%>_maths"> </td>
                                        <td><input class="form-control" type="text" value="<%=malayalam%>"
                                            name="<%=studentRegNumber%>_malayalam"> </td>
                                            <td><input class="form-control" type="text" value="<%=science%>"
                                                name="<%=studentRegNumber%>_science"> </td>
                                                <%
                                            }
                                            marksResultSet.close();
                                        %>
                        <td><input class="form-control" type="text" value="<%=courseFee%>"
                                name="<%=studentRegNumber%>_courseFee"> </td>
                        <td><input class="form-control" type="text" value="<%=examFee%>" name="<%=studentRegNumber%>_examFee">
                        </td>
                        <td><input class="form-control" type="checkbox" name="selectedStudentIds"
                                value="<%=studentRegNumber%>">
                        </td>

                    </tr>
                    <%
                            }
                            resultSet.close();  // move the closing of the resultSet outside of the while loop
                        } catch (Exception e) {
                    %>
                    <h4><%=e%></h4>
                    <%}%>
                </tbody>
                
                    
        </table>
        <button type="submit" class="btn btn-primary mb-2" value="Bulk Update" name="bulkUpdate"> Bulk Update</button>
        <button type="submit" class="btn btn-primary mb-2" value="Bulk Delete" name="bulkDelete"> Bulk Delete</button>
    
        </form>
       
    </div>
    </body>
</html>