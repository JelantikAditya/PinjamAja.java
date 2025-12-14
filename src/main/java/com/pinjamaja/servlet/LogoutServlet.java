package com.pinjamaja.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Ambil session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate session (hapus semua data session)
            session.invalidate();
        }
        
        // Redirect ke halaman login atau landing
        response.sendRedirect("landing.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect POST ke halaman landing jika akses via GET
        doPost(request, response);
    }
}
