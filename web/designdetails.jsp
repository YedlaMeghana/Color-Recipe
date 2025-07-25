<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, database.DBConnection"%>
<%@page import="java.util.*, java.text.SimpleDateFormat, java.util.Date "%>
<%
    String screenNumberStr = request.getParameter("screenNumber");
//    out.println("Received screenNumber =" + screenNumberStr); 
    int screenNo = 0; 
    int designId = 0;

    if (screenNumberStr != null && !screenNumberStr.isEmpty()) {
        screenNo = Integer.parseInt(screenNumberStr);
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps1 = conn.prepareStatement("SELECT id FROM design WHERE screen_number = ?");
            ps1.setInt(1, screenNo);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                designId = rs1.getInt("id");
            }
            
        }catch(Exception e){
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red;'>No design ID provided!</p>");
        return;
    }
%>
<%
        List<String> meshSize = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT meshSizes FROM mesh");

            while (rs.next()) {
                meshSize.add(rs.getString("meshSizes"));
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <%
        List<String> screenTypes = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT screenType FROM screenTypes");

            while (rs.next()) {
                screenTypes.add(rs.getString("screenType"));
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
<%
    List<String> meshSizeOptions = new ArrayList<>();
    List<String> screenTypeOptions = new ArrayList<>();

    try {
        Connection conn = DBConnection.getConnection();

        // Fetch mesh sizes
        PreparedStatement meshStmt = conn.prepareStatement("SELECT DISTINCT meshSizes FROM mesh ORDER BY meshSizes");
        ResultSet meshRs = meshStmt.executeQuery();
        while (meshRs.next()) {
            meshSizeOptions.add(meshRs.getString("meshSizes"));
        }

        // Fetch screen types
        PreparedStatement screenStmt = conn.prepareStatement("SELECT DISTINCT screentype FROM screenTypes ORDER BY screentype");
        ResultSet screenRs = screenStmt.executeQuery();
        while (screenRs.next()) {
            screenTypeOptions.add(screenRs.getString("screentype"));
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<%

    String designReference = "", comboNumber = "", customerBuyer = "", baseColor = "", repeat_size = "", repeat_size1 = "", printing_route = "", separated_by = "";
    double width_mm = 0, height_mm = 0;
    int colorCount = 0;
    java.sql.Date receivedDate = null;
    String displayDate = ""; 

    List<Map<String, String>> colorList = new ArrayList<>();

    if (screenNumberStr != null && !screenNumberStr.isEmpty()) {
        try {
            Connection conn = DBConnection.getConnection();
            
            // 1. Get design details
            PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM design WHERE id = ?");
            ps1.setInt(1, designId);
            
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                designReference = rs1.getString("design_reference");
                comboNumber = rs1.getString("combo_number");
                customerBuyer = rs1.getString("customer_buyer");
                 receivedDate = rs1.getDate("received_date");

            if (receivedDate != null) {
            // yyyy-MM-dd format for <input type="date">
                java.text.SimpleDateFormat inputFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
                displayDate = inputFormat.format(receivedDate);
            }
                baseColor = rs1.getString("base_color");
                colorCount = rs1.getInt("color_count");
            }

            // 2. Get technical details
            PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM TechnicalDetails WHERE design_id = ?");
            ps2.setInt(1, designId);
            ResultSet techRS = ps2.executeQuery();
//            Map<String, String> techDetails = new HashMap<>();
            if (techRS.next()) {
                repeat_size = techRS.getString("repeat_size");
                repeat_size1 = techRS.getString("repeat_size1");
//                    out.println("Received repeat_size1 =" + repeat_size1); 
                printing_route = techRS.getString("printing_route");
                width_mm = techRS.getDouble("width_mm");
                height_mm = techRS.getDouble("height_mm");
                separated_by = techRS.getString("separated_by");
            }


            // 3. Get color list
            String colorQuery = "SELECT * FROM ColorList WHERE design_id = ?";
    PreparedStatement colorStmt = conn.prepareStatement(colorQuery);
    colorStmt.setInt(1, designId);
    ResultSet colorRs = colorStmt.executeQuery();

//     colorList = (List<Map<String, String>>) request.getAttribute("colorList");
    while (colorRs.next()) {
        Map<String, String> row = new HashMap<>();
        row.put("colorName", colorRs.getString("color_name"));
        row.put("colorCode", colorRs.getString("color_code"));
        row.put("meshSize", colorRs.getString("mesh_size"));
        row.put("colorCoverage", colorRs.getString("coverage"));
        row.put("screenType", colorRs.getString("screen_type"));
        colorList.add(row);
        colorCount = colorList.size(); 
    }
//        out.println("<p>Total colors fetched: " + colorList.size() + "</p>");

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>



<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/new.css"/>
        <style>
            input[type="file"]{
    height: 27px;
    width: 29em;
    margin-bottom: 5px;
    
}
        </style>
        <script>
    const meshSizes = [<%
        for (int i = 0; i < meshSizeOptions.size(); i++) {
            out.print("\"" + meshSizeOptions.get(i) + "\"");
            if (i < meshSizeOptions.size() - 1) out.print(", ");
        }
    %>];

    const screenTypes = [<%
        for (int i = 0; i < screenTypeOptions.size(); i++) {
            out.print("\"" + screenTypeOptions.get(i) + "\"");
            if (i < screenTypeOptions.size() - 1) out.print(", ");
        }
    %>];
</script>

        <script>
    function generateColorRows() {
    const tbody = document.getElementById('colorBody');
    const existingRows = tbody.rows.length;
    const desiredCount = parseInt(document.getElementById('colorCount').value);

    document.getElementById('totalColors').value = desiredCount;

    for (let i = existingRows; i < desiredCount; i++) {
        const row = document.createElement('tr');

        let meshOptions = '<option value="">Select</option>';
        meshSizes.forEach(mesh => {
            meshOptions += `<option value="${mesh}">${mesh}</option>`;
        });

        let screenOptions = '<option value="">Select</option>';
        screenTypes.forEach(type => {
            screenOptions += `<option value="${type}">${type}</option>`;
        });

        row.innerHTML = `
            <td><input type="text" name="colorName${i}" required style="width: 97%; height: 25px;"></td>
            <td><input type="text" name="colorCode${i}" required style="width: 97%; height: 25px;"></td>
            <td>
                    <select name="meshSize`+i+`" required style="width: 99%; height: 29px;">
                        <option value="">Select</option>
                       <% for(String mesh : meshSize) { %>
                                <option value="<%= mesh %>"><%= mesh %></option>
                            <% } %>
                    </select>
                </td>
                    <td><input type="text" name="colorCoverage`+i+`" required style="width: 97%; height: 25px;"></td>
                    <td>
                        <select name="screenType`+i+`" style="width: 99%; height: 29px;">
                            <option value="">Select</option>
                            <% for(String type : screenTypes) { %>
                                <option value="<%= type %>"><%= type %></option>
                            <% } %>
                        </select>
                    </td>
        `;
        tbody.appendChild(row);
    }
}
</script>


    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <h3 class="h3">DESIGN DETAILS</h3>
        <form action="updateDesign" method="post">
            <input type="hidden" name="designId" value="<%= designId %>">
                <table class="container">
                    <tr>
                        <td><label for="designReference">Design Reference</label></td>
                        <td><input type="text" name="designReference" id="designReference"disabled value="<%=designReference%>"></td>
                    </tr>
                    <tr>
                        <td><label for="comboNumber">Combo Number </label></td>
                        <td><input type="text" name="comboNumber" id="comboNumber" disabled value="<%=comboNumber%>"></td>
                    </tr>
                    <tr>
                        <td><label for="customer-buyer">Customer/Buyer </label></td>
                        <td><input type="text" name="customer-buyer" id="customer-buyer" disabled value="<%=customerBuyer%>"></td>
                    </tr>
                    <tr>
                        <td><label for="receivedDate">Received Date</label></td>
                        <td><input type="date"  name="receivedDate" id="receivedDate" disabled value="<%=displayDate%>"></td>
                    </tr>
                    <tr>
                        <td><label for="baseColor">Base Color</label></td>
                        <td><input type="text"name="baseColor" id="baseColor" disabled value="<%=baseColor%>"></td>
                    </tr>
                    <tr>
                        <td><label for="designSample">Design (Sample)</label></td>
                        <td><input type="file" id="designSample" disabled name="designSample"></td>
                    </tr>
                    <<td>
                            <button type="button" id="preview">Preview & Save</button>
                            <img id="previewImg" src="#" style="display:none; max-width:300px;" />
                            <div id="previewFileName" style="display:none;"></div>
                    </td>
                    <tr>
                        <td><h3 id="h3">COLOR LIST</h3></td>
                        <td> </td>
                    </tr>
                    <tr>
                        <td><label for="colorCount">No. of Colors</label></td>
                        <input type="hidden" id="totalColors" name="colorCount" value="<%= colorCount %>">
                        <td>
                            <input type="number" name="colorCount" id="colorCount" disabled value="<%=colorCount%>">
                            <button  type="button"  onclick="generateColorRows()" style="height: 28px; background-color: white; border: none; vertical-align: middle;">▶</button>
                        </td>
                    </tr>
                </table>
                <table class="trow">
                    <tr >
                        <th class="thead">Color Name</th>
                        <th class="thead">Color Code</th>
                        <th class="thead">Mesh Size</th>
                        <th class="thead">Coverage</th>
                        <th class="thead">Screen Type</th>
                    </tr>
                    <tbody id="colorBody">
                    <%
            for (int i = 0; i < colorCount; i++) {
            Map<String, String> row = (i < colorList.size()) ? (Map<String, String>) colorList.get(i) : new HashMap<String, String>();
        %>
        <tr>
            <td><input type="text" name="colorName<%=i%>" style="width: 97%; height: 25px;" disabled value="<%=row.getOrDefault("colorName", "")%>" /></td>
            <td><input type="text" name="colorCode<%=i%>" style="width: 97%; height: 25px;" disabled value="<%=row.getOrDefault("colorCode", "")%>" /></td>
            <td>
                <select name="meshSize<%=i%>" class="Dropdown" style="width: 97%; height: 29px;" disabled>
                <%
                    for (String mesh : meshSizeOptions) {
                    String selected = mesh.equals(row.get("meshSize")) ? "selected" : "";
                %>
                <option value="<%=mesh%>" <%=selected%>><%=mesh%></option>
                <%
                    }
                %>
            </select>
            </td>
            <td><input type="text" name="colorCoverage<%=i%>" style="width: 97%; height: 25px;"disabled  value="<%=row.getOrDefault("colorCoverage", "")%>" /></td>
            <td>
                <select name="screenType<%=i%>" class="Dropdown" style="width: 97%; height: 29px;" disabled>
                <%
                    for (String screen : screenTypeOptions) {
                    String selected = screen.equals(row.get("screenType")) ? "selected" : "";
                %>
                <option value="<%=screen%>" <%=selected%>><%=screen%></option>
                <%
                    }
                %>
                </select>
            </td>
        </tr>
        <%
            }
        %>
</tbody>

                </table>
            <table class="container">
                <tr>
                    <td><h3 id="h3">TECHNICAL DETAILS</h3></td>
                    <td> </td>
                </tr>
                <tr>
                    <td><label for="repeatSize">Repeat Size</label></td>
                    <tr>
    <td><label for="repeatSize">Repeat Size</label></td>
    <td>
        <input type="text" id="repeatSize" name="repeatSize" class="split-input" disabled value="<%=repeat_size%>"> (mm)
        <select class="Dropdown  split-input" id="repeatSize1" name="repeatSize1" disabled style="width:13.5em; height: 32px;">
            <option value="nodrop" <%= "nodrop".equals(repeat_size1) ? "selected" : "" %>>No Drop</option>
            <option value="halfdrop3" <%= "halfdrop3".equals(repeat_size1) ? "selected" : "" %>>Half Drop</option>
        </select>
    </td> 
</tr>
<tr>
    <td><label for="printingRoute">Printing Route</label></td>
    <td>
        <select class="Dropdown" id="printingRoute" name="printingRoute" disabled>
            <option value="acidprint" <%= "acidprint".equals(printing_route) ? "selected" : "" %>>Acid Print</option>
            <option value="pigmentsupersoft" <%= "pigmentsupersoft".equals(printing_route) ? "selected" : "" %>>Pigment SuperSoft</option>
            <option value="pigmentdischarge" <%= "pigmentdischarge".equals(printing_route) ? "selected" : "" %>>Pigment Discharge</option>
            <option value="reactiveprint" <%= "reactiveprint".equals(printing_route) ? "selected" : "" %>>Reactive Print</option>
        </select>
    </td>
</tr>

                <tr>
                        <td><label for="width">Width (mm)</label></td>
                        <td><input type="text" id="width" name="width" value="<%=width_mm%>" disabled></td>
                </tr>
                <tr>
                        <td><label for="height">Height (mm)</label></td>
                        <td><input type="text" id="height" name="height" value="<%=height_mm%>" disabled></td>
                </tr>
                <tr>
                    <td><label for="separatedBy">Design Separated By</label></td>
                        <td><input type="text" id="separatedBy" name="separatedBy" value="<%=separated_by%>" disabled></td>
                </tr>
                
                <tr>
                    <td> </td>
                    <td><button class="btn" id="editBtn">Edit</button>
                   <button class="btn" id="submit" disabled>Submit</button></td>
                </tr>
            </table>
        </form>
        <script>   
            document.getElementById('editBtn').addEventListener('click', function(e) {
            e.preventDefault(); // Prevent form from submitting if inside <form>
            const inputs = document.querySelectorAll('input');
            inputs.forEach(input => {
            if (input.type !== "file") {
                input.removeAttribute('disabled');
            }
            });
            document.getElementById('designSample').removeAttribute('disabled');
            document.getElementById('colorCount').removeAttribute('disabled');
            const selects = document.querySelectorAll(".Dropdown");
            selects.forEach(select => select.removeAttribute("disabled"));
            // Enable submit button
            document.getElementById('submit').removeAttribute('disabled');
            });
 
        </script>
        <script>
document.getElementById('preview').addEventListener('click', function() {
    const fileInput = document.getElementById("designSample");
    const file = fileInput.files[0];
    const previewImg = document.getElementById("previewImg");

    if (!file) {
        alert("Please select a file first!");
        previewImg.style.display = "none";
        return;
    }
    if (file.type.startsWith("image/")) {
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewImg.style.display = "block";
        }
        reader.readAsDataURL(file);
    } else {
        previewImg.style.display = "none";
        alert("Selected file is not an image.");
    }
});
</script>
        <jsp:include page="footer.jsp"/>
    </body>
    
</html>
