package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import database.DBConnection;
import java.util.*;
import java.sql.Date;

public class UpdateDesignServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");

        try {
            String designIdParam = request.getParameter("designId");
            System.out.println("PARAM designId = " + request.getParameter("designId"));
            if (designIdParam == null || designIdParam.trim().isEmpty()) {
//                response.getWriter().println("Error: No design ID provided!");
//                return;
            System.out.println("PARAM designId = " + request.getParameter("designId"));
            }
            int designId = Integer.parseInt(designIdParam);
            String designReference = request.getParameter("designReference");
            String comboNumber = request.getParameter("comboNumber");
            String customerBuyer = request.getParameter("customer-buyer");
            String receivedDate = request.getParameter("receivedDate");
            String baseColor = request.getParameter("baseColor");
            String colorCountParam = request.getParameter("colorCount");
            System.out.println("PARAM colorcount = " + request.getParameter("colorCount"));
            if (colorCountParam == null || colorCountParam.trim().isEmpty()) {
                response.getWriter().println("Error: No color count provided!");
                return;
            }
            int screenNumber = 0;
            Connection conn1 = DBConnection.getConnection(); 
try (PreparedStatement getSN = conn1.prepareStatement("SELECT screen_number FROM design WHERE id = ?")) {
    getSN.setInt(1, designId);
    ResultSet rsSN = getSN.executeQuery();
    if (rsSN.next()) {
    screenNumber = rsSN.getInt("screen_number");
    System.out.println("✅ screenNumber from DB = " + screenNumber);
}

    rsSN.close();
    getSN.close();
    conn1.close(); // ✅ Close the connection after use
}

            int colorCount = Integer.parseInt(colorCountParam);
            Connection conn = DBConnection.getConnection();

            // Update Design table
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE design SET design_reference=?, combo_number=?, customer_buyer=?, received_date=?, base_color=?, color_count=? WHERE id=?");
            ps.setString(1, designReference);
            ps.setString(2, comboNumber);
            ps.setString(3, customerBuyer);
            ps.setDate(4, Date.valueOf(receivedDate));
            ps.setString(5, baseColor);
            ps.setInt(6, colorCount);
            ps.setInt(7, designId);
            ps.executeUpdate();

            // Delete old colors
            PreparedStatement deleteColors = conn.prepareStatement("DELETE FROM ColorList WHERE design_id=?");
            deleteColors.setInt(1, designId);
            deleteColors.executeUpdate();

            // Insert new color rows
            PreparedStatement insertColor = conn.prepareStatement(
                "INSERT INTO ColorList (design_id, color_name, color_code, mesh_size, coverage, screen_type) VALUES (?, ?, ?, ?, ?, ?)");

            for (int i = 0; i < colorCount; i++) {
                insertColor.setInt(1, designId);
                insertColor.setString(2, request.getParameter("colorName" + i));
                insertColor.setString(3, request.getParameter("colorCode" + i));
                insertColor.setString(4, request.getParameter("meshSize" + i));
                insertColor.setString(5, request.getParameter("colorCoverage" + i));
                insertColor.setString(6, request.getParameter("screenType" + i));
                insertColor.addBatch();
            }
            insertColor.executeBatch();

            // Update or Insert into TechnicalDetails
            PreparedStatement checkTech = conn.prepareStatement("SELECT id FROM TechnicalDetails WHERE design_id=?");
            checkTech.setInt(1, designId);
            ResultSet rsTech = checkTech.executeQuery();

            String repeatSize = request.getParameter("repeatSize");
            String printingRoute = request.getParameter("printingRoute");
            String width = request.getParameter("width");
            String height = request.getParameter("height");
            String separatedBy = request.getParameter("separatedBy");

            if (rsTech.next()) {
                PreparedStatement updateTech = conn.prepareStatement(
                    "UPDATE TechnicalDetails SET repeat_size=?, printing_route=?, width_mm=?, height_mm=?, separated_by=? WHERE design_id=?");
                updateTech.setString(1, repeatSize);
                updateTech.setString(2, printingRoute);
                updateTech.setString(3, width);
                updateTech.setString(4, height);
                updateTech.setString(5, separatedBy);
                updateTech.setInt(6, designId);
                updateTech.executeUpdate();
            } else {
                PreparedStatement insertTech = conn.prepareStatement(
                    "INSERT INTO TechnicalDetails (design_id, repeat_size, printing_route, width_mm, height_mm, separated_by) VALUES (?, ?, ?, ?, ?, ?)");
                insertTech.setInt(1, designId);
                insertTech.setString(2, repeatSize);
                insertTech.setString(3, printingRoute);
                insertTech.setString(4, width);
                insertTech.setString(5, height);
                insertTech.setString(6, separatedBy);
                insertTech.executeUpdate();
            }

            conn.close();
            response.sendRedirect("edit.jsp?success=true");




        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
