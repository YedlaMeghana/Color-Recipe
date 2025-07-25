
package servlets;

import database.DBConnection;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ScreenTypeServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request , HttpServletResponse response)throws IOException , ServletException{
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String newScreen = request.getParameter("newscreentype");

        if (newScreen != null && !newScreen.trim().isEmpty()) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO screenTypes (screenType) VALUES (?)");
            pstmt.setString(1,newScreen);
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                out.println("<p style='color:green;'>Mesh size <b>" + newScreen + "</b> added successfully!</p>");
            } else {
                out.println("<p style='color:red;'>Failed to add mesh size. Please try again.</p>");
            }

            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    }


    
    }

    
}
