<%@ page import="javax.servlet.http.*,javax.servlet.* , java.time.LocalDate , java.util.Locale , java.time.DayOfWeek" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link rel="stylesheet" href="css/changepassword.css">
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="body">
        <h3 class="h3">CHANGE PASSWORD</h3>
            <form action="change.jsp" method="post">
                <table class="container">
                    <tr>
                        <td><label for="oldPassword">Old Password</label></td>
                        <td><input type="password" name="oldPassword" id="oldPassword"></td>
                    </tr>
                    <tr>
                        <td><label for="newPassword">New Password</label></td>
                        <td><input type="password" name="newPassword" id="newPassword"></td>
                    </tr>
                    <tr>
                        <td><label for="confirmPassword">Confirm Password</label></td>
                        <td><input type="password" name="confirmPassword" id="confirmPassword"></td>
                    </tr>
                    <tr>
                        <td><button class="btn">Save</button></td>
                    </tr>
                </table>
            </form>
    </div>
</body>
</html>