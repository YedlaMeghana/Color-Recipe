package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Meghana
 */
public class LoginServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException , ServletException{
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        int userid = Integer.parseInt(request.getParameter("username"));
        String password = request.getParameter("password");
        
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/color_recipe","root","Mysql@2005");
         
            String sql = "SELECT * FROM users WHERE userid=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1,userid);
            stmt.setString(2,password);
            
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                String username = rs.getString("username");
                HttpSession session = request.getSession();
                session.setAttribute("username",username);
                response.sendRedirect("home.jsp");
            }
            else{
                response.sendRedirect("error.html");
            }
            conn.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Redirect to login page if accessed via GET
        response.sendRedirect("index.html");
    }
}
