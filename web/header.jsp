<%@ page import="javax.servlet.http.*,javax.servlet.* , java.time.LocalDate , java.util.Locale , java.time.DayOfWeek" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <style>
            body {
    background-color: white;
    font-family: Arial, sans-serif;
    text-align: center;
    margin: 0;
    padding: 0;
}
            .header {
    height: auto;
    background-color: #000066;
    color: white;
    display: flex;
    justify-content: space-around;
    align-items: center;
    flex-wrap: wrap;
}

.navbar {  
    background-color: white;
    display: flex;
    padding-left: 17%;
    align-items: center;
    min-height: 35px;
    gap: 30px;
    border-bottom: 1px solid #ccc;
    position: relative;
}

.nav-item ,.dropdown a {
    position: relative;
    cursor: pointer;
    color: rgb(19, 19, 75);
    padding-left: 10px;;
    border-left: 1px solid gray;
    font-weight: bold;
    text-transform: uppercase;
}

.nav-item:hover,  .nav-item.active {
    color: red;
}

#nav-home a{
    text-decoration: none;
    color: #000066;
}

#nav-home a:hover{
    color: red;
}

.dropdown {
    display: none;
    position: absolute;
    background-color: white;
    padding: 10px;
    white-space: nowrap;
}

.dropdown a {
    display: inline-block;
    padding:2px 15px;
    text-decoration: none;
    
}

.dropdown a:hover {
    background-color: #f0f0f0;
}

.nav-item:hover .dropdown {
    display: block;
}

        </style>
    </head>
    <body>
        <div class="header">
                <h3>COLOR RECIPE - MANAGEMENT SYSTEM</h3>
                <h5>HELLO,  <% String username = (String) session.getAttribute("username"); 
                       LocalDate date = LocalDate.now();
                       DayOfWeek day = date.getDayOfWeek();
                    %>
                    <%= username.toUpperCase()%> [ <%= day %> , <%= date%> ]  
                </h5>
            </div>
            <div class="navbar">
                    <div class="nav-item" id="nav-home"><a href="home.jsp">HOME</a></div>
                    <div class="nav-item" id="nav-desgin">DESIGN
                        <div class="dropdown">
                            <a href="new.jsp">NEW</a>
                            <a href="edit.jsp">EDIT</a>
                            <a href="status.jsp">STATUS</a>
                        </div>
                    </div>
                    <div class="nav-item" id="nav-profile">PROFILE
                        <div class="dropdown">
                            <a href="adduser.jsp">ADD NEW USER</a>
                            <a href="changepassword.jsp">CHANGE PASSWORD</a>
                            <a href="index.html">LOGOUT</a>
                            
                        </div>
                    </div>
                    <div class="nav-item" id="nav-profile">SETTINGS
                        <div class="dropdown">
                            <a href="addmesh.jsp">ADD MESH SIZE</a>
                            <a href="addscreen.jsp">ADD SCREEN TYPE</a>
                        </div>
                    </div>
                </div>
            
    </body>
</html>
