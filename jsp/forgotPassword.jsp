
<%@ page import="dbConn.PasswordEncryptor"%>
<%@ page import="dbConn.DbManager"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ include file="header.jsp" %>

<%

PasswordEncryptor passwordEncryptor =new PasswordEncryptor();
DbManager dbmanager = new DbManager();
%>

<!DOCTYPE html>
<html>

<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>

<body style="height: 100%;">
    <div class="container my-4">
        <%

if(request.getParameter("resetPassword")!=null){
    String email = request.getParameter("email");
    String password = passwordEncryptor.encrypt(request.getParameter("password"));
    ResultSet existingMailResultSet = dbmanager.excuteGetQuery("SELECT * FROM Login WHERE userName='"+email+"'");
    if(existingMailResultSet.next()){
      String id = existingMailResultSet.getString("id");
      String query = "UPDATE Login SET password = ? WHERE userName = ?";
PreparedStatement stmt = dbmanager.getDbConnection().prepareStatement(query);
stmt.setString(1, password);
stmt.setString(2, email);
stmt.executeUpdate();
      response.sendRedirect("login.jsp"); 
    } else {
        %>
        <div class="warning">
            <p>Warning: Email Id doesn't exists...</p>
        </div>

        <%
    }
}
%>
        <div class="row justify-content-center mt-5">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h3 class="card-title text-center mb-4">Forgot Password</h3>
                        <form method="post">
                            <div class="form-group">
                                <label for="email">Email address</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="password">New Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="text-center">
                                <button type="submit" name="resetPassword" class="btn btn-primary">Reset
                                    Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

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
</head>

</html>