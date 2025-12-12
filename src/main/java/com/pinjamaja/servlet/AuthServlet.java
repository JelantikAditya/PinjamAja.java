package com.pinjamaja.servlet;

import com.pinjamaja.dao.UserDAO;
import com.pinjamaja.model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("login".equals(action)) {
                handleLogin(request, response);
            } else if ("register".equals(action)) {
                handleRegister(request, response);
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                              "Database error: " + e.getMessage());
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Login tanpa perlu role parameter - role diambil dari database
        User user = userDAO.login(email, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            
            // Redirect berdasarkan role dari database
            String role = user.getRole();
            switch (role) {
                case "BORROWER": 
                    response.sendRedirect("borrower_dashboard.jsp"); 
                    break;
                case "OWNER": 
                    response.sendRedirect("owner_dashboard.jsp"); 
                    break;
                case "ADMIN": 
                    response.sendRedirect("admin_dashboard.jsp"); 
                    break;
                default:
                    response.sendRedirect("auth.jsp?error=invalid");
            }
        } else {
            response.sendRedirect("auth.jsp?error=invalid");
        }
    }
    
   private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
        throws SQLException, IOException {
    
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String name = firstName + " " + lastName;
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    
    boolean success = userDAO.register(name, email, password, role);
    
    if (success) {
        // Auto login setelah register
        User user = userDAO.login(email, password, role);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            
            // 🔥 FIX: Redirect langsung ke dashboard sesuai role
            switch (role) {
                case "BORROWER": 
                    response.sendRedirect("borrower_dashboard.jsp"); 
                    break;
                case "OWNER": 
                    response.sendRedirect("owner_dashboard.jsp"); 
                    break;
                case "ADMIN": 
                    response.sendRedirect("admin_dashboard.jsp"); 
                    break;
            }
            return; // Penting! Stop eksekusi
        }
    }
    
    // Jika gagal
    response.sendRedirect("auth.jsp?error=register_failed");
}
}