<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat, com.pinjamaja.dao.*"%>

<%
    // === 1. VALIDASI SESSION BORROWER ===
    String currentUserId = (String) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userRole = (String) session.getAttribute("userRole");
    
    if (currentUserId == null || !"BORROWER".equals(userRole)) {
        response.sendRedirect("auth.jsp?error=not_borrower");
        return;
    }

    // === 2. AMBIL DATA BOOKING DARI DATABASE ===
    BookingDAO bookingDAO = new BookingDAO();
    List<Map<String, Object>> myBookings;
    try {
        myBookings = bookingDAO.getBookingsByBorrower(currentUserId);
        System.out.println("DEBUG: borrower_history.jsp loaded " + myBookings.size() + " bookings for user " + currentUserId);
    } catch (Exception e) {
        System.out.println("ERROR: " + e.getMessage());
        e.printStackTrace();
        myBookings = new ArrayList<>();
    }
    
    // === 3. FORMAT RUPIAH ===
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Pesanan Saya - PinjamAja</title>
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

                    <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-100 py-2 z-50">
                        <div class="px-4 py-3 border-b border-gray-100 mb-2">
                            <p class="text-sm font-bold text-gray-900"><%= userName %></p>
                            <p class="text-xs text-gray-500 truncate"><%= userEmail %></p>
                        </div>
                        <form action="LogoutServlet" method="POST" class="px-4 py-2">
                            <button type="submit" class="flex items-center gap-2 text-sm text-red-600 hover:bg-red-50 transition-colors w-full text-left p-2 rounded">
                                <i data-lucide="log-out" class="w-4 h-4"></i>
                                Keluar
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-4 py-8 max-w-5xl">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">Pesanan Saya</h1>
        
        <% if (myBookings.isEmpty()) { %>
            <div class="bg-white rounded-lg border border-dashed border-gray-300 p-12 text-center">
                <i data-lucide="package" class="w-12 h-12 text-gray-300 mx-auto mb-4"></i>
                <p class="text-gray-500">Anda belum menyewa barang apapun.</p>
                <a href="borrower_dashboard.jsp" class="text-primary hover:underline font-medium mt-2 inline-block">Jelajahi Katalog</a>
            </div>
        <% } else { %>
            <div class="grid gap-4">
                <% for (Map<String, Object> booking : myBookings) { 
                    String status = (String) booking.get("status");
                    String statusLabel = status;
                    String badgeClass = "bg-gray-100 text-gray-600 border-gray-200";
                    
                    if("APPROVED".equals(status)) {
                        statusLabel = "Disetujui";
                        badgeClass = "bg-green-100 text-green-700 border-green-200";
                    } else if("COMPLETED".equals(status)) {
                        statusLabel = "Selesai";
                    } else if("PENDING".equals(status)) {
                        statusLabel = "Menunggu";
                        badgeClass = "bg-white text-yellow-600 border border-yellow-200";
                    } else if("REJECTED".equals(status)) {
                        statusLabel = "Ditolak";
                        badgeClass = "bg-red-100 text-red-700 border-red-200";
                    }
                %>
                
                <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm hover:shadow-md transition-all">
                    <div class="flex flex-col md:flex-row">
                        <div class="w-full md:w-64 h-48 md:h-auto relative shrink-0">
                            <img src="<%= booking.get("itemImageUrl") %>" alt="<%= booking.get("itemTitle") %>" class="w-full h-full object-cover">
                        </div>
                        
                        <div class="flex-1 p-6 flex flex-col justify-between">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <h3 class="text-lg font-bold text-gray-900"><%= booking.get("itemTitle") %></h3>
                                    <p class="text-sm text-gray-500">Pemilik: <%= booking.get("ownerName") %></p>
                                </div>
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
                                
                                <% if("COMPLETED".equals(status)) { %>
                                    <button onclick="openReviewModal('<%= booking.get("itemTitle") %>')" class="inline-flex items-center justify-center rounded-lg text-sm font-medium border border-gray-300 bg-white hover:bg-gray-50 h-9 px-4 gap-2 transition-colors">
                                        <i data-lucide="star" class="w-4 h-4"></i> Berikan Ulasan
                                    </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
    
    <!-- REVIEW MODAL -->
    <div id="reviewModal" class="fixed inset-0 z-[60] hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
        <div class="bg-white w-full max-w-lg rounded-xl shadow-lg border p-6 relative">
            <div class="flex flex-col space-y-1.5 text-center sm:text-left mb-4">
                <h2 class="text-lg font-semibold">Ulas pengalaman Anda</h2>
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
                    <label class="text-sm font-medium">Komentar</label>
                    <textarea class="w-full min-h-[100px] rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Bagikan pengalaman Anda..."></textarea>
                </div>
            </div>
            <div class="flex flex-col-reverse sm:flex-row sm:justify-end gap-2">
                <button onclick="closeReviewModal()" class="px-4 py-2 border rounded-md hover:bg-gray-50">Batal</button>
                <button onclick="submitReview()" class="px-4 py-2 bg-primary text-white rounded-md hover:bg-blue-700">Kirim Ulasan</button>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();
        
        let currentRating = 0;
        
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
        
        function openReviewModal(itemTitle) {
            document.getElementById('reviewItemTitle').innerText = itemTitle;
            document.getElementById('reviewModal').classList.remove('hidden');
            setRating(0);
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
        
        function submitReview() {
            alert("Terima kasih! Ulasan Anda telah dikirim.");
            closeReviewModal();
        }
    </script>
</body>
</html>