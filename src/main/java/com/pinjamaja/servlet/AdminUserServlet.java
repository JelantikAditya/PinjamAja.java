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

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("userRole") : null;

        // Basic authorization: only ADMIN can perform this
        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect("admin_dashboard.jsp?error=not_authorized");
            return;
        }

        if ("delete".equals(action)) {
            String userId = request.getParameter("userId");
            if (userId == null || userId.isEmpty()) {
                response.sendRedirect("admin_dashboard.jsp?error=invalid_input");
                return;
            }
            try {
                boolean deleted = userDAO.deleteUser(userId);
                if (deleted) response.sendRedirect("admin_dashboard.jsp?success=action_taken");
                else response.sendRedirect("admin_dashboard.jsp?error=action_failed");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?error=database");
            }
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=invalid_action");
        }
    }
}
