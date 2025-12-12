<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat"%>

<%
    // --- DATA SIMULASI (BACKEND) ---
    // User Session Mockup
    String userName = "John Doe";
    String userEmail = "john@example.com";

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // List Barang (Menggunakan Map agar stabil di NetBeans)
    List<Map<String, Object>> items = new ArrayList<>();
    Map<String, Object> m;

    // Item 1
    m = new HashMap<>();
    m.put("title", "Kamera Mirrorless Sony Alpha a7 III");
    m.put("category", "Elektronik");
    m.put("imageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=1000");
    m.put("description", "Kamera full frame mirrorless kondisi prima, sensor bersih.");
    m.put("ownerName", "Sarah J.");
    m.put("pricePerDay", 450000.0);
    m.put("rating", 4.8);
    m.put("reviewCount", 12);
    items.add(m);

    // Item 2
    m = new HashMap<>();
    m.put("title", "Set Bor Tanpa Kabel DeWalt");
    m.put("category", "Perkakas");
    m.put("imageUrl", "https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&q=80&w=1000");
    m.put("description", "Bor tangan cordless, baterai tahan lama + set mata bor.");
    m.put("ownerName", "Sarah J.");
    m.put("pricePerDay", 150000.0);
    m.put("rating", 4.9);
    m.put("reviewCount", 28);
    items.add(m);

    // Item 3
    m = new HashMap<>();
    m.put("title", "Tenda Kemah 4 Orang");
    m.put("category", "Outdoor");
    m.put("imageUrl", "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&q=80&w=1000");
    m.put("description", "Tenda dome waterproof double layer, mudah dipasang.");
    m.put("ownerName", "Mike T.");
    m.put("pricePerDay", 200000.0);
    m.put("rating", 4.5);
    m.put("reviewCount", 8);
    items.add(m);

    // Item 4
    m = new HashMap<>();
    m.put("title", "Sepeda Balap - Trek Domane");
    m.put("category", "Olahraga");
    m.put("imageUrl", "https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&q=80&w=1000");
    m.put("description", "Sepeda balap ringan, cocok untuk touring jarak jauh.");
    m.put("ownerName", "Mike T.");
    m.put("pricePerDay", 350000.0);
    m.put("rating", 5.0);
    m.put("reviewCount", 5);
    items.add(m);
    
    // Set Categories for Filter
    Set<String> categories = new HashSet<>();
    for(Map<String, Object> item : items) {
        categories.add((String)item.get("category"));
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Jelajahi Barang - PinjamAja</title>
        
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
    <body class="bg-white text-slate-800 font-sans min-h-screen">
        
        <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
            <div class="container mx-auto px-4 h-16 flex items-center justify-between">
                <a href="landing.jsp" class="flex items-center gap-2 group">
                    <div class="bg-primary text-white p-1.5 rounded-lg">
                         <i data-lucide="hexagon" class="w-5 h-5 fill-current"></i>
                    </div>
                    <span class="text-xl font-bold text-primary tracking-tight">PinjamAja</span>
                </a>

                <div class="flex items-center gap-6">
                    <a href="borrower_dashboard.jsp" class="text-sm font-semibold text-gray-900 border-b-2 border-primary py-5">
                        Jelajahi Barang
                    </a>
                    <a href="borrower_history.jsp" class="text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors">
                        Pesanan Saya
                    </a>
                    
                    <div class="relative ml-2">
                        <button onclick="toggleProfile()" class="w-9 h-9 rounded-full bg-blue-100 flex items-center justify-center text-primary hover:ring-2 hover:ring-primary/20 transition-all focus:outline-none">
                            <i data-lucide="user" class="w-5 h-5"></i>
                        </button>

                        <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-100 py-2 animate-in fade-in zoom-in-95 duration-100 origin-top-right">
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

        <div class="container mx-auto px-4 py-8">
            
            <div class="flex flex-col md:flex-row gap-4 mb-8 items-end justify-between">
                <div class="max-w-xl">
                    <h1 class="text-2xl font-bold text-gray-900 mb-1">Jelajahi Barang</h1>
                    <p class="text-gray-500 text-sm">Temukan yang Anda butuhkan untuk proyek atau petualangan berikutnya.</p>
                </div>
                
                <div class="flex-1 max-w-md w-full">
                    <div class="relative">
                        <i data-lucide="search" class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400"></i>
                        <input type="text" id="searchInput" onkeyup="filterItems()" 
                               placeholder="Cari kamera, perkakas, sepeda..." 
                               class="w-full pl-9 h-11 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-primary text-sm shadow-sm bg-gray-50 focus:bg-white transition-all">
                    </div>
                </div>
            </div>

            <div id="itemsGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <% for(Map<String, Object> item : items) { %>
                <div class="item-card group bg-white border border-gray-100 rounded-xl shadow-sm hover:shadow-lg transition-all duration-300 cursor-pointer overflow-hidden flex flex-col h-full"
                     data-title="<%= item.get("title") %>"
                     data-category="<%= item.get("category") %>"
                     data-price="<%= ((Double)item.get("pricePerDay")).intValue() %>"
                     data-image="<%= item.get("imageUrl") %>"
                     data-desc="<%= item.get("description") %>"
                     data-owner="<%= item.get("ownerName") %>"
                     data-rating="<%= item.get("rating") %>"
                     data-reviews="<%= item.get("reviewCount") %>"
                     onclick="openModal(this)">
                    
                    <div class="aspect-[4/3] overflow-hidden relative bg-gray-200">
                        <img src="<%= item.get("imageUrl") %>" alt="<%= item.get("title") %>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute top-3 left-3 bg-black/60 text-white px-2 py-1 rounded-md text-[10px] uppercase tracking-wide font-medium backdrop-blur-sm">
                            <%= item.get("category") %>
                        </div>
                        <div class="absolute top-3 right-3 bg-white/95 text-primary px-2 py-1 rounded-md text-xs font-bold shadow-sm">
                            <%= rpFormat.format(item.get("pricePerDay")) %>/hari
                        </div>
                    </div>
                    
                    <div class="p-4 flex flex-col flex-grow">
                        <h3 class="font-bold text-gray-900 line-clamp-1 mb-2 text-base"><%= item.get("title") %></h3>
                        
                        <div class="flex items-center gap-1 text-yellow-500 text-xs mb-4">
                            <i data-lucide="star" class="w-3 h-3 fill-current"></i>
                            <span class="font-bold text-gray-900"><%= item.get("rating") %></span>
                            <span class="text-gray-400 font-normal">(<%= item.get("reviewCount") %>)</span>
                        </div>
                        
                        <div class="mt-auto flex items-center gap-2 text-xs text-gray-500 pt-3 border-t border-gray-50">
                            <div class="w-5 h-5 rounded-full bg-gray-100 flex items-center justify-center overflow-hidden">
                                <i data-lucide="user" class="w-3 h-3 text-gray-400"></i>
                            </div>
                            <span><%= item.get("ownerName") %></span>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div id="emptyState" class="hidden text-center py-20">
                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-400">
                    <i data-lucide="search-x" class="w-8 h-8"></i>
                </div>
                <p class="text-gray-500 text-lg">Tidak ada barang ditemukan.</p>
            </div>
        </div>

        <div id="bookingModal" class="fixed inset-0 z-[60] hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white w-full max-w-5xl rounded-xl shadow-2xl overflow-hidden max-h-[90vh] flex flex-col md:flex-row relative animate-in fade-in zoom-in duration-200">
                
                <button onclick="closeModal()" class="absolute top-4 right-4 z-10 bg-white/50 hover:bg-white rounded-full p-1 transition-colors">
                    <i data-lucide="x" class="w-6 h-6 text-gray-600"></i>
                </button>

                <div id="modalSuccess" class="hidden w-full p-12 flex flex-col items-center justify-center text-center space-y-4">
                    <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center text-green-600 mb-2">
                        <i data-lucide="check-circle" class="w-8 h-8"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-gray-900">Permintaan Sewa Terkirim!</h2>
                    <p class="text-gray-500 max-w-md">
                        Permintaan Anda untuk menyewa <span id="successItemTitle" class="font-semibold text-gray-900"></span> telah dikirim.
                    </p>
                    <button onclick="closeModal()" class="mt-4 px-6 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium transition-colors">Kembali Menjelajah</button>
                </div>

                <div id="modalContent" class="flex flex-col md:flex-row w-full h-full overflow-hidden">
                    <div class="md:w-3/5 bg-gray-50 p-6 md:p-8 overflow-y-auto">
                        <div class="rounded-xl overflow-hidden shadow-sm mb-6 bg-white aspect-video">
                            <img id="modalImg" src="" class="w-full h-full object-cover">
                        </div>
                        <div class="space-y-4">
                            <div>
                                <span id="modalCategory" class="inline-block px-2 py-1 rounded border border-primary text-primary text-xs font-medium mb-2"></span>
                                <h2 id="modalTitle" class="text-2xl font-bold text-gray-900"></h2>
                            </div>
                            <div class="flex items-center gap-4 text-sm text-gray-600">
                                <div class="flex items-center gap-1">
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                    <span id="modalRating" class="font-medium text-gray-900"></span>
                                    <span id="modalReviews"></span>
                                </div>
                            </div>
                            <div class="h-px bg-gray-200 w-full my-4"></div>
                            <div>
                                <h3 class="font-semibold mb-2">Deskripsi</h3>
                                <p id="modalDesc" class="text-gray-600 leading-relaxed text-sm"></p>
                            </div>
                            <div>
                                <h3 class="font-semibold mb-3">Pemilik</h3>
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white font-bold" id="modalOwnerInitials"></div>
                                    <div>
                                        <p id="modalOwnerName" class="font-medium text-sm text-gray-900"></p>
                                        <p class="text-xs text-green-600 flex items-center gap-1">
                                            <i data-lucide="check-circle" class="w-3 h-3"></i> Identitas Terverifikasi
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="md:w-2/5 border-l bg-white p-5 md:p-6 flex flex-col justify-between overflow-y-auto">
                        <div>
                            <h3 class="text-xl font-bold mb-4">Sewa barang ini</h3>
                            <div class="space-y-4">
                                <div class="space-y-2">
                                    <label class="text-sm font-medium text-gray-700">Tanggal Mulai</label>
                                    <input type="date" id="startDate" onchange="calculatePrice()" class="w-full p-2 border rounded-md text-sm">
                                </div>
                                <div class="space-y-2">
                                    <label class="text-sm font-medium text-gray-700">Tanggal Selesai</label>
                                    <input type="date" id="endDate" onchange="calculatePrice()" class="w-full p-2 border rounded-md text-sm">
                                </div>

                                <div class="bg-[#F6F7FB] p-4 rounded-lg space-y-2 mt-4">
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-600">Harga Sewa</span>
                                        <span id="calcBasePrice" class="font-medium text-gray-900">Rp 0</span>
                                    </div>
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-600">Biaya Layanan</span>
                                        <span class="font-medium text-gray-900">Rp 5.000</span>
                                    </div>
                                    <div class="h-px bg-gray-200 w-full my-1"></div>
                                    <div class="flex justify-between text-lg font-bold">
                                        <span>Total</span>
                                        <span id="calcTotal" class="text-primary">Rp 0</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-6">
                            <button onclick="submitBooking()" class="w-full py-3 bg-accent hover:bg-accentHover text-primary font-bold rounded-lg transition-colors">
                                Ajukan Sewa
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            lucide.createIcons();
            let currentPricePerDay = 0;

            // --- NAVIGASI DROPDOWN ---
            function toggleProfile() {
                const dropdown = document.getElementById('profileDropdown');
                dropdown.classList.toggle('hidden');
            }

            // Tutup dropdown jika klik di luar
            window.addEventListener('click', function(e) {
                const btn = document.querySelector('button[onclick="toggleProfile()"]');
                const dropdown = document.getElementById('profileDropdown');
                if (!btn.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.add('hidden');
                }
            });

            // --- FILTER SEARCH ---
            function filterItems() {
                const search = document.getElementById('searchInput').value.toLowerCase();
                const cards = document.querySelectorAll('.item-card');
                let hasVisible = false;

                cards.forEach(card => {
                    const title = card.getAttribute('data-title').toLowerCase();
                    if (title.includes(search)) {
                        card.parentElement.style.display = 'block'; // Pastikan grid item tampil
                        card.style.display = 'flex';
                        hasVisible = true;
                    } else {
                        card.style.display = 'none';
                    }
                });
                document.getElementById('emptyState').classList.toggle('hidden', hasVisible);
            }

            // --- MODAL & BOOKING LOGIC ---
            function openModal(card) {
                const d = card.dataset;
                currentPricePerDay = parseInt(d.price);
                
                document.getElementById('modalImg').src = d.image;
                document.getElementById('modalTitle').innerText = d.title;
                document.getElementById('modalCategory').innerText = d.category;
                document.getElementById('modalDesc').innerText = d.desc;
                document.getElementById('modalOwnerName').innerText = d.owner;
                document.getElementById('modalOwnerInitials').innerText = d.owner.charAt(0);
                document.getElementById('modalRating').innerText = d.rating;
                document.getElementById('modalReviews').innerText = `(${d.reviews})`;
                document.getElementById('successItemTitle').innerText = d.title;

                const today = new Date().toISOString().split('T')[0];
                document.getElementById('startDate').value = today;
                document.getElementById('endDate').value = "";
                calculatePrice();

                document.getElementById('modalContent').classList.remove('hidden');
                document.getElementById('modalSuccess').classList.add('hidden');
                document.getElementById('bookingModal').classList.remove('hidden');
            }

            function closeModal() {
                document.getElementById('bookingModal').classList.add('hidden');
            }

            function calculatePrice() {
                const s = document.getElementById('startDate').value;
                const e = document.getElementById('endDate').value;
                if (!s || !e) {
                    document.getElementById('calcBasePrice').innerText = "Rp 0";
                    document.getElementById('calcTotal').innerText = "Rp 0";
                    return;
                }
                const diff = Math.ceil(Math.abs(new Date(e) - new Date(s)) / (86400000)) || 1;
                const total = (diff * currentPricePerDay) + 5000;
                
                document.getElementById('calcBasePrice').innerText = `Rp ${currentPricePerDay.toLocaleString('id-ID')} x ${diff} hari`;
                document.getElementById('calcTotal').innerText = `Rp ${total.toLocaleString('id-ID')}`;
            }

            function submitBooking() {
                document.getElementById('modalContent').classList.add('hidden');
                document.getElementById('modalSuccess').classList.remove('hidden');
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