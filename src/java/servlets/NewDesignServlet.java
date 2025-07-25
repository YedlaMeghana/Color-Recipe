package servlets;

import database.DBConnection;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.text.SimpleDateFormat; 
import java.util.Date; 


@MultipartConfig 
public class NewDesignServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request , HttpServletResponse response)throws IOException , ServletException{
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        InputStream fileContent = null;
        try {
        Connection conn = DBConnection.getConnection();
        Part filePart = request.getPart("designSample"); 
            if (filePart != null && filePart.getSize() > 0) {
                fileContent = filePart.getInputStream();
            }
        String designSql = "INSERT INTO Design (design_type, screen_number, design_reference, combo_number, customer_buyer, received_date, base_color , color_count, design_sample) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement designStmt = conn.prepareStatement(designSql, Statement.RETURN_GENERATED_KEYS);
        designStmt.setString(1, request.getParameter("designType"));
//        designStmt.setInt(2, Integer.parseInt(request.getParameter("screenNumber")));
        String screenNumberStr = request.getParameter("screenNumber");
        if (screenNumberStr == null || screenNumberStr.isEmpty()) {
            out.println("Error: screenNumber is required.");
            return;
        }
        designStmt.setInt(2, Integer.parseInt(screenNumberStr));

        designStmt.setString(3, request.getParameter("designReference"));
        designStmt.setString(4, request.getParameter("comboNumber"));
        designStmt.setString(5, request.getParameter("customerBuyer"));
        
        String receivedDateStr = request.getParameter("receivedDate");
        if (receivedDateStr == null || receivedDateStr.isEmpty()) {
            out.println("Error: receivedDate parameter is missing or empty.");
        } else {
    try {
        // Correct format that matches HTML5 input type="date"
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        format.setLenient(false); // Optional: strict date validation
        Date parsedDate = format.parse(receivedDateStr);
        java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());
        designStmt.setDate(6, sqlDate);
    } catch (Exception e) {
        out.println("Error: Invalid date format. Expected format is 'yyyy-MM-dd'.");
        return;
    }
        }
        designStmt.setString(7, request.getParameter("baseColor"));
        designStmt.setString(8, request.getParameter("colorCount"));
        if (fileContent != null) {
                designStmt.setBlob(9, fileContent);
            } else {
                designStmt.setNull(9, java.sql.Types.BLOB);
            }
        designStmt.executeUpdate();
        ResultSet rs = designStmt.getGeneratedKeys();
        int designId = 0;
        if (rs.next()) {
            designId = rs.getInt(1);
        }
        

        int colorCount = Integer.parseInt(request.getParameter("colorCount"));
        
        String totalColorStr = request.getParameter("totalColors");
    if (totalColorStr != null && !totalColorStr.isEmpty()) {
    int totalColors = Integer.parseInt(totalColorStr);
    
    
    String colorSql = "INSERT INTO ColorList (design_id,  color_name, color_code, mesh_size, coverage, screen_type) VALUES (?, ?, ?, ?, ?, ?)";
    PreparedStatement colorStmt = conn.prepareStatement(colorSql);
 System.out.println("colorStmt "+colorStmt);
 System.out.println("totalColors "+totalColors);
    for (int i = 0; i < totalColors; i++) {
        String name = request.getParameter("colorName" + i);
        String code = request.getParameter("colorCode" + i);
        String mesh = request.getParameter("meshSize" + i);
        String coverage = request.getParameter("colorCoverage" + i);
        String screen = request.getParameter("screenType" + i);
        if (mesh == null || screen == null) {
        System.out.println("Received null values! Check form submission.");
    } else {
        System.out.println("Mesh Size: " + mesh);
        System.out.println("Screen Type: " + screen);
    }
//        System.out.println("Row " + i + ": " + name + ", " + code + ", " + mesh + ", " + coverage + ", " + screen);
//        colorStmt.setInt(1, designId);
//        colorStmt.setString(2, name);
//        colorStmt.setString(3, code);
//        colorStmt.setString(4, mesh);
//        colorStmt.setString(5, coverage);
//        colorStmt.setString(6, screen);
//        colorStmt.addBatch();

if (mesh != null && !mesh.isEmpty() && screen != null && !screen.isEmpty()) {
    colorStmt.setInt(1, designId);
    colorStmt.setString(2, name);
    colorStmt.setString(3, code);
    colorStmt.setString(4, mesh);
    colorStmt.setString(5, coverage);
    colorStmt.setString(6, screen);
    colorStmt.addBatch();
} else {
    System.out.println("Skipping row due to NULL values.");
}
    }

    colorStmt.executeBatch();
    colorStmt.close();
}


        String techSql = "INSERT INTO TechnicalDetails (design_id, repeat_size, repeat_size1, printing_route , width_mm , height_mm, separated_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement techStmt = conn.prepareStatement(techSql);
        techStmt.setInt(1, designId);
        techStmt.setString(2, request.getParameter("repeatSize"));
        techStmt.setString(3, request.getParameter("repeatSize1"));
        techStmt.setString(4, request.getParameter("printingRoute"));
        String widthStr = request.getParameter("width");
        if (widthStr == null || widthStr.isEmpty()) {
            out.println("Error: width is required.");
            return;
        }
        double width = Double.parseDouble(widthStr);
        techStmt.setDouble(5,width);
        String heightStr = request.getParameter("height");
        if (heightStr == null || heightStr.isEmpty()) {
            out.println("Error: height is required.");
            return;
        }
        techStmt.setDouble(6, Double.parseDouble(heightStr));

        techStmt.setString(7, request.getParameter("separatedBy"));
        techStmt.executeUpdate();

        out.println("Data inserted successfully!");
        
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
        
    }
    
}