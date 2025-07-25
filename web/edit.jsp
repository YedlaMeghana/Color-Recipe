<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* ,java.util.*, database.DBConnection, javax.servlet.http.*" %>
<%
    String method = request.getMethod();
    List<Map<String, String>> results = new ArrayList<>();
    String screenNumber = request.getParameter("screenNumber");
    String designReference = request.getParameter("designReference");

    if ("POST".equalsIgnoreCase(method)) {
        if ((screenNumber == null || screenNumber.trim().isEmpty()) &&
            (designReference == null || designReference.trim().isEmpty())) {
            out.println("<script>alert('No screen number or design reference provided!');</script>");
        } else {
            try {
                Connection conn = DBConnection.getConnection();
                if (designReference != null && !designReference.trim().isEmpty()) {
                    String sql = "SELECT screen_number, color_count, design_reference, customer_buyer FROM Design WHERE design_reference = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, designReference);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("screen_number", rs.getString("screen_number"));
                        row.put("color_count", rs.getString("color_count"));
                        row.put("design_reference", rs.getString("design_reference"));
                        row.put("customer_buyer", rs.getString("customer_buyer"));
                        results.add(row);
                    }
                    rs.close();
                    stmt.close();
                } else if (screenNumber != null && !screenNumber.trim().isEmpty()) {
                    String sql = "SELECT screen_number, color_count, design_reference, customer_buyer FROM Design WHERE screen_number = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(screenNumber));
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("screen_number", rs.getString("screen_number"));
                        row.put("color_count", rs.getString("color_count"));
                        row.put("design_reference", rs.getString("design_reference"));
                        row.put("customer_buyer", rs.getString("customer_buyer"));
                        results.add(row);
                    }
                    rs.close();
                    stmt.close();
                }
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        }
    }
%>
<%
    if ("true".equals(request.getParameter("success"))) {
%>
<script>alert('Design updated successfully!');</script>
<%
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>EDIT</title>
        <link rel="stylesheet" href="css/edit.css"/>
        <style>
            .searchtable{
                border: 1px solid grey;
            }
            .tbody td{
                border: 1px solid grey;               
            }
            .screen-wrapper{
                width: 100%;
            }
            .select-cell{
                width: 30%;
                float: left;
                margin-left:5px;
                box-sizing: border-box;
            }
            .screenno-cell{
                width: 70%;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="body">
            <h3 class="h3">DESIGN (EDIT)</h3>
            <form id="editForm" method="post">
                <table class="container" >
                    <tr>
                        <td><label for="screenNumber">Screen Number</label></td>
                        <td>
                            <input type="text" name="screenNumber" id="screenNumber" 
                                value="<%= (screenNumber != null) ? screenNumber : "" %>">
                        </td>
                    </tr>
                    <tr>
                        <td><label for="designReference">Design Reference</label></td>
                        <td>
                            <input type="text" name="designReference" id="designReference"
                                value="<%= (designReference != null) ? designReference : "" %>">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><button class="btn" type="submit">Search</button></td>
                    </tr>
                </table>
            </form>

            <h3 class="h3">SEARCH RESULT</h3>
            <table class="searchtable" style="border-collapse: collapse; border: 1px solid black;">
                <tr>
                    <td class="thead" colspan="2">Screen Number</td>
                    <td class="thead">Colors</td>
                    <td class="thead">Design Reference</td>
                    <td class="thead">Customer</td>
                </tr>
                <tbody class="tbody">
                <% if (!results.isEmpty()) {
                    for (Map<String, String> row : results) { %>
                        <tr>
                            <td class="screen-wrapper" colspan="2" style="border: 1px solid black">
                                <a href="designdetails.jsp?screenNumber=<%= row.get("screen_number") %>" class="select-cell">Select</a>
                                <span class="screenno-cell"><%= row.get("screen_number") %></span>
                            </td>
                            <td style="border: 1px solid black;"><%= row.get("color_count") %></td>
                            <td style="border: 1px solid black;"><%= row.get("design_reference") %></td>
                            <td style="border: 1px solid black;"><%= row.get("customer_buyer") %></td>
                        </tr>
                <%   }
                   } else if ("POST".equalsIgnoreCase(method)) { %>
                   <tr><td colspan="5">No results found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <%--<jsp:include page="footer.jsp"/>--%>
    </body>
</html>