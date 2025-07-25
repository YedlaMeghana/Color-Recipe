<%@ page import="javax.servlet.http.*,javax.servlet.* , java.time.LocalDate , java.util.Locale , java.time.DayOfWeek" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page session="true" %>
<%
    HttpSession session1 = request.getSession(false);
    String username = (session1 != null) ? (String) session1.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COLOR RECIPE - MANAGEMENT SYSTEM</title>
    <link rel="stylesheet" href="css/home.css">
</head>
<body>
    
        <jsp:include page="header.jsp"/>
            <div class="container">
                <div class="home-logo">
                    <img src="images/home-logo.jpg" width="550px" height="150px" alt="COLOR RECIPE-LOGO"/>
                </div>
                <p class="head">color recipe</p>
            </div>
        <jsp:include page="footer.jsp"/>
</body>
</html>