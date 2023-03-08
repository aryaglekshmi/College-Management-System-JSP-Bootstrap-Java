<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<%@ include file="header.jsp" %>




<%

if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
}  else {
%>

<html>

<head>
    <title>GG College</title>
</head>

<body style="height: 100%;">
    <div class="pricing-header px-3 py-3 pt-md-5 pb-md-4 mx-auto text-center">
        <h2 class="my-2" class="font-weight-bold text-center text-uppercase" style="color: #0d529b;">
          Your Career Starts With Us..
        </h2>
      </div>
      
    <div class="container my-4" style="width: 50%;">
        <div class="card-deck mb-3 text-center">
            <div class="card mb-4 box-shadow">
                <div class="card-header">
                    <h4 class="my-0 font-weight-normal">Students</h4>
                </div>
                <div class="card-body">
                    <% if(!session.getAttribute("userType").equals("Student")) { %>
                    <a href="studentLists.jsp" class="btn btn-lg btn-block btn-outline-primary">Student Lists</a>
                    <% if(session.getAttribute("userType").equals("Admin") || session.getAttribute("userType").equals("Teacher")) { %>
                    <a href="studentForm.jsp" class="btn btn-lg btn-block btn-outline-primary">Add Student</a>
                    <%  } } else { %>
                    <a href="studentLists.jsp" class="btn btn-lg btn-block btn-outline-primary">My Details</a>
                    <% } %>
                    <!-- <a class="btn btn-lg btn-block btn-outline-primary">Delete Student</a> -->
                    <!-- <a href="bulkStudentDetailsOperation.jsp" class="btn btn-lg btn-block btn-outline-primary">Bulk Update/Delete</a> -->
                </div>
            </div>
            <%if(session.getAttribute("userType").equals("Admin") || session.getAttribute("userType").equals("Teacher")){ %>
            <div class="card mb-4 box-shadow">
                <div class="card-header">
                    <h4 class="my-0 font-weight-normal">Teachers</h4>
                </div>
                <div class="card-body">
                    <% if(session.getAttribute("userType").equals("Admin")){%>
                    <a href="teachersLists.jsp" class="btn btn-lg btn-block btn-outline-primary">Teachers Lists</a>
                    <a href="teachersForm.jsp" class="btn btn-lg btn-block btn-outline-primary">Add Teacher</a>
                    <% } else if(session.getAttribute("userType").equals("Teacher")){%>
                    <a href="teachersLists.jsp" class="btn btn-lg btn-block btn-outline-primary">My Details</a>
                    <% } %>
                    <!-- <a class="btn btn-lg btn-block btn-outline-primary">Delete Teacher</a> 
                    <button class="btn btn-lg btn-block btn-outline-primary">Bulk Update/Delete</button>  -->
                </div>
            </div>
            <% } %>


        </div>
        <!-- <div class="card-deck mb-3 text-center">
            <div class="card mb-4 box-shadow">
                <div class="card-header">
                    <h4 class="my-0 font-weight-normal">Students</h4>
                </div>
                <div class="card-body">
                    <a href="studentLists.jsp" class="btn btn-lg btn-block btn-outline-primary">Student Lists</a>
                </div>
            </div>
        </div> -->

        <div class="card-deck mb-3 text-center">
            <div class="card mb-4 box-shadow">
                <div class="card-header">
                    <h4 class="my-0 font-weight-normal">Parents</h4>
                </div>
                <div class="card-body">
                    <% if(session.getAttribute("userType").equals("Admin") || session.getAttribute("userType").equals("Teacher") || session.getAttribute("userType").equals("Student")){ %>
                    <a href="parentLists.jsp" class="btn btn-lg btn-block btn-outline-primary">Parent Lists</a>
                    <% }  if(session.getAttribute("userType").equals("Admin")){%>
                    <a href="parentForm.jsp" class="btn btn-lg btn-block btn-outline-primary">Add Parent </a>
                    <% }  if(session.getAttribute("userType").equals("Parent")){%>
                    <a href="parentLists.jsp" class="btn btn-lg btn-block btn-outline-primary">My Details</a>
                    <% } %>
                </div>
            </div>
        </div>

    </div>
</body>

</html>
<%
}
%>