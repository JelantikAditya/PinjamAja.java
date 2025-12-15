package com.pinjamaja.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.pinjamaja.model.Admin;
import com.pinjamaja.model.Borrower;
import com.pinjamaja.model.Owner;
import com.pinjamaja.model.User;
import com.pinjamaja.util.DBConnection;

public class UserDAO {
    
    // LOGIN - Mencari user berdasarkan email & password (role diambil dari database)
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                // Validasi password: cek apakah hash cocok
                if (validatePassword(password, storedPassword)) {
                    String id = rs.getString("id");
                    String name = rs.getString("name");
                    String role = rs.getString("role");
                    boolean isVerified = rs.getBoolean("is_verified");
                    double balance = rs.getDouble("balance");
                    String storeName = rs.getString("store_name");
                    
                    // Buat object sesuai role
                    switch (role) {
                        case "BORROWER":
                            return new Borrower(id, name, email, password, balance, isVerified);
                        case "OWNER":
                            return new Owner(id, name, email, password, storeName, isVerified);
                        case "ADMIN":
                            return new Admin(id, name, email, password);
                        default:
                            return null;
                    }
                }
            }
            return null; // Login gagal
        }
    }
    
    // LOGIN dengan role parameter (untuk backward compatibility jika diperlukan)
    public User login(String email, String password, String role) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND role = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, role);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                // Validasi password
                if (validatePassword(password, storedPassword)) {
                    String id = rs.getString("id");
                    String name = rs.getString("name");
                    boolean isVerified = rs.getBoolean("is_verified");
                    double balance = rs.getDouble("balance");
                    String storeName = rs.getString("store_name");
                    
                    // Buat object sesuai role
                    switch (role) {
                        case "BORROWER":
                            return new Borrower(id, name, email, password, balance, isVerified);
                        case "OWNER":
                            return new Owner(id, name, email, password, storeName, isVerified);
                        case "ADMIN":
                            return new Admin(id, name, email, password);
                        default:
                            return null;
                    }
                }
            }
            return null;
        }
    }
    
    // REGISTER - Buat akun baru
    public boolean register(String name, String email, String password, String role) throws SQLException {
        // Cek apakah email sudah ada
        if (isEmailExists(email)) {
            return false;
        }
        
        // Hash password dengan salt
        String hashedPassword = hashPassword(password);
        
        String sql = "INSERT INTO users (id, name, email, password, role, is_verified) VALUES (?, ?, ?, ?, ?, FALSE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, generateId(role));
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, hashedPassword);
            ps.setString(5, role);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // CEK EMAIL - Mencegah duplikasi
    private boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
    
    // HASH PASSWORD - Gunakan MD5 dengan salt untuk keamanan yang lebih baik
    private String hashPassword(String password) throws SQLException {
        try {
            // Generate salt sederhana dari timestamp
            String salt = String.valueOf(System.currentTimeMillis()).substring(0, 8);
            String passwordWithSalt = salt + password;
            
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(passwordWithSalt.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            // Format: salt$hash
            return salt + "$" + sb.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new SQLException("Error hashing password: " + e.getMessage());
        }
    }
    
    // VALIDATE PASSWORD - Bandingkan input password dengan stored hash
    private boolean validatePassword(String inputPassword, String storedHash) {
        try {
            if (storedHash == null || !storedHash.contains("$")) {
                // Backward compatibility untuk password lama (MD5 tanpa salt)
                java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
                byte[] messageDigest = md.digest(inputPassword.getBytes());
                StringBuilder sb = new StringBuilder();
                for (byte b : messageDigest) {
                    sb.append(String.format("%02x", b));
                }
                return sb.toString().equals(storedHash);
            }
            
            // Extract salt dari stored hash
            String[] parts = storedHash.split("\\$");
            String salt = parts[0];
            String storedPasswordHash = parts[1];
            
            // Hash input password dengan salt yang sama
            String passwordWithSalt = salt + inputPassword;
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(passwordWithSalt.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            
            return sb.toString().equals(storedPasswordHash);
        } catch (Exception e) {
            System.err.println("Error validating password: " + e.getMessage());
            return false;
        }
    }
    
    // GENERATE ID - Format: BOR001, OWN001, ADM001
    private String generateId(String role) throws SQLException {
        String prefix = role.substring(0, 3).toUpperCase();
        String sql = "SELECT COUNT(*) as count FROM users WHERE role = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("%s%03d", prefix, count);
            }
            return prefix + "001";
        }
    }

    // Tambah saldo ke user (mis. owner) dengan menambahkan amount ke kolom balance
    public boolean addToBalance(String userId, double amount) throws SQLException {
        String sql = "UPDATE users SET balance = COALESCE(balance,0) + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // DELETE USER - untuk admin menghapus akun
    public boolean deleteUser(String userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // TOGGLE VERIFICATION - untuk admin mengubah status verifikasi pengguna
    public boolean toggleVerification(String userId) throws SQLException {
        String sql = "UPDATE users SET is_verified = NOT is_verified WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}