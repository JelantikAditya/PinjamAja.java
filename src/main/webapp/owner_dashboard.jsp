<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat, com.pinjamaja.dao.*"%>

<%
    // === STEP 1: VALIDASI SESSION ===
    String currentUserId = (String) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    
    if (currentUserId == null || !"OWNER".equals(userRole)) {
        response.sendRedirect("auth.jsp?error=not_owner");
        return;
    }

    // === STEP 2: AMBIL DATA DARI DB ===
    BarangDAO barangDAO = new BarangDAO();
    BookingDAO bookingDAO = new BookingDAO();
    
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // FETCH DATA
    List<Map<String, Object>> myItems = barangDAO.getBarangMapsByOwner(currentUserId);
    List<Map<String, Object>> myBookings = bookingDAO.getBookingMapsByOwner(currentUserId);

    // === STEP 3: FILTER BOOKING ===
    List<Map<String, Object>> pendingBookings = new ArrayList<>();
    List<Map<String, Object>> activeRentals = new ArrayList<>();
    double totalEarnings = 0;

    for (Map<String, Object> booking : myBookings) {
        String status = (String) booking.get("status");
        if ("PENDING".equals(status)) {
            pendingBookings.add(booking);
        } else if ("APPROVED".equals(status) || "ONGOING".equals(status)) {
            activeRentals.add(booking);
        } else if ("COMPLETED".equals(status)) {
            totalEarnings += (Double) booking.get("totalPrice");
        }
    }

    // === DEBUG: Print ke server log (bukan ke browser) ===
    System.out.println("=== OWNER DASHBOARD DEBUG ===");
    System.out.println("User ID: " + currentUserId);
    System.out.println("Items count: " + myItems.size());
    for (Map<String, Object> item : myItems) {
        System.out.println(" - " + item.get("id") + ": " + item.get("title"));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard Pemilik - PinjamAja</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#2B6CB0',
                        accent: '#FFD54A',
                    }
                }
            }
        }
    </script>
    
    <style>
        .tab-active { border-bottom: 2px solid #2B6CB0; color: #2B6CB0; font-weight: 600; }
        .tab-inactive { color: #6B7280; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
</head>
<body class="bg-[#F6F7FB] text-slate-800 font-sans min-h-screen">

<!-- NAVBAR -->
<nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
    <div class="container mx-auto px-4 h-16 flex items-center justify-between">
        <a href="landing.jsp" class="flex items-center gap-2 group">
            <div class="bg-primary text-white p-1.5 rounded-lg">
                <i data-lucide="hexagon" class="w-5 h-5 fill-current"></i>
            </div>
            <span class="text-xl font-bold text-primary tracking-tight">PinjamAja</span>
        </a>

        <div class="flex items-center gap-6">
            <a href="owner_dashboard.jsp" class="text-sm font-semibold text-gray-900 border-b-2 border-primary py-5">
                Dashboard
            </a>
            
            <div class="relative">
                <button onclick="toggleProfile()" class="w-9 h-9 rounded-full bg-blue-100 flex items-center justify-center text-primary hover:ring-2 hover:ring-primary/20 transition-all focus:outline-none">
                    <i data-lucide="user" class="w-5 h-5"></i>
                </button>

                <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-100 py-2 animate-in fade-in zoom-in-95 duration-100 origin-top-right">
                    <div class="px-4 py-3 border-b border-gray-100 mb-2">
                        <p class="text-sm font-bold text-gray-900"><%= userName %></p>
                        <p class="text-xs text-gray-500">Owner - PinjamAja</p>
                    </div>
                    
                    <a href="auth.jsp?logout=true" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors cursor-pointer w-full text-left">
                        <i data-lucide="log-out" class="w-4 h-4"></i>
                        Keluar
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="container mx-auto px-4 py-8">
    
    <!-- HEADER -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Halo, <%= userName %>!</h1>
            <p class="text-gray-500">Kelola barang dan permintaan sewa Anda.</p>
        </div>
        <a href="item_form.jsp?action=add" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 bg-primary text-white hover:bg-blue-700 transition-colors shadow-sm">
            <i data-lucide="plus" class="mr-2 h-4 w-4"></i> Tambah Barang Baru
        </a>
    </div>

    <!-- SUCCESS/ERROR ALERTS -->
    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
    %>
        <div class="mb-4 p-3 rounded-lg border border-green-200 bg-green-50 text-green-700 text-sm flex items-center gap-2">
            <i data-lucide="check-circle" class="w-4 h-4"></i>
            <% if ("item_saved".equals(success)) { %>Barang berhasil disimpan!<% } %>
            <% if ("item_deleted".equals(success)) { %>Barang berhasil dihapus!<% } %>
        </div>
    <%
        } else if (error != null) {
    %>
        <div class="mb-4 p-3 rounded-lg border border-red-200 bg-red-50 text-red-700 text-sm flex items-center gap-2">
            <i data-lucide="alert-circle" class="w-4 h-4"></i>
            <% if ("save_failed".equals(error)) { %>Gagal menyimpan barang.<% } %>
            <% if ("not_owner".equals(error)) { %>Akses ditolak.<% } %>
        </div>
    <%
        }
    %>

    <!-- STATS CARDS -->
    <div class="grid gap-4 md:grid-cols-3 mb-8">
        <div class="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
            <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                <h3 class="text-sm font-medium text-gray-500">Total Pendapatan</h3>
                <i data-lucide="dollar-sign" class="h-4 w-4 text-green-600"></i>
            </div>
            <div class="text-2xl font-bold text-gray-900"><%= rpFormat.format(totalEarnings) %></div>
            <p class="text-xs text-gray-500 mt-1">Dari <%= myBookings.size() %> transaksi</p>
        </div>

        <div class="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
            <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                <h3 class="text-sm font-medium text-gray-500">Sewa Aktif</h3>
                <i data-lucide="clock" class="h-4 w-4 text-primary"></i>
            </div>
            <div class="text-2xl font-bold text-gray-900"><%= activeRentals.size() %></div>
            <p class="text-xs text-gray-500 mt-1">Sedang dipinjam</p>
        </div>

        <div class="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
            <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                <h3 class="text-sm font-medium text-gray-500">Barang Terdaftar</h3>
                <i data-lucide="package" class="h-4 w-4 text-orange-500"></i>
            </div>
            <div class="text-2xl font-bold text-gray-900"><%= myItems.size() %></div>
            <p class="text-xs text-gray-500 mt-1">Item di katalog</p>
        </div>
    </div>

    <!-- TABS -->
    <div class="w-full">
        <div class="flex space-x-6 border-b border-gray-200 mb-6">
            <button onclick="switchTab('requests')" id="tab-requests" class="tab-active py-2 px-1 relative">
                Permintaan Masuk
                <% if (pendingBookings.size() > 0) { %>
                    <span class="absolute -top-1 -right-3 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[10px] text-white">
                        <%= pendingBookings.size() %>
                    </span>
                <% } %>
            </button>
            <button onclick="switchTab('rentals')" id="tab-rentals" class="tab-inactive py-2 px-1 hover:text-gray-900">Semua Sewa</button>
            <button onclick="switchTab('items')" id="tab-items" class="tab-inactive py-2 px-1 hover:text-gray-900">Barang Saya</button>
        </div>

        <!-- PERMINTAAN MASUK -->
        <div id="content-requests" class="tab-content active">
            <div class="bg-white rounded-lg border border-gray-100 shadow-sm">
                <div class="p-6 border-b border-gray-100">
                    <h3 class="text-lg font-semibold">Permintaan Sewa</h3>
                    <p class="text-sm text-gray-500">Tinjau dan setujui permintaan sewa masuk.</p>
                </div>
                <div class="p-6">
                    <% if (pendingBookings.isEmpty()) { %>
                        <div class="text-center py-8 text-gray-500">Tidak ada permintaan tertunda saat ini.</div>
                    <% } else { %>
                        <div class="space-y-4">
                            <% for (Map<String, Object> bData : pendingBookings) { %>
                            <div class="flex flex-col md:flex-row items-center justify-between p-4 border rounded-lg bg-white">
                                <div class="flex items-center gap-4 mb-4 md:mb-0 w-full">
                                    <img src="<%= bData.get("itemImageUrl") %>" class="w-16 h-16 rounded-lg object-cover bg-gray-100" />
                                    <div>
                                        <h4 class="font-bold text-gray-900"><%= bData.get("itemTitle") %></h4>
                                        <p class="text-sm text-gray-500">Diminta oleh <span class="font-medium text-primary"><%= bData.get("borrowerName") %></span></p>
                                        <div class="text-xs text-gray-400 mt-1 flex gap-2">
                                            <span><%= bData.get("startDate") %> s/d <%= bData.get("endDate") %></span>
                                            <span>•</span>
                                            <span class="text-green-600 font-medium"><%= rpFormat.format(bData.get("totalPrice")) %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex gap-2 w-full md:w-auto mt-4 md:mt-0">
                                    <form action="BookingServlet" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="bookingId" value="<%= bData.get("id") %>">
                                        <button type="submit" class="px-4 py-2 border border-red-200 text-red-600 hover:bg-red-50 rounded-md text-sm font-medium">Tolak</button>
                                    </form>
                                    <form action="BookingServlet" method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="bookingId" value="<%= bData.get("id") %>">
                                        <button type="submit" class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-md text-sm font-medium">Setujui</button>
                                    </form>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- RIWAYAT SEWA -->
        <div id="content-rentals" class="tab-content">
            <div class="bg-white rounded-lg border border-gray-100 shadow-sm overflow-hidden">
                <div class="p-6 border-b border-gray-100">
                    <h3 class="text-lg font-semibold">Riwayat Sewa</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left">
                        <thead class="text-gray-500 bg-gray-50 border-b">
                            <tr>
                                <th class="px-6 py-3 font-medium">Barang</th>
                                <th class="px-6 py-3 font-medium">Peminjam</th>
                                <th class="px-6 py-3 font-medium">Tanggal</th>
                                <th class="px-6 py-3 font-medium">Total</th>
                                <th class="px-6 py-3 font-medium">Status</th>
                                <th class="px-6 py-3 font-medium text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> booking : myBookings) { 
                                String st = (String) booking.get("status");
                                String badgeCls = "bg-gray-100 text-gray-800";
                                String label = st;
                                if (st.equals("PENDING")) { badgeCls = "bg-yellow-50 text-yellow-700"; label = "Menunggu"; }
                                else if (st.equals("APPROVED") || st.equals("ONGOING")) { badgeCls = "bg-blue-50 text-blue-700"; label = "Berjalan"; }
                                else if (st.equals("COMPLETED")) { badgeCls = "bg-green-50 text-green-700"; label = "Selesai"; }
                            %>
                            <tr class="border-b hover:bg-gray-50">
                                <td class="px-6 py-4 font-medium"><%= booking.get("itemTitle") %></td>
                                <td class="px-6 py-4"><%= booking.get("borrowerName") %></td>
                                <td class="px-6 py-4 text-xs text-gray-500"><%= booking.get("startDate") %> - <%= booking.get("endDate") %></td>
                                <td class="px-6 py-4"><%= rpFormat.format(booking.get("totalPrice")) %></td>
                                <td class="px-6 py-4">
                                    <span class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold <%= badgeCls %>">
                                        <%= label %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <% if (st.equals("APPROVED") || st.equals("ONGOING")) { %>
                                        <form action="BookingServlet" method="POST">
                                            <input type="hidden" name="action" value="complete">
                                            <input type="hidden" name="bookingId" value="<%= booking.get("id") %>">
                                            <button type="submit" class="text-xs border px-2 py-1 rounded hover:bg-gray-100">Tandai Selesai</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- BARANG SAYA - INI YANG PENTING 🔥 -->
        <div id="content-items" class="tab-content">
            <div class="flex justify-end mb-4">
                <a href="item_form.jsp?action=add" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 bg-primary text-white hover:bg-blue-700 transition-colors shadow-sm">
                    <i data-lucide="plus" class="mr-2 h-4 w-4"></i> Tambah Barang Baru
                </a>
            </div>
            <div class="grid gap-4 md:grid-cols-3">
                <% if (myItems.isEmpty()) { %>
                    <div class="col-span-full text-center py-8 text-gray-500">Belum ada barang terdaftar.</div>
                <% } else { %>
                    <% for (Map<String, Object> item : myItems) { %>
                    <div class="bg-white rounded-lg border border-gray-100 shadow-sm overflow-hidden group">
                        <div class="aspect-video bg-gray-100 relative">
                            <img src="<%= item.get("imageUrl") %>" class="w-full h-full object-cover" />
                            <div class="absolute top-2 right-2 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                <a href="item_form.jsp?action=edit&itemId=<%= item.get("id") %>" class="h-8 w-8 bg-white/90 shadow-sm rounded-md flex items-center justify-center hover:bg-white text-gray-600">
                                    <i data-lucide="edit-2" class="h-4 w-4"></i>
                                </a>
                                <form action="<%= request.getContextPath() %>/barang" method="POST" style="display: inline;" onsubmit="return confirm('Hapus barang ini?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="itemId" value="<%= item.get("id") %>">
                                    <button type="submit" class="h-8 w-8 bg-red-500/90 shadow-sm rounded-md flex items-center justify-center hover:bg-red-600 text-white">
                                        <i data-lucide="trash-2" class="h-4 w-4"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold truncate text-gray-900"><%= item.get("title") %></h3>
                            <div class="flex justify-between mt-2">
                                <span class="text-sm text-gray-500"><%= item.get("category") %></span>
                                <span class="font-bold text-primary"><%= rpFormat.format(item.get("pricePerDay")) %>/hari</span>
                            </div>
                            <div class="mt-3 flex items-center gap-2 text-xs text-gray-400">
                                <i data-lucide="star" class="w-3 h-3 text-yellow-400 fill-current"></i>
                                <span><%= item.get("rating") %> (<%= item.get("reviewCount") %> ulasan)</span>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    lucide.createIcons();

    // Tab switching - lebih robust
    function switchTab(tabName) {
        // Sembunyikan semua content
        document.querySelectorAll('.tab-content').forEach(el => {
            el.classList.remove('active');
        });
        
        // Tampilkan content yang dipilih
        document.getElementById('content-' + tabName).classList.add('active');
        
        // Update tab button styles
        document.querySelectorAll('[id^="tab-"]').forEach(btn => {
            btn.classList.remove('tab-active');
            btn.classList.add('tab-inactive');
        });
        
        const activeBtn = document.getElementById('tab-' + tabName);
        activeBtn.classList.add('tab-active');
        activeBtn.classList.remove('tab-inactive');
    }

    // Profile dropdown toggle
    function toggleProfile() {
        const dropdown = document.getElementById('profileDropdown');
        dropdown.classList.toggle('hidden');
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const profileBtn = event.target.closest('button');
        const dropdown = document.getElementById('profileDropdown');
        
        if (!profileBtn && !dropdown.contains(event.target)) {
            dropdown.classList.add('hidden');
        }
    });
</script>

</body>
</html>