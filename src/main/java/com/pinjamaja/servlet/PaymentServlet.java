package com.pinjamaja.servlet;


import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.pinjamaja.dao.BookingDAO;
import com.pinjamaja.dao.PaymentDAO;
import com.pinjamaja.dao.UserDAO;
import java.util.Map;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("process".equals(action)) {
                handlePayment(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("borrower_history.jsp?error=payment_failed");
        }
    }
    
    private void handlePayment(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?error=not_logged_in");
            return;
        }
        
        String borrowerId = (String) session.getAttribute("userId");
        String bookingId = request.getParameter("bookingId");
        String paymentMethod = request.getParameter("paymentMethod");
        String amountStr = request.getParameter("amount");
        
        // Validasi
        if (bookingId == null || bookingId.isEmpty() || paymentMethod == null || paymentMethod.isEmpty() || amountStr == null || amountStr.isEmpty()) {
            response.sendRedirect("borrower_history.jsp?error=invalid_payment");
            return;
        }

        double amount = 0.0;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect("borrower_history.jsp?error=invalid_payment");
            return;
        }

        // Buat record pembayaran di tabel payments, update booking.payment_status, dan tambahkan saldo owner
        try {
            // ambil detail booking untuk mengetahui owner dan total
            Map<String, Object> booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                response.sendRedirect("borrower_history.jsp?error=not_found");
                return;
            }

            String ownerId = (String) booking.get("ownerId");
            double paidAmount = amount; // use submitted amount

            String paymentId = "PM" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            boolean created = paymentDAO.createPayment(paymentId, bookingId, paidAmount, paymentMethod, borrowerId);
            if (!created) {
                response.sendRedirect("borrower_history.jsp?error=payment_failed");
                return;
            }

            boolean updated = bookingDAO.updatePaymentStatus(bookingId, "PAID");
            if (!updated) {
                response.sendRedirect("borrower_history.jsp?error=payment_failed");
                return;
            }

            // credit owner balance
            boolean credited = userDAO.addToBalance(ownerId, paidAmount);
            if (!credited) {
                // log but still consider payment processed; redirect with warning
                System.err.println("Failed to credit owner balance for ownerId=" + ownerId);
            }

            response.sendRedirect("borrower_history.jsp?success=payment_done");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("borrower_history.jsp?error=database_error");
        }
    }
}
