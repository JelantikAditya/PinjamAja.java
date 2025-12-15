package com.pinjamaja.servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.pinjamaja.dao.UserDAO;

@WebServlet("/admin/user")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    // Konstanta untuk session attribute (sesuaikan dengan LoginServlet Anda!)
    private static final String SESSION_ROLE_ATTR = "userRole"; // atau "userRole", cek LoginServlet
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Untuk debugging - test apakah servlet ter-mapping
        resp.setContentType("text/plain");
        resp.getWriter().println("AdminUserServlet is working! Use POST for actions.");
        resp.getWriter().println("Available actions: delete, toggleVerification");
        getServletContext().log("AdminUserServlet GET accessed - debugging mode");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        // DEBUG: Log semua parameter
        getServletContext().log("AdminUserServlet POST - Action: " + action + ", UserId: " + request.getParameter("userId"));
        
        // Authorization check
        if (session == null) {
            getServletContext().log("ERROR: No session found!");
            redirectWithError(response, "not_authorized");
            return;
        }
        
        String role = (String) session.getAttribute(SESSION_ROLE_ATTR);
        getServletContext().log("User role from session: " + role);
        
        if (role == null || !"ADMIN".equals(role)) {
            getServletContext().log("ERROR: Unauthorized access attempt! Role: " + role);
            redirectWithError(response, "not_authorized");
            return;
        }

        // Null check DAO
        if (userDAO == null) {
            getServletContext().log("FATAL ERROR: UserDAO is null! init() failed.");
            redirectWithError(response, "database");
            return;
        }
        
        String userId = request.getParameter("userId");
        if (userId == null || userId.trim().isEmpty()) {
            getServletContext().log("ERROR: Invalid userId: " + userId);
            redirectWithError(response, "invalid_input");
            return;
        }

        try {
            boolean success = false;
            if ("delete".equals(action)) {
                success = userDAO.deleteUser(userId);
                getServletContext().log("Delete user " + userId + ": " + success);
                redirectWithSuccess(response, "action_taken");
                
            } else if ("toggleVerification".equals(action)) {
                success = userDAO.toggleVerification(userId);
                getServletContext().log("Toggle verification for user " + userId + ": " + success);
                redirectWithSuccess(response, "verification_updated");
                
            } else {
                getServletContext().log("ERROR: Invalid action: " + action);
                redirectWithError(response, "invalid_action");
            }
            
        } catch (SQLException e) {
            getServletContext().log("DATABASE ERROR in AdminUserServlet", e);
            redirectWithError(response, "database");
        }
    }
    
    // Helper methods untuk redirect yang aman
    private void redirectWithSuccess(HttpServletResponse response, String successType) throws IOException {
        response.sendRedirect(getServletContext().getContextPath() + "/admin_dashboard.jsp?success=" + successType);
    }
    
    private void redirectWithError(HttpServletResponse response, String errorType) throws IOException {
        response.sendRedirect(getServletContext().getContextPath() + "/admin_dashboard.jsp?error=" + errorType);
    }
}