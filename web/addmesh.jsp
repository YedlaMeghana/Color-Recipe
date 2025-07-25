<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* ,java.util.*, database.DBConnection" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="stylesheet" href="css/addmesh.css">
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <form method="post" action ="addMesh" >
            <div class="body">
            <h3 class="h3">Add New Mesh Size</h3>
            <div class="container">
                <label for="addmesh">Mesh Size</label>
                <input type="text" id="newmeshsize" name="newmeshsize">
            </div>
            <button>Add</button>
            </div>
        </form>
  <%
    String flashMessage = (String) session.getAttribute("flashMessage");
    if (flashMessage != null) {
%>
    <div id="toast"><%= flashMessage %></div>
<%
        session.removeAttribute("flashMessage");
    }
%>

    </body>
    
    <script>
    window.onload = function () {
        const toast = document.getElementById("toast");
        if (toast) {
            // Fade out after 2.5 seconds
            setTimeout(() => {
                toast.classList.add("hide");
            }, 1500);

            // Remove from DOM after 3s
            setTimeout(() => {
                toast.remove();
            }, 2000);
        }
    }
</script>

</html>
