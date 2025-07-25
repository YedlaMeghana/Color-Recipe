package servlets;

import database.DBConnection;
import java.sql.*;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.*;

public class EditDesginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String screenNumber = request.getParameter("screenNumber");
        String designReference = request.getParameter("designReference");
        try {
            Connection conn = DBConnection.getConnection();
String designQuery = "SELECT screen_number, design_reference, customer_buyer, color_count " +
                     "FROM Design WHERE design_reference = ? OR screen_number = ?";
PreparedStatement designStmt = conn.prepareStatement(designQuery);
designStmt.setString(1, designReference);
designStmt.setString(2, screenNumber);
ResultSet designRs = designStmt.executeQuery();

List<Map<String, String>> results = new ArrayList<>();

while (designRs.next()) {
    Map<String, String> row = new HashMap<>();
    String screenNum = designRs.getString("screen_number");
    row.put("screen_number", screenNum);
    row.put("design_reference", designRs.getString("design_reference"));
    row.put("customer_buyer", designRs.getString("customer_buyer"));
    int colorCount = designRs.getInt("color_count");

    // Fetch Technical Details
    String techQuery = "SELECT repeat_size, printing_route, width, height, separated_by " +
                       "FROM TechnicalDetails WHERE screen_number = ?";
    PreparedStatement techStmt = conn.prepareStatement(techQuery);
    techStmt.setString(1, screenNum);
    ResultSet techRs = techStmt.executeQuery();
    if (techRs.next()) {
        row.put("repeat_size", techRs.getString("repeat_size"));
        row.put("printing_route", techRs.getString("printing_route"));
        row.put("width", String.valueOf(techRs.getInt("width")));        
        row.put("height", techRs.getString("height"));
        row.put("separated_by", techRs.getString("separated_by"));
    }
    techRs.close();
    techStmt.close();

    // Fetch Color Details (Limited by color_count)
    String colorQuery = "SELECT color_name, color_code, mesh_size, coverage, screen_type " +
                        "FROM Color WHERE screen_number = ? LIMIT ?";
    PreparedStatement colorStmt = conn.prepareStatement(colorQuery);
    colorStmt.setString(1, screenNum);
    colorStmt.setInt(2, colorCount); 
    ResultSet colorRs = colorStmt.executeQuery();

    while (colorRs.next()) {
        Map<String, String> colorRow = new HashMap<>(row); // Clone base row for each color entry
        colorRow.put("color_name", colorRs.getString("color_name"));
        colorRow.put("color_code", colorRs.getString("color_code"));
        colorRow.put("mesh_size", colorRs.getString("mesh_size"));
        colorRow.put("coverage", colorRs.getString("coverage"));
        colorRow.put("screen_type", colorRs.getString("screen_type"));
        
        results.add(colorRow); // Add each color row as a separate entry
    }
    colorRs.close();
    colorStmt.close();
}

    designRs.close();
    designStmt.close();
    conn.close();
    HttpSession session = request.getSession();
    session.setAttribute("searchResults", results);
    response.sendRedirect("edit.jsp");
        }catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
        
    }


}
