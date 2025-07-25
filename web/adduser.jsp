<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, database.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="css/adduser.css">
        <style>
            .error {
                color: red;
                font-size: 13px;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>
        <% 
            int nextuserid = 1000;
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "SELECT MAX(userid) AS max_id FROM users";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    nextuserid = rs.getInt("max_id") + 1;
                }
            } catch(Exception e) {
                e.printStackTrace();
            }
            
            String username = (String) request.getAttribute("username");
            String usernameError = (String) request.getAttribute("usernameError");
            String passwordError = (String) request.getAttribute("passwordError");
            String confirmpasswordError = (String) request.getAttribute("confirmpasswordError");
        %>

        <jsp:include page="header.jsp"/>

        <div class="container">
            <form action="register" method="post">
                <table class="register-table">
                    <tr class="table-head"><th colspan="2">Register</th></tr>

                    <tr>
                        <td class="label">User Id:</td>
                        <td><input type="number" name="userid" value="<%=nextuserid%>" readonly></td> 
                    </tr>

                    <tr>
                        <td class="label">Username:</td>
                        <td>
                            <input type="text" name="username" value="<%= username != null ? username : "" %>">
                            <span class="error"><%= usernameError != null ? "*" + usernameError : "" %></span>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">Password:</td>
                        <td>
                           <input type="password" name="password" value="<%= request.getAttribute("passwordValue") != null ? request.getAttribute("passwordValue") : "" %>">
                           <span class="error"><%= request.getAttribute("passwordError") != null ? "*" + request.getAttribute("passwordError") : "" %></span>

                        </td>
                    </tr>

                    <tr>
                        <td class="label">Confirm Password:</td>
                        <td>
                            <input type="password" name="confirmpassword" value="<%= request.getAttribute("confirmPasswordValue") != null ? request.getAttribute("confirmPasswordValue") : "" %>">
                            <span class="error"><%= request.getAttribute("confirmpasswordError") != null ? "*" + request.getAttribute("confirmpasswordError") : "" %></span>

                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="right"><button type="submit">Submit</button></td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
