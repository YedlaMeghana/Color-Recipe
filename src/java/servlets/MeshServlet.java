
package servlets;

import database.DBConnection;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.*;

public class MeshServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request , HttpServletResponse response)throws IOException , ServletException{
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(); 

        
        String newMesh = request.getParameter("newmeshsize");

        if (newMesh != null && !newMesh.trim().isEmpty()) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO mesh (meshSizes) VALUES (?)");
            pstmt.setString(1,newMesh);
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                    session.setAttribute("flashMessage", "Mesh size " + newMesh + " added successfully!");
                } else {
                    session.setAttribute("flashMessage", "Failed to add mesh size. Please try again.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashMessage", "Error occurred while adding mesh size.");
            }
        } else {
            session.setAttribute("flashMessage", "Mesh size cannot be empty.");
        }

        response.sendRedirect("addmesh.jsp"); 


    
    }

    
}
