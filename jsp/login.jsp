<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<%@ page import="dbConn.LoginController"%>
<%@ page import="dbConn.DbManager"%>
<%@ page import="java.util.*" %>

<%@ include file="header.jsp" %>


<%
    LoginController loginController = new LoginController();
    DbManager dbmanager = new DbManager();
    if(request.getParameter("login")!=null){
        HashMap<String,String> userInfo = LoginController.doLogin(request.getParameter("userName"),request.getParameter("password"));
        if(userInfo!=null){
            session.setAttribute("userName", request.getParameter("userName"));
            session.setAttribute("userType", userInfo.get("userType"));
            session.setAttribute("userId", userInfo.get("userId"));
            response.sendRedirect("home.jsp");
    

       } else {
%>
<div class="warning">
    <p>Warning: Username or Password you entered is incorrect. Please try again...</p>
</div>

<%
       }
    } else if(request.getParameter("forgotPassword")!=null){
        response.sendRedirect("forgotPassword.jsp");
    }
    %>

<html>

<title>Login</title>
<style>
    .warning {
        background-color: #ffeeba;
        border: 1px solid #ffc107;
        color: #856404;
        padding: 1rem;
        margin-bottom: 1rem;
    }
</style>

<body style="height: 100%;">
    <div class="container my-4 container-fluid h-custom">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-md-9 col-lg-6 col-xl-6 my-lg-5 py-lg-5">
                <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp"
                    class="img-fluid" alt="Sample image">
            </div>
            <div class="col-md-8 col-lg-6 col-xl-5 offset-xl-1 my-lg-5 py-lg-5">
                <form method="post">
                    <div class="form-group">
                        <label for="userName">Username:</label>
                        <input type="email" class="form-control" id="userName" name="userName" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="forgotPassword">Forgot Password</button>
                    <button type="submit" class="btn btn-primary" style="float: right;" name="login">Login</button>
                </form>
            </div>
        </div>
    </div>
</body>

</html>