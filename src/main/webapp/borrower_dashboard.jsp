<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat, com.pinjamaja.dao.*"%>

<%
    // === 1. VALIDASI SESSION BORROWER ===
    String currentUserId = (String) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    
    if (currentUserId == null || !"BORROWER".equals(userRole)) {
        response.sendRedirect("auth.jsp?error=not_borrower");
        return;
    }

    // === 2. FETCH SEMUA BARANG ===
    BarangDAO barangDAO = new BarangDAO();
    List<Map<String, Object>> items;
    try {
        items = barangDAO.getAllBarang();
    } catch (Exception e) {
        items = new ArrayList<>();
    }
    
    // === 3. KATEGORI & FORMAT ===
    Set<String> categories = new HashSet<>();
    for (Map<String, Object> item : items) {
        categories.add((String) item.get("category"));
    }
    
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Jelajahi Barang - PinjamAja</title>
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
        };
    </script>
</head>
<body class="bg-white text-slate-800 font-sans min-h-screen">
    
    <!-- NAVIGASI -->
    <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
        <div class="container mx-auto px-4 h-16 flex items-center justify-between">
            <a href="landing.jsp" class="flex items-center gap-2">
                <div class="bg-primary text-white p-1.5 rounded-lg">
                     <i data-lucide="hexagon" class="w-5 h-5 fill-current"></i>
                </div>
                <span class="text-xl font-bold text-primary">PinjamAja</span>
            </a>

            <div class="flex items-center gap-6">
                <a href="borrower_dashboard.jsp" class="text-sm font-semibold text-gray-900 border-b-2 border-primary py-5">Jelajahi Barang</a>
                <a href="borrower_history.jsp" class="text-sm font-medium text-gray-500 hover:text-gray-900">Pesanan Saya</a>
                <div class="relative">
                    <button onclick="toggleProfile()" class="w-9 h-9 rounded-full bg-blue-100 flex items-center justify-center text-primary">
                        <i data-lucide="user" class="w-5 h-5"></i>
                    </button>
                    <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border py-2">
                        <div class="px-4 py-3 border-b">
                            <p class="text-sm font-bold"><%= userName %></p>
                            <p class="text-xs text-gray-500">Borrower - PinjamAja</p>
                        </div>
                        <form action="LogoutServlet" method="POST" class="px-4 py-2">
                            <button type="submit" class="flex items-center gap-2 text-sm text-red-600 hover:bg-red-50 w-full text-left p-2 rounded">
                                <i data-lucide="log-out" class="w-4 h-4"></i>Keluar
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-4 py-8">
        
        <!-- HEADER & SEARCH -->
        <div class="flex flex-col md:flex-row gap-4 mb-8 items-end justify-between">
            <div>
                <h1 class="text-2xl font-bold mb-1">Jelajahi Barang</h1>
                <p class="text-gray-500 text-sm">Temukan yang Anda butuhkan.</p>
            </div>
            <div class="max-w-md w-full">
                <div class="relative">
                    <i data-lucide="search" class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400"></i>
                    <input type="text" id="searchInput" onkeyup="filterItems()" placeholder="Cari kamera, perkakas, sepeda..." 
                           class="w-full pl-9 h-11 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-primary text-sm bg-gray-50 focus:bg-white">
                </div>
            </div>
        </div>

        <!-- KATEGORI FILTER -->
        <div class="flex gap-3 overflow-x-auto pb-4 mb-6">
            <button onclick="filterByCategory('all')" class="category-btn px-4 py-2 bg-primary text-white rounded-full text-sm font-medium">Semua</button>
            <% for (String cat : categories) { %>
            <button onclick="filterByCategory('<%= cat %>')" class="category-btn px-4 py-2 bg-gray-100 text-gray-700 hover:bg-blue-50 hover:text-primary rounded-full text-sm font-medium transition-colors"><%= cat %></button>
            <% } %>
        </div>

        <!-- GRID BARANG -->
        <div id="itemsGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <% if (items.isEmpty()) { %>
                <div class="col-span-full text-center py-16">
                    <i data-lucide="package" class="w-12 h-12 text-gray-300 mx-auto mb-4"></i>
                    <p class="text-gray-500">Belum ada barang tersedia.</p>
                </div>
            <% } else { %>
                <% for (Map<String, Object> item : items) { %>
                <div class="item-card group bg-white border border-gray-100 rounded-xl shadow-sm hover:shadow-lg transition-all overflow-hidden flex flex-col h-full"
                     data-title="<%= item.get("title") %>"
                     data-category="<%= item.get("category") %>"
                     data-price="<%= ((Double)item.get("pricePerDay")).intValue() %>"
                     data-image="<%= item.get("imageUrl") %>"
                     data-desc="<%= item.get("description") %>"
                     data-owner="<%= item.get("ownerName") %>"
                     data-rating="<%= item.get("rating") %>"
                     data-reviews="<%= item.get("reviewCount") %>"
                     data-itemid="<%= item.get("id") %>">
                    
                    <div class="aspect-[4/3] overflow-hidden relative bg-gray-200">
                        <img src="<%= item.get("imageUrl") %>" alt="<%= item.get("title") %>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute top-3 left-3 bg-black/60 text-white px-2 py-1 rounded-md text-[10px] uppercase tracking-wide font-medium">
                            <%= item.get("category") %>
                        </div>
                        <div class="absolute top-3 right-3 bg-white/95 text-primary px-2 py-1 rounded-md text-xs font-bold shadow-sm">
                            <%= rpFormat.format(item.get("pricePerDay")) %>/hari
                        </div>
                    </div>
                    
                    <div class="p-4 flex flex-col flex-grow">
                        <h3 class="font-bold text-gray-900 line-clamp-1 mb-2 text-base"><%= item.get("title") %></h3>
                        <span class="text-gray-900 line-clamp-1 mb-2 text-base"><%= item.get("description") %></span>
                        
                        <div class="flex items-center gap-1 text-yellow-500 text-xs mb-4">
                            <i data-lucide="star" class="w-3 h-3 fill-current"></i>
                            <span class="font-bold text-gray-900"><%= item.get("rating") %></span>
                            <span class="text-gray-400 font-normal">(<%= item.get("reviewCount") %>)</span>
                        </div>
                        
                        <!-- 🔥 TOMBOL SEWA & KERANJANG 🔥 -->
                        <div class="flex gap-2 mt-auto pt-3 border-t border-gray-50">
                            <button onclick="openBookingModal('<%= item.get("id") %>', <%= item.get("pricePerDay") %>)" 
                                    class="flex-1 py-2 bg-accent text-primary font-bold rounded-md hover:bg-accentHover transition-colors text-sm">
                                <i data-lucide="shopping-cart" class="w-4 h-4 inline mr-1"></i>Sewa
                            </button>
                            <button onclick="addToCart('<%= item.get("id") %>')" 
                                    class="px-3 py-2 border border-gray-300 rounded-md hover:bg-gray-50 transition-colors text-sm">
                                <i data-lucide="plus" class="w-4 h-4"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>
        
        <div id="emptyState" class="hidden text-center py-16">
            <i data-lucide="search-x" class="w-12 h-12 text-gray-300 mx-auto mb-4"></i>
            <p class="text-gray-500 text-lg">Tidak ada barang yang cocok.</p>
        </div>
    </div>
        <!<!-- booking modal -->
    <div id="bookingModal" class="fixed inset-0 z-[100] hidden bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white w-full max-w-4xl rounded-2xl shadow-2xl overflow-hidden flex flex-col md:flex-row max-h-[90vh]">
            <div class="w-full md:w-1/2 p-6 md:p-8 flex flex-col overflow-y-auto">
                <div class="mb-6">
                    <h3 class="text-2xl font-bold text-gray-800">Formulir Sewa</h3>
                    <p class="text-gray-500 text-sm">Lengkapi tanggal peminjaman Anda.</p>
                </div>

                <form action="booking" method="POST" class="flex flex-col h-full">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="itemId" id="modalItemId">
                    <input type="hidden" name="pricePerDay" id="modalPricePerDay">
                    
                    <div class="space-y-5 flex-1">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Mulai</label>
                            <input type="date" name="startDate" id="modalStartDate" required 
                                   class="w-full h-11 rounded-lg border border-gray-300 px-3 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-all"
                                   onchange="updateEndDateMin(); calculatePrice()">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label>
                            <input type="date" name="endDate" id="modalEndDate" required 
                                   class="w-full h-11 rounded-lg border border-gray-300 px-3 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-all"
                                   onchange="calculatePrice()">
                        </div>

                        <div class="bg-blue-50 p-4 rounded-xl border border-blue-100 mt-4">
                            <div class="flex justify-between text-sm mb-2">
                                <span class="text-gray-600">Durasi:</span>
                                <span class="font-bold text-gray-800" id="rentalDays">0 hari</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="flex gap-3 mt-8 pt-4 border-t border-gray-100">
                        <button type="button" onclick="closeBookingModal()" class="flex-1 px-4 py-3 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-colors">
                            Batal
                        </button>
                        <button type="submit" class="flex-1 px-4 py-3 bg-accent text-primary font-bold rounded-lg hover:bg-yellow-400 transition-colors shadow-sm">
                            Ajukan Sewa
                        </button>
                    </div>
                </form>
            </div>
    </div>

    <script>
        lucide.createIcons();
        
        // KATEGORI FILTER
        function filterByCategory(category) {
            const cards = document.querySelectorAll('.item-card');
            let hasVisible = false;
            
            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (category === 'all' || cardCategory === category) {
                    card.style.display = 'flex';
                    hasVisible = true;
                } else {
                    card.style.display = 'none';
                }
            });
            
            document.getElementById('emptyState').classList.toggle('hidden', hasVisible);
            
            document.querySelectorAll('.category-btn').forEach(btn => {
                btn.classList.remove('bg-primary', 'text-white');
                btn.classList.add('bg-gray-100', 'text-gray-700');
            });
            event.target.classList.add('bg-primary', 'text-white');
            event.target.classList.remove('bg-gray-100', 'text-gray-700');
        }
        
        // SEARCH FILTER
        function filterItems() {
            const search = document.getElementById('searchInput').value.toLowerCase();
            const cards = document.querySelectorAll('.item-card');
            let hasVisible = false;
            
            cards.forEach(card => {
                const title = card.getAttribute('data-title').toLowerCase();
                if (title.includes(search)) {
                    card.style.display = 'flex';
                    hasVisible = true;
                } else {
                    card.style.display = 'none';
                }
            });
            
            document.getElementById('emptyState').classList.toggle('hidden', hasVisible);
        }
        
        // PROFILE DROPDOWN
        function toggleProfile() {
            document.getElementById('profileDropdown').classList.toggle('hidden');
        }
        
        window.addEventListener('click', function(e) {
            const btn = document.querySelector('button[onclick="toggleProfile()"]');
            const dropdown = document.getElementById('profileDropdown');
            if (!btn.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.add('hidden');
            }
        });
        
        // BOOKING MODAL
        function openBookingModal(itemId, pricePerDay, ) {
            document.getElementById('modalItemId').value = itemId;
            document.getElementById('modalPricePerDay').value = pricePerDay;
            document.getElementById('bookingModal').classList.remove('hidden');
        }
        
        function closeBookingModal() {
            document.getElementById('bookingModal').classList.add('hidden');
        }
        
        // KERANJANG (placeholder)
        function addToCart(itemId) {
            alert('Barang ditambahkan ke keranjang (fitur akan segera tersedia)!');
        }
    </script>
</body>
</html>