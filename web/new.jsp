<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* ,java.util.*, database.DBConnection" %>
        <% 
            int screenno = 1000;
            try{
             Connection conn = DBConnection.getConnection();
             String sql = "SELECT MAX(screen_number) AS max_screen FROM Design ";
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery();
             if(rs.next()){
                if(rs.getInt("max_screen") == 0){
                    screenno += 1; 
                }else{
                    screenno = rs.getInt("max_screen")+1;
                }
            }
            }catch(Exception e){
            e.printStackTrace();
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
   

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> </title>
        <link rel="stylesheet" href="css/new.css"/>
    </head>
    <script>
        function generateColorRows() {
            const count = parseInt(document.getElementById('colorCount').value);
            const tbody = document.getElementById('colorBody');
            document.getElementById('totalColors').value = count;
            tbody.innerHTML = '';
            

            for (let i = 0; i < count; i++) {
//               console.log("5"+i);
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><input type="text" name="colorName`+i+`" required style="width: 97%; height: 25px;"></td>
                    <td><input type="text" name="colorCode`+i+`" required style="width: 97%; height: 25px;"></td>
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
//    console.log(row.innerHTMl);
                tbody.appendChild(row);
            }
        }
    </script>

    <body>
        
        
        <jsp:include page="header.jsp"/>
        <div class="body">
             <h3 class="h3">DESIGN (NEW)</h3>
                <form id="designForm" action="newdesign" method="post" enctype="multipart/form-data">                <table class="container">
                    <tr>
                        <td><label for="designType">Design Type</label></td>
                        <td>
                            <select  name="designType" id="designType">
                                <option value="designAdd" selected>Design (Add)</option>
                                <option value="comboAdd">Combo (Add)</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label for="screenNumber">Screen Number</label></td>
                        <td><input type="text" name="screenNumber" id="screenNumber" readonly value="<%=screenno%>"></td>
                    </tr>
                    <tr>
                        <td><label for="designReference">Design Reference</label></td>
                        <td><input type="text" name="designReference" id="designReference" required></td>
                    </tr>
                    <tr>
                        <td><label for="comboNumber">Combo Number </label></td>
                        <td><input type="text" name="comboNumber" id="comboNumber" required></td>
                    </tr>
                    <tr>
                        <td><label for="customerBuyer">Customer/Buyer </label></td>
                        <td><input type="text" name="customerBuyer" id="customerBuyer" required></td>
                    </tr>
                    <tr>
                        <td><label for="receivedDate">Received Date</label></td>
                        <td><input type="date"  name="receivedDate" id="receivedDate" required></td>
                    </tr>
                    <tr>
                        <td><label for="baseColor">Base Color</label></td>
                        <td><input type="text"name="baseColor" id="baseColor" required></td>
                    </tr>
                    <tr>
                        <td><label for="designSample">Design (Sample)</label></td>
                        <td><input type="file" id="designSample" name="designSample" required></td>
                    </tr>
                    <tr>
                        <td>  </td>
                        <td>
                            <button type="button" id="preview">Preview & Save</button>
                            <img id="previewImg" src="#" style="display:none; max-width:300px;" />
                            <div id="previewFileName" style="display:none;"></div>
                        </td>
                    </tr>
                    <tr>
                        <td><h3 id="h3">COLOR LIST</h3></td>
                        <td> </td>
                    </tr>
                    <tr>
                        <td><label for="colorCount">No. of Colors</label></td>
                        <td>
                            <input type="text" name="colorCount" id="colorCount" required>
                            <button type="button" onclick="generateColorRows()" style="height: 28px; background-color: white; border: none; vertical-align: middle;">▶</button>
                        </td>
                        <input type="hidden" name="totalColors" id="totalColors">
                    </tr>
                
                <table class="trow">
                    <tr >
                        <th class="thead">Color Name</th>
                        <th class="thead">Color Code</th>
                        <th class="thead">Mesh Size</th>
                        <th class="thead">Coverage</th>
                        <th class="thead">Screen Type</th>
                    </tr>
                    <tbody id="colorBody">
                        
                    </tbody>
                </table>
            <table class="container">
                <tr>
                    <td><h3 id="h3">TECHNICAL DETAILS</h3></td>
                    <td> </td>
                </tr>
                <tr>
                    <td><label for="repeatSize">Repeat Size</label></td>
                    <td>
                       
                        <input type="text"  id="repeatSize" name="repeatSize" class="split-input" required > (mm) 
                        <select class="split-input" id="repeatSize1" name="repeatSize1"  style="width:13.5em; height: 32px;">
                            <option value="nodrop" selected>No Drop</option>
                                <option value="halfdrop3">Half Drop</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                        <td><label for="printingRoute">Printing Route</label></td>
                        <td>
                            <select id="printingRoute" name="printingRoute">  
                                <option  value="acidprint" selected>Acid Print</option>
                                <option  value="pigmentsupersoft">Pigment SuperSoft</option>
                                <option value="pigmentdischarge">Pigment Discharge</option>
                                <option  value="reactiveprint">Reactive Print</option>
                            </select>
                        </td>
                </tr>
                <tr>
                        <td><label for="width">Width (mm)</label></td>
                        <td><input type="text" id="width" name="width" required></td>
                </tr>
                <tr>
                        <td><label for="height">Height (mm)</label></td>
                        <td><input type="text" id="height" name="height" required></td>
                </tr>
                <tr>
                    <td><label for="separatedBy">Design Separated By</label></td>
                        <td><input type="text" id="separatedBy" name="separatedBy" required></td>
                </tr>
                
                <tr>
                    <td> </td>
                    <td><button class="btn" id="submit">Submit</button>
                   <button id="clear" class="btn">Clear</button></td>
                </tr>
            </table>
        </table>
        
        
     </form>
        </div>
                    <script>
            document.getElementById("clear").addEventListener("click", function(event) {
            event.preventDefault(); // Prevent form submission
            document.getElementById("designForm").reset(); // Reset all fields
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
