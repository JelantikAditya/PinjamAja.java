package com.pinjamaja.dao;

import java.sql.*;
import java.util.*;
import com.pinjamaja.util.DBConnection;

public class BookingDAO {
    
    // Ambil semua booking milik owner
    public List<Map<String, Object>> getBookingMapsByOwner(String ownerId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
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
                list.add(b);
            }
        }
        return list;
    }
}