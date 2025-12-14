package com.pinjamaja.servlet;

import com.pinjamaja.dao.BookingDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                handleCreateBooking(request, response);
            } else if ("approve".equals(action) || "reject".equals(action)) {
                handleOwnerAction(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=Database error");
        }
    }
    
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?error=not_logged_in");
            return;
        }
        
        String borrowerId = (String) session.getAttribute("userId");
        String itemId = request.getParameter("itemId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        // Hitung total hari
        long days = ChronoUnit.DAYS.between(LocalDate.parse(startDate), LocalDate.parse(endDate));
        if (days < 1) days = 1;
        
        // Ambil harga per hari dari parameter (sudah dihitung di frontend)
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
        double totalPrice = days * pricePerDay;
        
        // Generate ID booking
        String bookingId = "BK" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        // Simpan ke database
        boolean success = bookingDAO.createBooking(bookingId, borrowerId, itemId, startDate, endDate, totalPrice);
        
        if (success) {
            // Redirect ke history borrower
            response.sendRedirect("borrower_history.jsp?success=booked");
        } else {
            response.sendRedirect("borrower_dashboard.jsp?error=booking_failed");
        }
    }
    
    private void handleOwnerAction(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"OWNER".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("auth.jsp?error=not_owner");
            return;
        }
        
        String action = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");
        
        boolean success = false;
        if ("approve".equals(action)) {
            success = bookingDAO.updateBookingStatus(bookingId, "APPROVED");
        } else if ("reject".equals(action)) {
            success = bookingDAO.updateBookingStatus(bookingId, "REJECTED");
        }
        
        if (success) {
            response.sendRedirect("owner_dashboard.jsp?success=action_taken&tab=requests");
        } else {
            response.sendRedirect("owner_dashboard.jsp?error=action_failed&tab=requests");
        }
    }
}