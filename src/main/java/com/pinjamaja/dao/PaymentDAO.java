package com.pinjamaja.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.pinjamaja.util.DBConnection;

public class PaymentDAO {

    public boolean createPayment(String paymentId, String bookingId, double amount, String method, String payerId) throws SQLException {
        String sql = "INSERT INTO payments (id, booking_id, amount, method, payer_id, paid_at) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentId);
            ps.setString(2, bookingId);
            ps.setDouble(3, amount);
            ps.setString(4, method);
            ps.setString(5, payerId);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, Object> getPaymentByBooking(String bookingId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY paid_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("bookingId", rs.getString("booking_id"));
                m.put("amount", rs.getDouble("amount"));
                m.put("method", rs.getString("method"));
                m.put("payerId", rs.getString("payer_id"));
                m.put("paidAt", rs.getTimestamp("paid_at"));
                return m;
            }
            return null;
        }
    }
}
