<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@ page import="dbConn.StudentDbManager" %>
<%@ page import="dbConn.DbManager" %>

<%@ page import="dbConn.ParentDbManager" %>
<%@ include file="header.jsp" %>



<%

StudentDbManager studentDbManager = new StudentDbManager();
DbManager dbmanager= new DbManager();

ParentDbManager parentDbManager = new ParentDbManager();

String name=" ";
String contactNumber=" ";
String email="";
String contact="";
List<String> students = new ArrayList<String>();
String selectedParentId=request.getParameter("id");


if (session.getAttribute("userName") == null) {
	response.sendRedirect("notAuthenticated.jsp");
} 

if(selectedParentId != null){
    ResultSet parentResultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM Parents WHERE Parents.parentId="+ selectedParentId);
    while(parentResultSet.next()){
        name=parentResultSet.getString("name");
        contact=parentResultSet.getString("contactNumber");
        email=parentResultSet.getString("email");
    }
    
    ResultSet studentResultSet = dbmanager.getDbConnection().createStatement().executeQuery("SELECT * FROM ParentStudents INNER JOIN Students ON ParentStudents.studentRegNumber = Students.studentRegNumber WHERE ParentStudents.parentId="+ selectedParentId);
    while(studentResultSet.next()){
        students.add(studentResultSet.getString("studentRegNumber"));
    }
    System.out.println(students);
}

// Submit form
if(request.getParameter("submit")!=null){
    String[] childrenRegNumbers = request.getParameterValues("childrenRegNumbers");
    if(!parentDbManager.checkIfAnyRegNumberNotExistsInList(childrenRegNumbers)){
    if(selectedParentId!=null){
        parentDbManager.updateParentData(selectedParentId,request.getParameter("name"),request.getParameter("email"),request.getParameter("password"),request.getParameter("contact"), childrenRegNumbers);
    }else {
  parentDbManager.saveParentData(request.getParameter("name"),request.getParameter("email"),request.getParameter("password"),request.getParameter("contact"), childrenRegNumbers);
   }
  response.sendRedirect("parentLists.jsp");
}else {
        %>
<div class="warning">
    <p>Warning: Enter Student valid Registration Number...</p>
</div>

<%
    }
}

%>



<!DOCTYPE html>
<html>

<head>
    <title>Parent Information</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
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

<body style="height: 100%;">
    <!-- <h2 class="my-2"><%=parentDbManager.students%></h2> -->
    <div class="container my-4" style="width: 50%;">
        <h2 class="my-2">Parent Information</h2>
        <form method="post" id="form">
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" class="form-control" id="name" name="name" placeholder="Enter your name"
                    value="<%=name%>" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email"
                    value="<%=email%>" required>
            </div>
            <% if(selectedParentId==null){  %>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password"
                    placeholder="Enter your Password" required>
            </div>
            <%
        }
            %>

            <div class="form-group">
                <label for="contact">Contact Number</label>
                <input type="tel" class="form-control" id="contact" name="contact" value="<%=contact%>"
                    placeholder="Enter your contact number" required>
            </div>
            <div class="form-group" id="child-regNumbers">
                <label for="child-regNumber-1">Children's Registration Number</label>
                <%
            if(selectedParentId==null){
            %>
                <div class="child-regNumber-inputs">
                    <input type="number" class="form-control" id="child-regNumber-1" name="childrenRegNumbers"
                        placeholder="Enter your Child's Registration Number" required>
                </div>

                <% 
        } else {
            for(String student: students){
            %>
                <div class="child-regNumber-inputs">
                    <input type="number" class="form-control" id="child-regNumber-1" name="childrenRegNumbers"
                        placeholder="Enter your Child's Registration Number" value="<%=student%>" required>
                </div>

                <%
        }
        }
        %>
            </div>

            <button type="button" class="btn btn-primary" id="add-child-regNumber">Add Child's Registration Number</button>
            <button type="button" class="btn btn-danger" id="remove-child-regNumber">Remove Child's Registration Number</button>
            <button type="submit" class="btn btn-success" name="submit">Submit</button>
        </form>

    </div>

    <script>
                var numChildRegNumbers = document.getElementsByName("childrenRegNumbers").length;
        document.getElementById("add-child-regNumber").addEventListener("click", function () {
            let div = document.createElement('div');
            div.setAttribute('class', 'child-regNumber-inputs');
            div.innerHTML =
                `<input type="number" class="form-control" id="child-regNumber-${numChildRegNumbers}" name="childrenRegNumbers" placeholder="Enter your child's name" required>`;
            let parentElement = document.getElementById('child-regNumbers');
            parentElement.appendChild(div);
            numChildRegNumbers++;
        });

        document.getElementById("remove-child-regNumber").addEventListener("click", function () {debugger
            var childRegNumbers = document.getElementsByName("childrenRegNumbers");
            if (numChildRegNumbers > 1) {
                childRegNumbers[childRegNumbers.length - 1].remove()
                numChildRegNumbers--;
            }
        });
    </script>
</body>
<style>
    .child-regNumber-inputs {
        padding-bottom: 10px;
    }
</style>

</html>