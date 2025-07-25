<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="database.DBConnection ,java.util.* , java.sql.* , java.io.* "%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
</head>
<body>
<%
    session = request.getSession(false);
    String username = null;

    if (session != null) {
        username = (String) session.getAttribute("username");
    }

    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String oldpassword = request.getParameter("oldPassword");
    String newpassword = request.getParameter("newPassword");
    String confirmpassword = request.getParameter("confirmPassword");

    if (oldpassword != null && newpassword != null && confirmpassword != null) {
        if (newpassword.equals(confirmpassword)) {
            try {
                Connection conn = DBConnection.getConnection();
                String checkSql = "SELECT password FROM users WHERE username=?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    String actualOldPassword = rs.getString("password");

                    if (actualOldPassword.equals(oldpassword)) {
                        String updateSql = "UPDATE users SET password=? WHERE username=?";
                        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                        updateStmt.setString(1, newpassword);
                        updateStmt.setString(2, username);

                        int rows = updateStmt.executeUpdate();
                        if (rows > 0) {
                            out.println("<p style='color:green;'>Password changed successfully!</p>");
                        } else {
                            out.println("<p style='color:red;'>Error: Password not updated.</p>");
                        }
                    } else {
                        out.println("<p style='color:red;'>Old password is incorrect.</p>");
                    }
                } else {
                    out.println("<p style='color:red;'>User not found in database.</p>");
                }

                rs.close();
                checkStmt.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>Exception occurred: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p style='color:red;'>New passwords do not match.</p>");
        }
    } else {
        out.println("<p style='color:red;'>Please fill all the fields.</p>");
    }
%>
</body>
</html>
