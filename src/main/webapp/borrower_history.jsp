<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat"%>

<%
    // --- 1. SIMULASI DATA BACKEND ---
    
    // User Session
    String currentUserId = "user-123";
    String userName = "John Doe";
    String userEmail = "john@example.com";

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // List Booking
    List<Map<String, Object>> bookings = new ArrayList<>();
    Map<String, Object> b;

    // Data 1: Selesai (Ada tombol Ulasan)
    b = new HashMap<>();
    b.put("id", "B-001");
    b.put("borrowerId", "user-123");
    b.put("itemTitle", "Set Bor Tanpa Kabel DeWalt");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&q=80&w=1000");
    b.put("status", "COMPLETED"); // Selesai
    b.put("startDate", "2023-11-01");
    b.put("endDate", "2023-11-03");
    b.put("requestDate", "2023-10-28");
    b.put("totalPrice", 450000.0);
    bookings.add(b);

    // Data 2: Menunggu
    b = new HashMap<>();
    b.put("id", "B-002");
    b.put("borrowerId", "user-123");
    b.put("itemTitle", "Kamera Mirrorless Sony Alpha a7 III");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=1000");
    b.put("status", "PENDING"); // Menunggu
    b.put("startDate", "2023-12-10");
    b.put("endDate", "2023-12-12");
    b.put("requestDate", "2023-12-05");
    b.put("totalPrice", 900000.0);
    bookings.add(b);

    // Data 3: Menunggu (Lagi)
    b = new HashMap<>();
    b.put("id", "B-003");
    b.put("borrowerId", "user-123");
    b.put("itemTitle", "Kamera Mirrorless Sony Alpha a7 III");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=1000");
    b.put("status", "PENDING");
    b.put("startDate", "2025-12-12");
    b.put("endDate", "2025-12-15");
    b.put("requestDate", "2025-12-12");
    b.put("totalPrice", 1350000.0);
    bookings.add(b);
    
    // Data 4: Menunggu (Tenda)
     b = new HashMap<>();
    b.put("id", "B-004");
    b.put("borrowerId", "user-123");
    b.put("itemTitle", "Tenda Kemah 4 Orang");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&q=80&w=1000");
    b.put("status", "PENDING");
    b.put("startDate", "2025-12-12");
    b.put("endDate", "2025-12-15");
    b.put("requestDate", "2025-12-12");
    b.put("totalPrice", 600000.0);
    bookings.add(b);
    
    // Filter booking berdasarkan User ID
    List<Map<String, Object>> myBookings = new ArrayList<>();
    for(Map<String, Object> booking : bookings) {
        if(booking.get("borrowerId").equals(currentUserId)) {
            myBookings.add(booking);
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pesanan Saya - PinjamAja</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
        
        <link rel="stylesheet" href="css/style.css">

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
    </head>
    <body class="bg-[#F6F7FB] text-slate-800 font-sans min-h-screen">
        
        <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
            <div class="container mx-auto px-4 h-16 flex items-center justify-between">
                <a href="landing.jsp" class="flex items-center gap-2 group">
                    <div class="bg-primary text-white p-1.5 rounded-lg">
                         <i data-lucide="hexagon" class="w-5 h-5 fill-current"></i>
                    </div>
                    <span class="text-xl font-bold text-primary tracking-tight">PinjamAja</span>
                </a>

                <div class="flex items-center gap-6">
                    <a href="borrower_dashboard.jsp" class="text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors">
                        Jelajahi Barang
                    </a>
                    <a href="borrower_history.jsp" class="text-sm font-semibold text-gray-900 border-b-2 border-primary py-5">
                        Pesanan Saya
                    </a>
                    
                    <div class="relative ml-2">
                        <button onclick="toggleProfile()" class="w-9 h-9 rounded-full bg-blue-100 flex items-center justify-center text-primary hover:ring-2 hover:ring-primary/20 transition-all focus:outline-none">
                            <i data-lucide="user" class="w-5 h-5"></i>
                        </button>

                        <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-100 py-2 animate-in fade-in zoom-in-95 duration-100 origin-top-right z-50">
                            <div class="px-4 py-3 border-b border-gray-100 mb-2">
                                <p class="text-sm font-bold text-gray-900"><%= userName %></p>
                                <p class="text-xs text-gray-500 truncate"><%= userEmail %></p>
                            </div>
                            
                            <a href="index.jsp" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors cursor-pointer w-full text-left">
                                <i data-lucide="log-out" class="w-4 h-4"></i>
                                Keluar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container mx-auto px-4 py-8 max-w-5xl">
            <h1 class="text-2xl font-bold text-gray-900 mb-6">Pesanan Saya</h1>
            
            <div class="space-y-4">
                
                <%-- LOOPING DATA BOOKING --%>
                <% for(Map<String, Object> booking : myBookings) { 
                    String status = (String) booking.get("status");
                    String statusLabel = status;
                    // Default Style Badge
                    String badgeClass = "bg-gray-100 text-gray-600 border-gray-200"; 
                    
                    if(status.equals("APPROVED")) {
                        statusLabel = "Disetujui";
                        badgeClass = "bg-green-100 text-green-700 border-green-200";
                    } else if(status.equals("COMPLETED")) {
                        statusLabel = "Selesai";
                        badgeClass = "bg-gray-100 text-gray-600 border-gray-200"; // Style 'Selesai' di gambar Anda abu-abu
                    } else if(status.equals("PENDING")) {
                        statusLabel = "Menunggu";
                        badgeClass = "bg-white text-yellow-600 border border-yellow-200"; // Style 'Menunggu' outline kuning
                    }
                %>
                
                <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm hover:shadow-md transition-all">
                    <div class="flex flex-col md:flex-row">
                        
                        <div class="w-full md:w-64 h-48 md:h-auto relative shrink-0">
                            <img src="<%= booking.get("itemImageUrl") %>" alt="<%= booking.get("itemTitle") %>" class="w-full h-full object-cover" />
                        </div>
                        
                        <div class="flex-1 p-6 flex flex-col justify-between">
                            
                            <div class="flex justify-between items-start mb-2">
                                <h3 class="text-lg font-bold text-gray-900"><%= booking.get("itemTitle") %></h3>
                                <span class="inline-flex items-center px-3 py-1 rounded-full border text-xs font-semibold <%= badgeClass %>">
                                    <%= statusLabel %>
                                </span>
                            </div>
                            
                            <div class="flex flex-wrap gap-x-6 gap-y-2 text-sm text-gray-500 mb-4">
                                <div class="flex items-center gap-1.5">
                                    <i data-lucide="calendar-days" class="w-4 h-4 text-gray-400"></i>
                                    <span><%= booking.get("startDate") %> - <%= booking.get("endDate") %></span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <i data-lucide="clock" class="w-4 h-4 text-gray-400"></i>
                                    <span>Diminta pada <%= booking.get("requestDate") %></span>
                                </div>
                            </div>
                            
                            <div class="flex justify-between items-center mt-2">
                                <p class="font-bold text-primary text-lg"><%= rpFormat.format(booking.get("totalPrice")) %></p>
                                
                                <% if(status.equals("COMPLETED")) { %>
                                    <button onclick="openReviewModal('<%= booking.get("itemTitle") %>')" class="inline-flex items-center justify-center rounded-lg text-sm font-medium border border-gray-300 bg-white hover:bg-gray-50 h-9 px-4 gap-2 transition-colors">
                                        <i data-lucide="star" class="w-4 h-4"></i> Berikan Ulasan
                                    </button>
                                <% } %>
                            </div>
                            
                        </div>
                    </div>
                </div>
                <% } %>

                <% if(myBookings.isEmpty()) { %>
                    <div class="text-center py-12 bg-white rounded-lg border border-dashed border-gray-300">
                        <p class="text-gray-500 mb-2">Anda belum menyewa barang apapun.</p>
                        <a href="borrower_dashboard.jsp" class="text-primary hover:underline font-medium">Jelajahi Katalog</a>
                    </div>
                <% } %>
                
            </div>
        </div>

        <div id="reviewModal" class="fixed inset-0 z-[60] hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 animate-in fade-in duration-200">
            <div class="bg-white w-full max-w-lg rounded-xl shadow-lg border p-6 relative">
                <div class="flex flex-col space-y-1.5 text-center sm:text-left mb-4">
                    <h2 class="text-lg font-semibold leading-none tracking-tight">Ulas pengalaman Anda</h2>
                    <p class="text-sm text-gray-500">Bagaimana barang <span id="reviewItemTitle" class="font-bold"></span> dan pemiliknya?</p>
                </div>
                <div class="grid gap-4 py-4">
                    <div class="flex justify-center gap-2" id="starContainer">
                        <i data-lucide="star" class="w-8 h-8 text-gray-300 cursor-pointer fill-current hover:text-yellow-400 transition-colors" onclick="setRating(1)"></i>
                        <i data-lucide="star" class="w-8 h-8 text-gray-300 cursor-pointer fill-current hover:text-yellow-400 transition-colors" onclick="setRating(2)"></i>
                        <i data-lucide="star" class="w-8 h-8 text-gray-300 cursor-pointer fill-current hover:text-yellow-400 transition-colors" onclick="setRating(3)"></i>
                        <i data-lucide="star" class="w-8 h-8 text-gray-300 cursor-pointer fill-current hover:text-yellow-400 transition-colors" onclick="setRating(4)"></i>
                        <i data-lucide="star" class="w-8 h-8 text-gray-300 cursor-pointer fill-current hover:text-yellow-400 transition-colors" onclick="setRating(5)"></i>
                    </div>
                    <div class="grid gap-2">
                        <label class="text-sm font-medium leading-none">Komentar</label>
                        <textarea class="flex min-h-[100px] w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Bagikan pengalaman Anda..."></textarea>
                    </div>
                </div>
                <div class="flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 gap-2">
                    <button onclick="closeReviewModal()" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 border border-gray-200 bg-white hover:bg-gray-100">Batal</button>
                    <button onclick="submitReview()" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 bg-primary text-white hover:bg-blue-700">Kirim Ulasan</button>
                </div>
            </div>
        </div>

        <script>
            lucide.createIcons();

            function toggleProfile() {
                const dropdown = document.getElementById('profileDropdown');
                dropdown.classList.toggle('hidden');
            }

            window.addEventListener('click', function(e) {
                const btn = document.querySelector('button[onclick="toggleProfile()"]');
                const dropdown = document.getElementById('profileDropdown');
                if (!btn.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.add('hidden');
                }
            });

            let currentRating = 0;
            function openReviewModal(itemTitle) {
                document.getElementById('reviewItemTitle').innerText = itemTitle;
                document.getElementById('reviewModal').classList.remove('hidden');
                resetStars();
            }
            function closeReviewModal() {
                document.getElementById('reviewModal').classList.add('hidden');
            }
            function setRating(rating) {
                currentRating = rating;
                const stars = document.getElementById('starContainer').children;
                for (let i = 0; i < stars.length; i++) {
                    if (i < rating) {
                        stars[i].classList.remove('text-gray-300');
                        stars[i].classList.add('text-yellow-400');
                    } else {
                        stars[i].classList.remove('text-yellow-400');
                        stars[i].classList.add('text-gray-300');
                    }
                }
            }
            function resetStars() {
                setRating(0);
            }
            function submitReview() {
                alert("Terima kasih! Ulasan Anda telah dikirim.");
                closeReviewModal();
            }
        </script>
        <footer class="bg-white border-t border-gray-200 pt-16 pb-8 mt-auto">
            <div class="container mx-auto px-4">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-8 mb-12">
                    
                    <div class="space-y-4">
                        <div class="flex items-center gap-2">
                            <div class="bg-primary text-white p-1.5 rounded-lg">
                                 <i data-lucide="hexagon" class="w-5 h-5 fill-current"></i>
                            </div>
                            <span class="text-xl font-bold text-primary tracking-tight">PinjamAja</span>
                        </div>
                        <p class="text-gray-500 text-sm leading-relaxed">
                            Menghubungkan orang yang memiliki dengan orang yang membutuhkan. Cara paling aman untuk menyewa dan meminjam barang di komunitas Anda.
                        </p>
                    </div>

                    <div>
                        <h3 class="font-bold text-gray-900 mb-4">Platform</h3>
                        <ul class="space-y-3 text-sm text-gray-600">
                            <li><a href="info.jsp?page=how-it-works" class="hover:text-primary transition-colors">Cara Kerja</a></li>
                            <li><a href="info.jsp?page=trust" class="hover:text-primary transition-colors">Kepercayaan & Keamanan</a></li>
                            <li><a href="info.jsp?page=insurance" class="hover:text-primary transition-colors">Asuransi</a></li>
                        </ul>
                    </div>

                    <div>
                        <h3 class="font-bold text-gray-900 mb-4">Perusahaan</h3>
                        <ul class="space-y-3 text-sm text-gray-600">
                            <li><a href="info.jsp?page=about" class="hover:text-primary transition-colors">Tentang Kami</a></li>
                            <li><a href="info.jsp?page=careers" class="hover:text-primary transition-colors">Karir</a></li>
                            <li><a href="info.jsp?page=contact" class="hover:text-primary transition-colors">Kontak</a></li>
                        </ul>
                    </div>

                    <div>
                        <h3 class="font-bold text-gray-900 mb-4">Legal</h3>
                        <ul class="space-y-3 text-sm text-gray-600">
                            <li><a href="info.jsp?page=terms" class="hover:text-primary transition-colors">Syarat Layanan</a></li>
                            <li><a href="info.jsp?page=privacy" class="hover:text-primary transition-colors">Kebijakan Privasi</a></li>
                            <li><a href="info.jsp?page=cookies" class="hover:text-primary transition-colors">Kebijakan Cookie</a></li>
                        </ul>
                    </div>
                </div>
                
                <div class="border-t border-gray-200 pt-8 text-center text-sm text-gray-400">
                    &copy; 2025 PinjamAja. Hak Cipta Dilindungi.
                </div>
            </div>
        </footer>
    </body>
</html>