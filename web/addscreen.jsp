
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="stylesheet" href="css/addmesh.css">
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <form method="post" action="addScreen">
            <div class="body">
            <h3 class="h3">Add New Screen Type</h3>
            <div class="container">
                <label for="addscreen">Screen Type</label>
                <input type="text" id="newscreentype" name="newscreentype">
            </div>
            <button>Add</button>
        </div>
        </form>
        
        
    </body>
</html>
