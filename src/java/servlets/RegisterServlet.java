package servlets;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;

import javax.servlet.http.*;

public class RegisterServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String useridStr = request.getParameter("userid");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmpassword = request.getParameter("confirmpassword");

        boolean hasError = false;
        request.setAttribute("username", username);
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username is required");
            hasError = true;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required");
             hasError = true;
        } else if (password.length() < 8) {
            request.setAttribute("passwordError", "Password must be at least 8 characters");
            hasError = true;
        } else if (!password.matches(".*[A-Z].*")) {
            request.setAttribute("passwordError", "Password must contain at least one uppercase letter");
            hasError = true;
        } else if (!password.matches(".*[a-z].*")) {
            request.setAttribute("passwordError", "Password must contain at least one lowercase letter");
            hasError = true;
        } else if (!password.matches(".*\\d.*")) {
            request.setAttribute("passwordError", "Password must contain at least one number");
            hasError = true;
        } else if (!password.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            request.setAttribute("passwordError", "Password must contain at least one special character");
            hasError = true;
        }
        if (confirmpassword == null || confirmpassword.trim().isEmpty()) {
            request.setAttribute("confirmpasswordError", "Confirm Password is required");
            hasError = true;
        } else if (!password.equals(confirmpassword)) {
            request.setAttribute("confirmpasswordError", "Passwords do not match");
            hasError = true;
        }
        if (hasError) {
            request.setAttribute("passwordValue", password);
            request.setAttribute("confirmPasswordValue", confirmpassword);
            RequestDispatcher rd = request.getRequestDispatcher("adduser.jsp");
            rd.forward(request, response);
            return;
        }
        if (hasError) {
            RequestDispatcher rd = request.getRequestDispatcher("adduser.jsp");
            rd.forward(request, response);
            return;
        }
        try {
            int userid = Integer.parseInt(useridStr);
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO users(userid, username, password) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userid);
            stmt.setString(2, username);
            stmt.setString(3, password);

            int rows = stmt.executeUpdate();
            conn.close();

            if (rows > 0) {
                response.sendRedirect("index.html");
            } else {
                request.setAttribute("usernameError", "Registration failed. Try again.");
                RequestDispatcher rd = request.getRequestDispatcher("adduser.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("usernameError", "Error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("adduser.jsp");
            rd.forward(request, response);
        }
    }
}
