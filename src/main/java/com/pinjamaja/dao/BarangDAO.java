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

public class BarangDAO {
    
    // Ambil semua barang milik owner
   // GET ALL BARANG BY OWNER ID
public List<Map<String, Object>> getBarangMapsByOwner(String ownerId) throws SQLException {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT id, name as title, category, description, price_per_day as pricePerDay, " +
                 "image_url as imageUrl, rating, review_count as reviewCount, is_available " +
                 "FROM items WHERE owner_id = ? ORDER BY created_at DESC";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, ownerId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("title", rs.getString("title"));
            item.put("category", rs.getString("category"));
            item.put("description", rs.getString("description"));
            item.put("pricePerDay", rs.getDouble("pricePerDay"));
            item.put("imageUrl", rs.getString("imageUrl"));
            item.put("rating", rs.getDouble("rating"));
            item.put("reviewCount", rs.getInt("reviewCount"));
            item.put("isAvailable", rs.getBoolean("is_available"));
            list.add(item);
        }
    }
    return list;
}
    
    // Tambah barang baru
    public boolean addBarang(String id, String name, String category, String description, 
                            double pricePerDay, String imageUrl, String ownerId) throws SQLException {
        String sql = "INSERT INTO items (id, name, category, description, price_per_day, image_url, owner_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, category);
            ps.setString(4, description);
            ps.setDouble(5, pricePerDay);
            ps.setString(6, imageUrl);
            ps.setString(7, ownerId != null ? ownerId.trim() : ownerId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // HAPUS BARANG
public boolean deleteBarang(String itemId, String ownerId) throws SQLException {
    String sql = "DELETE FROM items WHERE id = ? AND owner_id = ?";
    
       try (Connection conn = DBConnection.getConnection();
           PreparedStatement ps = conn.prepareStatement(sql)) {
        
       ps.setString(1, itemId);
       ps.setString(2, ownerId != null ? ownerId.trim() : ownerId);
        
        return ps.executeUpdate() > 0;
    }
}

// UPDATE BARANG
public boolean updateBarang(String itemId, String name, String category, String description, 
                           double pricePerDay, String imageUrl, String ownerId) throws SQLException {
    String sql = "UPDATE items SET name = ?, category = ?, description = ?, price_per_day = ?, image_url = ? " +
                 "WHERE id = ? AND owner_id = ?";
    
    System.out.println("=== UPDATE QUERY ===");
    System.out.println("SQL: " + sql);
    System.out.println("Parameters: name=" + name + ", category=" + category + ", pricePerDay=" + pricePerDay + 
                       ", itemId=" + itemId + ", ownerId=" + ownerId);
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, name);
        ps.setString(2, category);
        ps.setString(3, description);
        ps.setDouble(4, pricePerDay);
        ps.setString(5, imageUrl);
        ps.setString(6, itemId);
        ps.setString(7, ownerId);
        
        int rows = ps.executeUpdate();
        System.out.println("UPDATE Result: Rows updated = " + rows);
        return rows > 0;
    }
}

// GET BARANG BY ID (untuk halaman edit)
public Map<String, Object> getBarangById(String itemId, String ownerId) throws SQLException {
    String sql = "SELECT id, name, category, description, price_per_day as pricePerDay, image_url as imageUrl " +
                 "FROM items WHERE id = ? AND owner_id = ?";
    
       try (Connection conn = DBConnection.getConnection();
           PreparedStatement ps = conn.prepareStatement(sql)) {
        
       ps.setString(1, itemId);
       ps.setString(2, ownerId != null ? ownerId.trim() : ownerId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("title", rs.getString("name"));
            item.put("category", rs.getString("category"));
            item.put("description", rs.getString("description"));
            item.put("pricePerDay", rs.getDouble("pricePerDay"));
            item.put("imageUrl", rs.getString("imageUrl"));
            return item;
        }
    }
    return null;
}
}