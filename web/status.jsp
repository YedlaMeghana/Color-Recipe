
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="stylesheet" href="css/status.css"/>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="body">
            <h3 class="h3">DESIGN STATUS(EDIT)</h3>
        <form action="#" method="post">
                <table class="container">
                    <tr>
                        <td><label for="screenNumber">Screen Number</label></td>
                        <td><input type="text" name="screenNumber" id="screenNumber"></td>
                    </tr>
                    <tr>
                        <td><label for="desginReference">Design Reference</label></td>
                        <td><input type="text" name="desginReference" id="desginReference"></td>
                    </tr>
                    <tr>
                        <td><button class="btn">Search</button></td>
                    </tr>
                </table>
            </form>
        
        <h3 class="h3">SEARCH RESULT</h3>
        </div>
        <%--<jsp:include page="footer.jsp"/>--%>
    </body>
</html>
