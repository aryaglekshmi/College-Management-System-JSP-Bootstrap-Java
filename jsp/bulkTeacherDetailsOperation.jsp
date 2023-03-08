<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">


<%@ page import="java.sql.*" %>
<%@ page import="dbConn.TeacherDbManager" %>
<%@ page import="dbConn.DbManager" %>
<%@ page import="dbConn.LoginController" %>
<%@ include file="header.jsp" %>


<%
TeacherDbManager teacherDbManager = new TeacherDbManager();


if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 


String[] selectedTeacherIds=request.getParameterValues("selectedTeacherIds");
Statement statement = DbManager.getDbConnection().createStatement();

if(request.getParameter("bulkDelete")!=null){
    teacherDbManager.bulkDeleteTeacherData(selectedTeacherIds);
} else if(request.getParameter("bulkUpdate")!=null && selectedTeacherIds != null && selectedTeacherIds.length>1){
    for(String id: selectedTeacherIds){
        String sqlQuery = "UPDATE Teachers SET name= '" + request.getParameter(id+"_name") + "', course='" + request.getParameter(id+"_course") +"', courseFee='" + request.getParameter(id+"_courseFee")+"', examFee='" + request.getParameter(id+"_examFee")+ "' WHERE teacherId=" + id + ";";
        statement.addBatch(sqlQuery);
    }
    statement.executeBatch();
    response.sendRedirect("teacherLists.jsp");
}
%>

<html>

<body style="height: 100%;">
    <div class="container my-4">
        <h2 class="my-2">Teacher Lists</h2>
        <form method="post">
            <table class="table table-striped table-hover">
                <thead class="thead-dark">
                    <tr>
                        <th>Id</th>
                        <th>Name</th>
                        <th>Course</th>
                        <th>Course Fee</th>
                        <th>Exam Fee</th>
                        <th colspan="2"></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                try{
                String selectQuery = "SELECT * FROM Teachers";
                ResultSet resultSet = statement.executeQuery(selectQuery);
                while(resultSet.next()){
                    String teacherId = resultSet.getString("teacherId");
                    String name = resultSet.getString("name");
                    String course = resultSet.getString("course");
                    String courseFee = resultSet.getString("courseFee");
                    String examFee = resultSet.getString("examFee");
                %>
                    <tr>
                        <td><%=teacherId %></td>
                        <td><input class="form-control" type="text" value="<%=name%>" name="<%=teacherId%>_name"> </td>
                        <td>
                            <select class="form-control form-control-lg col-sm-5" id="course" name="<%=teacherId%>_course"
                            value="<%=course%>" id="course">
                            <option>Select course</option>
                              <option value="Btech" <%= course.equals("btech") ? "selected" : "" %>>Btech</option>
                              <option value="bsc" <%= course.equals("bsc") ? "selected" : "" %>>BSC</option>
                              <option value="ba" <%= course.equals("ba") ? "selected" : "" %>>BA</option>
                            </select>
                        </td>
                        <td><input class="form-control" type="text" value="<%=courseFee%>" name="<%=teacherId%>_courseFee"> </td>
                        <td><input class="form-control" type="text" value="<%=examFee%>" name="<%=teacherId%>_examFee"> </td>
                        <td><input class="form-control" type="checkbox" name="selectedTeacherIds"
                                value="<%=teacherId%>">
                        </td>

                    </tr>
                    <%    
            }
            }catch (Exception e) {
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