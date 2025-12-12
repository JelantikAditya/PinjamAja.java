<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, com.pinjamaja.dao.*"%>

<%
    // Pastikan hanya owner yang bisa akses
    String userRole = (String) session.getAttribute("userRole");
    if (!"OWNER".equals(userRole)) {
        response.sendRedirect("auth.jsp?error=not_owner");
        return;
    }

    // Ambil parameter
    String action = request.getParameter("action"); // "add" atau "edit"
    String itemId = request.getParameter("itemId");
    
    // Jika edit, ambil data barang
    Map<String, Object> barang = null;
    if ("edit".equals(action) && itemId != null) {
        BarangDAO barangDAO = new BarangDAO();
        String ownerId = (String) session.getAttribute("userId");
        barang = barangDAO.getBarangById(itemId, ownerId);
        
        if (barang == null) {
            response.sendRedirect("owner_dashboard.jsp?error=not_found");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%= "edit".equals(action) ? "Edit Barang" : "Tambah Barang" %> - PinjamAja</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="bg-[#F6F7FB] min-h-screen flex items-center justify-center py-12 px-4 font-sans">
    
    <div class="w-full max-w-lg bg-white rounded-xl shadow-xl p-6">
        <div class="flex items-center gap-2 mb-4">
            <a href="owner_dashboard.jsp" class="text-gray-400 hover:text-gray-600">
                <i data-lucide="arrow-left" class="w-5 h-5"></i>
            </a>
            <h2 class="text-2xl font-bold"><%= "edit".equals(action) ? "Edit Barang" : "Tambah Barang Baru" %></h2>
        </div>
        
        <form action="barang" method="POST">
            <input type="hidden" name="action" value="<%= action %>">
            <% if ("edit".equals(action)) { %>
                <input type="hidden" name="itemId" value="<%= itemId %>">
            <% } %>
            
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium mb-2">Nama Barang</label>
                    <input name="name" type="text" required 
                           value="<%= barang != null ? barang.get("title") : "" %>"
                           class="w-full h-10 rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2">Kategori</label>
                    <select name="category" required class="w-full h-10 rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                        <option value="">-- Pilih Kategori --</option>
                        <option value="Elektronik" <%= barang != null && "Elektronik".equals(barang.get("category")) ? "selected" : "" %>>Elektronik</option>
                        <option value="Perkakas" <%= barang != null && "Perkakas".equals(barang.get("category")) ? "selected" : "" %>>Perkakas</option>
                        <option value="Outdoor" <%= barang != null && "Outdoor".equals(barang.get("category")) ? "selected" : "" %>>Outdoor</option>
                        <option value="Olahraga" <%= barang != null && "Olahraga".equals(barang.get("category")) ? "selected" : "" %>>Olahraga</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2">Deskripsi</label>
                    <textarea name="description" required class="w-full min-h-[80px] rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary"><%= barang != null ? barang.get("description") : "" %></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2">Harga per Hari (Rp)</label>
                    <input name="pricePerDay" type="number" required 
                           value="<%= barang != null ? barang.get("pricePerDay") : "" %>"
                           class="w-full h-10 rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                </div>
                <div>
                    <label class="block text-sm font-medium mb-2">URL Gambar</label>
                    <input name="imageUrl" type="url" required 
                           value="<%= barang != null ? barang.get("imageUrl") : "" %>"
                           class="w-full h-10 rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                </div>
            </div>
            
            <div class="flex justify-between mt-6">
                <a href="owner_dashboard.jsp" class="px-4 py-2 border rounded-md hover:bg-gray-50 transition-colors text-sm font-medium">Batal</a>
                <button type="submit" class="px-4 py-2 bg-accent text-primary font-bold rounded-md hover:bg-accentHover transition-colors text-sm">
                    <%= "edit".equals(action) ? "Simpan Perubahan" : "Simpan Barang" %>
                </button>
            </div>
        </form>
    </div>
    
    <script>lucide.createIcons();</script>
</body>
</html>