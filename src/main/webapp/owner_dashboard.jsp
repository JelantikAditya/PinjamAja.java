<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat"%>

<%
    // --- 1. SIMULASI DATA BACKEND (MENGGUNAKAN MAP) ---
    String currentUserId = "owner-001"; // Simulasi ID Owner yang sedang login

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // --- Data Barang Milik Owner ---
    List<Map<String, Object>> myItems = new ArrayList<>();
    Map<String, Object> item;

    item = new HashMap<>();
    item.put("id", "ITM-001");
    item.put("ownerId", currentUserId);
    item.put("title", "Kamera DSLR Canon 5D");
    item.put("category", "Elektronik");
    item.put("description", "Kamera profesional full frame, kondisi sangat baik.");
    item.put("pricePerDay", 500000.0);
    item.put("imageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=400");
    item.put("rating", 4.8);
    item.put("reviewCount", 15);
    myItems.add(item);

    item = new HashMap<>();
    item.put("id", "ITM-002");
    item.put("ownerId", currentUserId);
    item.put("title", "Tenda Camping 4 Orang");
    item.put("category", "Outdoor");
    item.put("description", "Tenda dome waterproof kapasitas 4 orang.");
    item.put("pricePerDay", 75000.0);
    item.put("imageUrl", "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&q=80&w=400");
    item.put("rating", 4.5);
    item.put("reviewCount", 8);
    myItems.add(item);


    // --- Data Booking Milik Owner ---
    List<Map<String, Object>> myBookings = new ArrayList<>();
    Map<String, Object> b;

    // Booking 1: Pending (Request Masuk)
    b = new HashMap<>();
    b.put("id", "B-101");
    b.put("ownerId", currentUserId);
    b.put("itemTitle", "Kamera DSLR Canon 5D");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=400");
    b.put("borrowerName", "Budi Santoso");
    b.put("startDate", "2023-11-20");
    b.put("endDate", "2023-11-22");
    b.put("totalPrice", 1000000.0);
    b.put("status", "PENDING");
    myBookings.add(b);

    // Booking 2: Ongoing (Sedang Disewa)
    b = new HashMap<>();
    b.put("id", "B-102");
    b.put("ownerId", currentUserId);
    b.put("itemTitle", "Tenda Camping 4 Orang");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&q=80&w=400");
    b.put("borrowerName", "Siti Aminah");
    b.put("startDate", "2023-11-18");
    b.put("endDate", "2023-11-21");
    b.put("totalPrice", 225000.0);
    b.put("status", "ONGOING");
    myBookings.add(b);

    // Booking 3: Completed (Selesai)
    b = new HashMap<>();
    b.put("id", "B-103");
    b.put("ownerId", currentUserId);
    b.put("itemTitle", "Kamera DSLR Canon 5D");
    b.put("itemImageUrl", "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=400");
    b.put("borrowerName", "Andi Wijaya");
    b.put("startDate", "2023-11-01");
    b.put("endDate", "2023-11-03");
    b.put("totalPrice", 1000000.0);
    b.put("status", "COMPLETED");
    myBookings.add(b);


    // --- Filter Logika ---
    List<Map<String, Object>> pendingBookings = new ArrayList<>();
    List<Map<String, Object>> activeRentals = new ArrayList<>();
    double totalEarnings = 0;

    for(Map<String, Object> booking : myBookings) {
        String status = (String) booking.get("status");
        if(status.equals("PENDING")) {
            pendingBookings.add(booking);
        } else if(status.equals("APPROVED") || status.equals("ONGOING")) {
            activeRentals.add(booking);
        } else if(status.equals("COMPLETED")) {
            totalEarnings += (Double) booking.get("totalPrice");
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard Pemilik - PinjamAja</title>
        
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
                            accentHover: '#FFC000'
                        }
                    }
                }
            }
        </script>
        <style>
            .tab-active {
                border-bottom: 2px solid #2B6CB0;
                color: #2B6CB0;
                font-weight: 600;
            }
            .tab-inactive {
                color: #6B7280;
            }
        </style>
    </head>
    <body class="bg-[#F6F7FB] text-slate-800 font-sans min-h-screen">
        
        <div class="container mx-auto px-4 py-8">
            
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Dashboard Pemilik</h1>
                    <p class="text-gray-500">Kelola barang dan permintaan sewa Anda.</p>
                </div>
                <button onclick="openAddModal()" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 bg-primary text-white hover:bg-blue-700 transition-colors shadow-sm">
                    <i data-lucide="plus" class="mr-2 h-4 w-4"></i> Tambah Barang Baru
                </button>
            </div>

            <div class="grid gap-4 md:grid-cols-3 mb-8">
                <div class="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <h3 class="text-sm font-medium text-gray-500">Total Pendapatan</h3>
                        <i data-lucide="dollar-sign" class="h-4 w-4 text-green-600"></i>
                    </div>
                    <div class="text-2xl font-bold text-gray-900"><%= rpFormat.format(totalEarnings) %></div>
                    <p class="text-xs text-gray-500 mt-1">+20.1% dari bulan lalu</p>
                </div>

                <div class="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <h3 class="text-sm font-medium text-gray-500">Penyewaan Aktif</h3>
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
                    <p class="text-xs text-gray-500 mt-1">Tersedia di katalog</p>
                </div>
            </div>

            <div class="w-full">
                <div class="flex space-x-6 border-b border-gray-200 mb-6">
                    <button onclick="switchTab('requests')" id="tab-requests" class="tab-active py-2 px-1 relative">
                        Permintaan Masuk
                        <% if(pendingBookings.size() > 0) { %>
                            <span class="absolute -top-1 -right-3 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[10px] text-white">
                                <%= pendingBookings.size() %>
                            </span>
                        <% } %>
                    </button>
                    <button onclick="switchTab('rentals')" id="tab-rentals" class="tab-inactive py-2 px-1 hover:text-gray-900">Semua Sewa</button>
                    <button onclick="switchTab('items')" id="tab-items" class="tab-inactive py-2 px-1 hover:text-gray-900">Barang Saya</button>
                </div>

                <div id="content-requests" class="block">
                    <div class="bg-white rounded-lg border border-gray-100 shadow-sm">
                        <div class="p-6 border-b border-gray-100">
                            <h3 class="text-lg font-semibold">Permintaan Sewa</h3>
                            <p class="text-sm text-gray-500">Tinjau dan setujui permintaan sewa masuk.</p>
                        </div>
                        <div class="p-6">
                            <% if(pendingBookings.isEmpty()) { %>
                                <div class="text-center py-8 text-gray-500">Tidak ada permintaan tertunda saat ini.</div>
                            <% } else { %>
                                <div class="space-y-4">
                                    <% for(Map<String, Object> bData : pendingBookings) { %>
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
                                            <button onclick="alert('Permintaan Ditolak')" class="flex-1 md:flex-none px-4 py-2 border border-red-200 text-red-600 hover:bg-red-50 rounded-md text-sm font-medium transition-colors">Tolak</button>
                                            <button onclick="alert('Permintaan Disetujui')" class="flex-1 md:flex-none px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-md text-sm font-medium transition-colors">Setujui</button>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div id="content-rentals" class="hidden">
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
                                    <% for(Map<String, Object> booking : myBookings) { 
                                        String st = (String) booking.get("status");
                                        String badgeCls = "bg-gray-100 text-gray-800";
                                        String label = st;
                                        if(st.equals("PENDING")) { badgeCls = "bg-yellow-50 text-yellow-700 border-yellow-200"; label="Menunggu"; }
                                        else if(st.equals("APPROVED")) { badgeCls = "bg-blue-50 text-blue-700 border-blue-200"; label="Disetujui"; }
                                        else if(st.equals("ONGOING")) { badgeCls = "bg-blue-50 text-blue-700 border-blue-200"; label="Berjalan"; }
                                        else if(st.equals("COMPLETED")) { badgeCls = "bg-green-50 text-green-700 border-green-200"; label="Selesai"; }
                                    %>
                                    <tr class="border-b hover:bg-gray-50 transition-colors">
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
                                            <% if(st.equals("APPROVED") || st.equals("ONGOING")) { %>
                                                <button onclick="alert('Marked as Returned')" class="text-xs border px-2 py-1 rounded hover:bg-gray-100">Tandai Dikembalikan</button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div id="content-items" class="hidden">
                    <div class="grid gap-4 md:grid-cols-3">
                        <% for(Map<String, Object> i : myItems) { %>
                        <div class="bg-white rounded-lg border border-gray-100 shadow-sm overflow-hidden group">
                            <div class="aspect-video bg-gray-100 relative">
                                <img src="<%= i.get("imageUrl") %>" class="w-full h-full object-cover" />
                                <div class="absolute top-2 right-2 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                    <button onclick="openEditModal('<%= i.get("title") %>', '<%= i.get("pricePerDay") %>')" class="h-8 w-8 bg-white/90 shadow-sm rounded-md flex items-center justify-center hover:bg-white text-gray-600">
                                        <i data-lucide="edit-2" class="h-4 w-4"></i>
                                    </button>
                                    <button onclick="confirm('Hapus barang ini?')" class="h-8 w-8 bg-red-500/90 shadow-sm rounded-md flex items-center justify-center hover:bg-red-600 text-white">
                                        <i data-lucide="trash-2" class="h-4 w-4"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold truncate text-gray-900"><%= i.get("title") %></h3>
                                <div class="flex justify-between mt-2">
                                    <span class="text-sm text-gray-500"><%= i.get("category") %></span>
                                    <span class="font-bold text-primary"><%= rpFormat.format(i.get("pricePerDay")) %>/hari</span>
                                </div>
                                <div class="mt-3 flex items-center gap-2 text-xs text-gray-400">
                                    <i data-lucide="star" class="w-3 h-3 text-yellow-400 fill-current"></i>
                                    <span><%= i.get("rating") %> (<%= i.get("reviewCount") %> ulasan)</span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

            </div>

        </div>

        <div id="addItemModal" class="fixed inset-0 z-50 hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white w-full max-w-lg rounded-lg shadow-xl p-6 relative animate-in fade-in zoom-in duration-200">
                <div class="mb-4">
                    <h3 class="text-lg font-bold">Daftarkan barang baru</h3>
                    <p class="text-sm text-gray-500">Isi detail untuk mulai menghasilkan.</p>
                </div>
                
                <div class="space-y-4">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <label class="text-right text-sm font-medium">Judul</label>
                        <input type="text" class="col-span-3 flex h-10 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                    </div>
                    <div class="grid grid-cols-4 items-center gap-4">
                        <label class="text-right text-sm font-medium">Kategori</label>
                        <select class="col-span-3 flex h-10 w-full rounded-md border border-gray-300 px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-primary">
                            <option>Elektronik</option>
                            <option>Perkakas</option>
                            <option>Outdoor</option>
                            <option>Olahraga</option>
                        </select>
                    </div>
                    <div class="grid grid-cols-4 items-center gap-4">
                        <label class="text-right text-sm font-medium">Harga/Hari</label>
                        <div class="col-span-3 relative">
                            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 text-sm">Rp</span>
                            <input type="number" class="flex h-10 w-full rounded-md border border-gray-300 pl-9 pr-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                        </div>
                    </div>
                    <div class="grid grid-cols-4 items-center gap-4">
                        <label class="text-right text-sm font-medium">Deskripsi</label>
                        <textarea class="col-span-3 flex min-h-[80px] w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary"></textarea>
                    </div>
                </div>

                <div class="flex justify-end mt-6 gap-2">
                    <button onclick="closeAddModal()" class="px-4 py-2 border rounded-md text-sm hover:bg-gray-50">Batal</button>
                    <button onclick="alert('Barang Ditambahkan!'); closeAddModal();" class="px-4 py-2 bg-accent hover:bg-accentHover text-primary font-bold rounded-md text-sm">Buat Daftar</button>
                </div>
            </div>
        </div>

        <script>
            lucide.createIcons();

            // Logic Tab Switching
            function switchTab(tabName) {
                // Hide all contents
                document.getElementById('content-requests').classList.add('hidden');
                document.getElementById('content-rentals').classList.add('hidden');
                document.getElementById('content-items').classList.add('hidden');
                
                // Reset tab styles
                ['requests', 'rentals', 'items'].forEach(t => {
                    const btn = document.getElementById('tab-' + t);
                    btn.classList.remove('tab-active');
                    btn.classList.add('tab-inactive');
                });

                // Show selected content & Activate tab
                document.getElementById('content-' + tabName).classList.remove('hidden');
                const activeBtn = document.getElementById('tab-' + tabName);
                activeBtn.classList.add('tab-active');
                activeBtn.classList.remove('tab-inactive');
            }

            // Logic Modal Add Item
            function openAddModal() {
                document.getElementById('addItemModal').classList.remove('hidden');
            }
            function closeAddModal() {
                document.getElementById('addItemModal').classList.add('hidden');
            }
            
            // Logic Modal Edit (Sederhana untuk demo)
            function openEditModal(title, price) {
                // Bisa dikembangkan untuk mengisi form modal add item dengan data ini
                openAddModal(); 
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