package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Meghana
 */
public class LogoutServlet extends HttpServlet {
    public void doGet(HttpServletRequest request , HttpServletResponse response) throws IOException , ServletException{
        HttpSession session = request.getSession(false);
        
        if(session != null){
            session.invalidate();
        }
        
        response.sendRedirect("index.html");
    }
}
