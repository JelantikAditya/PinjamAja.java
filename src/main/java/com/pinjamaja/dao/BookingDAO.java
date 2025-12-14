package com.pinjamaja.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.pinjamaja.util.DBConnection;

public class BookingDAO {

    // === 1. GET BOOKINGS BY OWNER ===
   // === 1. GET BOOKINGS BY OWNER ===
    public List<Map<String, Object>> getBookingMapsByOwner(String ownerId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        // Query SQL tetap sama (SELECT b.* akan mengambil semua kolom yang ada)
        String sql = "SELECT b.*, i.name as item_title, i.image_url as item_image_url, u.name as borrower_name " +
                     "FROM bookings b " +
                     "JOIN items i ON b.item_id = i.id " +
                     "JOIN users u ON b.borrower_id = u.id " +
                     "WHERE i.owner_id = ? " +
                     "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> b = new HashMap<>();
                b.put("id", rs.getString("id"));
                b.put("ownerId", ownerId);
                b.put("itemTitle", rs.getString("item_title"));
                b.put("itemImageUrl", rs.getString("item_image_url"));
                b.put("borrowerName", rs.getString("borrower_name"));
                b.put("startDate", rs.getDate("start_date").toString());
                b.put("endDate", rs.getDate("end_date").toString());
                b.put("totalPrice", rs.getDouble("total_price"));
                b.put("status", rs.getString("status"));
                
                // --- PERBAIKAN: TRY-CATCH UNTUK MENGHINDARI ERROR JIKA KOLOM TIDAK ADA ---
                try {
                    b.put("paymentStatus", rs.getString("payment_status"));
                } catch (SQLException e) {
                    // Jika kolom tidak ada di database, default ke UNPAID agar tidak error
                    b.put("paymentStatus", "UNPAID");
                }
                // -------------------------------------------------------------------------
                
                list.add(b);
            }
        }
        return list;
    }

    // === 2. CREATE BOOKING ===
    public boolean createBooking(String bookingId, String borrowerId, String itemId, 
                                 String startDate, String endDate, double totalPrice) throws SQLException {
        String sql = "INSERT INTO bookings (id, borrower_id, item_id, start_date, end_date, status, total_price) " +
                     "VALUES (?, ?, ?, ?, ?, 'PENDING', ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingId);
            ps.setString(2, borrowerId);
            ps.setString(3, itemId);
            ps.setString(4, startDate);
            ps.setString(5, endDate);
            ps.setDouble(6, totalPrice);

            return ps.executeUpdate() > 0;
        }
    }

    // === 3. GET BOOKINGS BY BORROWER ===
    public List<Map<String, Object>> getBookingsByBorrower(String borrowerId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.*, i.name as item_title, u.name as owner_name " +
                     "FROM bookings b " +
                     "JOIN items i ON b.item_id = i.id " +
                     "JOIN users u ON i.owner_id = u.id " +
                     "WHERE b.borrower_id = ? " +
                     "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, borrowerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("id", rs.getString("id"));
                booking.put("itemTitle", rs.getString("item_title"));
                booking.put("ownerName", rs.getString("owner_name"));
                booking.put("startDate", rs.getDate("start_date").toString());
                booking.put("endDate", rs.getDate("end_date").toString());
                booking.put("totalPrice", rs.getDouble("total_price"));
                booking.put("status", rs.getString("status"));
                list.add(booking);
            }
        }
        return list;
    }

    // === 4. UPDATE BOOKING STATUS ===
    public boolean updateBookingStatus(String bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, bookingId);

            return ps.executeUpdate() > 0;
        }
    }

    // === 5. UPDATE PAYMENT STATUS ===
    public boolean updatePaymentStatus(String bookingId, String paymentStatus) throws SQLException {
        String sql = "UPDATE bookings SET payment_status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, paymentStatus);
            ps.setString(2, bookingId);

            return ps.executeUpdate() > 0;
        }
    }

    // === 6. GET PENDING BOOKINGS (FOR OWNER) ===
    public List<Map<String, Object>> getPendingBookingsByOwner(String ownerId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.*, i.name as item_title, i.image_url as item_image_url, u.name as borrower_name " +
                     "FROM bookings b " +
                     "JOIN items i ON b.item_id = i.id " +
                     "JOIN users u ON b.borrower_id = u.id " +
                     "WHERE i.owner_id = ? AND b.status = 'PENDING' " +
                     "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("id", rs.getString("id"));
                booking.put("itemTitle", rs.getString("item_title"));
                booking.put("itemImageUrl", rs.getString("item_image_url"));
                booking.put("borrowerName", rs.getString("borrower_name"));
                booking.put("startDate", rs.getDate("start_date").toString());
                booking.put("endDate", rs.getDate("end_date").toString());
                booking.put("totalPrice", rs.getDouble("total_price"));
                list.add(booking);
            }
        }
        return list;
    }

    // === 7. GET BOOKING BY ID (DETAILS) ===
    public Map<String, Object> getBookingById(String bookingId) throws SQLException {
        String sql = "SELECT b.*, i.owner_id as owner_id, i.name as item_name, b.total_price " +
                     "FROM bookings b JOIN items i ON b.item_id = i.id WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("ownerId", rs.getString("owner_id"));
                m.put("itemName", rs.getString("item_name"));
                m.put("totalPrice", rs.getDouble("total_price"));
                m.put("status", rs.getString("status"));
                try { m.put("paymentStatus", rs.getString("payment_status")); } catch (SQLException e) { m.put("paymentStatus", "UNPAID"); }
                return m;
            }
            return null;
        }
    }

} // <--- END OF CLASS (Pastikan ini ada di paling akhir)