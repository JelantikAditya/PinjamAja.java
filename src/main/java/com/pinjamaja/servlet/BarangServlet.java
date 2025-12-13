package com.pinjamaja.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pinjamaja.dao.BarangDAO;
import com.pinjamaja.util.DBConnection;

@WebServlet("/barang")
public class BarangServlet extends HttpServlet {
    
    private BarangDAO barangDAO;
    
    @Override
    public void init() throws ServletException {
        barangDAO = new BarangDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("=== BARANG SERVLET doPost ===");
        System.out.println("Action: " + action);
        
        try {
            if ("add".equals(action)) {
                handleAdd(request, response);
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
            } else if ("update".equals(action)) {
                handleUpdate(request, response);
            } else {
                System.err.println("ERROR: Unknown action in doPost: " + action);
                response.sendRedirect("owner_dashboard.jsp?error=invalid_action");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("owner_dashboard.jsp?error=database");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            handleEdit(request, response);
        }
    }
    
    // TAMBAH BARANG BARU
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        // Validasi session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?error=not_logged_in");
            return;
        }
        
        String ownerId = (String) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        if (!"OWNER".equals(userRole)) {
            response.sendRedirect("auth.jsp?error=not_owner");
            return;
        }
        
        // Ambil data dari form
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
        String imageUrl = request.getParameter("imageUrl");
        
        // Generate ID (format: ITM001, ITM002, dst)
        String itemId = generateItemId();
        
        // Simpan ke database
        boolean success = barangDAO.addBarang(itemId, name, category, description, pricePerDay, imageUrl, ownerId);
        
        if (success) {
            response.sendRedirect("owner_dashboard.jsp?success=item_added&tab=items");
        } else {
            response.sendRedirect("owner_dashboard.jsp?error=add_failed");
        }
    }
    
    // HAPUS BARANG
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?error=not_logged_in");
            return;
        }
        
        String ownerId = (String) session.getAttribute("userId");
        String itemId = request.getParameter("itemId");
        
        // Verifikasi barang milik owner ini (opsional tapi penting untuk keamanan)
        // Anda bisa tambahkan method di BarangDAO: isBarangOwnedBy(itemId, ownerId)
        
        boolean success = barangDAO.deleteBarang(itemId, ownerId);
        
        if (success) {
            response.sendRedirect("owner_dashboard.jsp?success=item_deleted&tab=items");
        } else {
            response.sendRedirect("owner_dashboard.jsp?error=delete_failed");
        }
    }
    
    // UPDATE BARANG (EDIT)
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("auth.jsp?error=not_logged_in");
            return;
        }
        
        try {
            String ownerId = (String) session.getAttribute("userId");
            if (ownerId != null) {
                ownerId = ownerId.trim();
            }
            
            String itemId = request.getParameter("itemId");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String pricePerDayStr = request.getParameter("pricePerDay");
            String imageUrl = request.getParameter("imageUrl");
            
            // Validate inputs
            if (itemId == null || itemId.isEmpty() || name == null || name.isEmpty() || 
                category == null || category.isEmpty() || description == null || description.isEmpty() || 
                pricePerDayStr == null || pricePerDayStr.isEmpty() || imageUrl == null || imageUrl.isEmpty()) {
                System.err.println("ERROR: Missing required fields");
                response.sendRedirect("owner_dashboard.jsp?error=invalid_input");
                return;
            }
            
            double pricePerDay = Double.parseDouble(pricePerDayStr);
            
            // DEBUG: Cek data di console
            System.out.println("=== UPDATE BARANG DEBUG ===");
            System.out.println("Owner ID: " + ownerId);
            System.out.println("Item ID: " + itemId);
            System.out.println("Name: " + name);
            System.out.println("Category: " + category);
            System.out.println("Price: " + pricePerDay);
            
            boolean success = barangDAO.updateBarang(itemId, name, category, description, pricePerDay, imageUrl, ownerId);
            
            System.out.println("Update Result: " + success);
            
            if (success) {
                // 🔥 PENTING: Redirect ke dashboard, bukan ke servlet
                response.sendRedirect("owner_dashboard.jsp?success=item_updated&tab=items");
            } else {
                response.sendRedirect("owner_dashboard.jsp?error=update_failed&tab=items");
            }
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid price format - " + e.getMessage());
            response.sendRedirect("owner_dashboard.jsp?error=invalid_price");
        }
    }
    
    // REDIRECT KE HALAMAN EDIT
   // DI BAGIAN handleEdit method
private void handleEdit(HttpServletRequest request, HttpServletResponse response) 
        throws IOException {
    
    String itemId = request.getParameter("itemId");
    HttpSession session = request.getSession();
    session.setAttribute("editItemId", itemId);
    response.sendRedirect("item_form.jsp?action=edit&itemId=" + itemId);
}
    
    // GENERATE ID ITEM (ITM001, ITM002, ...)
    private String generateItemId() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM items";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                int count = rs.getInt("count") + 1;
                return String.format("ITM%03d", count);
            }
            return "ITM001";
        }
    }
}