<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. LOGIKA NAVIGASI (Router Sederhana)
    String pageType = request.getParameter("page");
    if (pageType == null) pageType = "about"; // Default ke halaman About Us

    String title = "";
    
    // Tentukan Judul berdasarkan parameter
    switch(pageType) {
        case "how-it-works": title = "Cara Kerja"; break;
        case "trust": title = "Kepercayaan & Keamanan"; break;
        case "insurance": title = "Asuransi"; break;
        case "about": title = "Tentang Kami"; break;
        case "careers": title = "Karir"; break;
        case "contact": title = "Hubungi Kami"; break;
        case "terms": title = "Syarat Layanan"; break;
        case "privacy": title = "Kebijakan Privasi"; break;
        case "cookies": title = "Kebijakan Cookie"; break;
        default: title = "Halaman Tidak Ditemukan";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= title %> - PinjamAja</title>
        
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
    <body class="bg-white text-slate-800 font-sans min-h-screen flex flex-col">
        
        <nav class="bg-gray-100 border-b py-2 overflow-x-auto">
            <div class="container mx-auto px-4 flex gap-4 text-sm whitespace-nowrap">
                <a href="?page=about" class="<%= pageType.equals("about") ? "text-primary font-bold" : "text-gray-600" %>">Tentang Kami</a>
                <a href="?page=how-it-works" class="<%= pageType.equals("how-it-works") ? "text-primary font-bold" : "text-gray-600" %>">Cara Kerja</a>
                <a href="?page=contact" class="<%= pageType.equals("contact") ? "text-primary font-bold" : "text-gray-600" %>">Hubungi Kami</a>
                <a href="?page=trust" class="<%= pageType.equals("trust") ? "text-primary font-bold" : "text-gray-600" %>">Kepercayaan</a>
                <a href="?page=insurance" class="<%= pageType.equals("insurance") ? "text-primary font-bold" : "text-gray-600" %>">Asuransi</a>
                <a href="?page=terms" class="<%= pageType.equals("terms") ? "text-primary font-bold" : "text-gray-600" %>">Syarat</a>
            </div>
        </nav>

        <div class="container mx-auto px-4 py-12 max-w-4xl flex-grow">
            <div class="mb-8">
                <h1 class="text-4xl font-bold text-primary mb-4"><%= title %></h1>
                <div class="h-1 w-20 bg-accent"></div>
            </div>
            
            <div class="space-y-8 text-gray-600">
                
                <%-- KONTEN: CARA KERJA --%>
                <% if (pageType.equals("how-it-works")) { %>
                <div class="grid md:grid-cols-2 gap-12">
                    <div>
                        <h2 class="text-2xl font-semibold text-gray-900 mb-6">Untuk Peminjam</h2>
                        <div class="space-y-6">
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-blue-50 text-primary flex items-center justify-center font-bold flex-shrink-0">1</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Temukan yang Anda butuhkan</h3>
                                    <p>Cari barang di dekat Anda. Filter berdasarkan kategori, harga, dan ketersediaan.</p>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-blue-50 text-primary flex items-center justify-center font-bold flex-shrink-0">2</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Ajukan sewa</h3>
                                    <p>Pilih tanggal dan kirim permintaan. Pemilik akan meninjau dan menyetujuinya.</p>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-blue-50 text-primary flex items-center justify-center font-bold flex-shrink-0">3</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Ambil & Nikmati</h3>
                                    <p>Temui pemilik, periksa barang, dan gunakan untuk proyek atau petualangan Anda.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <h2 class="text-2xl font-semibold text-gray-900 mb-6">Untuk Pemilik</h2>
                        <div class="space-y-6">
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-yellow-50 text-yellow-700 flex items-center justify-center font-bold flex-shrink-0">1</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Daftarkan barang Anda</h3>
                                    <p>Unggah foto, atur harga, dan deskripsikan barang Anda. Kurang dari 2 menit.</p>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-yellow-50 text-yellow-700 flex items-center justify-center font-bold flex-shrink-0">2</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Terima pesanan</h3>
                                    <p>Tinjau permintaan dari peminjam terverifikasi. Anda memiliki kendali penuh.</p>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-yellow-50 text-yellow-700 flex items-center justify-center font-bold flex-shrink-0">3</div>
                                <div>
                                    <h3 class="font-bold text-lg text-gray-900">Hasilkan uang</h3>
                                    <p>Dapatkan bayaran dengan aman melalui platform kami setelah masa sewa selesai.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <%-- KONTEN: HUBUNGI KAMI --%>
                <% if (pageType.equals("contact")) { %>
                <div class="grid md:grid-cols-2 gap-12">
                    <div>
                        <h2 class="text-xl font-bold mb-6">Informasi Kontak</h2>
                        <div class="space-y-6">
                            <div class="flex items-start gap-4">
                                <i data-lucide="mail" class="w-6 h-6 text-primary mt-1"></i>
                                <div>
                                    <h3 class="font-semibold">Email</h3>
                                    <p class="text-gray-600">support@pinjamaja.com</p>
                                    <p class="text-gray-600">partnerships@pinjamaja.com</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <i data-lucide="phone" class="w-6 h-6 text-primary mt-1"></i>
                                <div>
                                    <h3 class="font-semibold">Telepon</h3>
                                    <p class="text-gray-600">+62 21 1234 5678</p>
                                    <p class="text-sm text-gray-500">Sen-Jum, 9.00 - 18.00 WIB</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <i data-lucide="map-pin" class="w-6 h-6 text-primary mt-1"></i>
                                <div>
                                    <h3 class="font-semibold">Kantor</h3>
                                    <p class="text-gray-600">
                                        Jl. Sudirman Kav. 52-53<br/>
                                        Jakarta Selatan, DKI Jakarta 12190<br/>
                                        Indonesia
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-xl shadow-sm border">
                        <h3 class="font-bold text-lg mb-4">Kirim pesan kepada kami</h3>
                        <div class="space-y-4">
                            <div class="space-y-2">
                                <label class="text-sm font-medium">Nama</label>
                                <input type="text" placeholder="Nama Anda" class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-medium">Email</label>
                                <input type="email" placeholder="Email Anda" class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-medium">Pesan</label>
                                <textarea placeholder="Bagaimana kami bisa membantu?" class="w-full px-3 py-2 border rounded-md min-h-[120px] focus:outline-none focus:ring-2 focus:ring-primary"></textarea>
                            </div>
                            <button class="w-full bg-primary text-white py-2 rounded-md hover:bg-blue-700 font-medium">Kirim Pesan</button>
                        </div>
                    </div>
                </div>
                <% } %>

                <%-- KONTEN: TENTANG KAMI --%>
                <% if (pageType.equals("about")) { %>
                <div class="prose prose-lg max-w-none">
                    <p class="lead text-xl text-gray-600 mb-8">
                        PinjamAja didirikan pada tahun 2025 dengan misi sederhana: mengurangi limbah dan membangun komunitas dengan memudahkan berbagi barang yang kita miliki.
                    </p>
                    <div class="grid md:grid-cols-2 gap-8 my-12">
                        <div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">Visi Kami</h3>
                            <p>
                                Kami membayangkan dunia di mana akses mengalahkan kepemilikan. Dunia di mana komunitas lebih terhubung, konsumsi sumber daya berkurang, dan setiap orang memiliki akses ke alat dan barang yang mereka butuhkan.
                            </p>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">Cerita Kami</h3>
                            <p>
                                Bermula dari sebuah bor. Pendiri kami membutuhkannya untuk pekerjaan 10 menit tetapi tidak ingin membelinya. PinjamAja lahir dari ide bahwa kita memiliki cukup sumber daya di komunitas kita—kita hanya butuh cara yang lebih baik untuk membagikannya.
                            </p>
                        </div>
                    </div>
                </div>
                <% } %>

                <%-- KONTEN: KEPERCAYAAN & KEAMANAN --%>
                <% if (pageType.equals("trust")) { %>
                <div class="grid md:grid-cols-3 gap-6 mb-12">
                    <div class="bg-white p-6 rounded-lg border shadow-sm text-center">
                        <i data-lucide="shield" class="w-12 h-12 mx-auto text-primary mb-4"></i>
                        <h3 class="font-bold text-lg mb-2">Pengguna Terverifikasi</h3>
                        <p class="text-sm">Kami memverifikasi identitas setiap pengguna di platform kami untuk memastikan komunitas yang aman.</p>
                    </div>
                    <div class="bg-white p-6 rounded-lg border shadow-sm text-center">
                        <i data-lucide="check-circle" class="w-12 h-12 mx-auto text-primary mb-4"></i>
                        <h3 class="font-bold text-lg mb-2">Pembayaran Aman</h3>
                        <p class="text-sm">Transaksi diproses dengan aman. Kami menahan pembayaran hingga sewa berhasil.</p>
                    </div>
                    <div class="bg-white p-6 rounded-lg border shadow-sm text-center">
                        <i data-lucide="users" class="w-12 h-12 mx-auto text-primary mb-4"></i>
                        <h3 class="font-bold text-lg mb-2">Ulasan Komunitas</h3>
                        <p class="text-sm">Baca ulasan dari pengguna nyata sebelum Anda menyewa atau meminjamkan.</p>
                    </div>
                </div>
                <div class="bg-blue-50 p-8 rounded-xl">
                    <h2 class="text-2xl font-bold text-primary mb-4">Komitmen Kami</h2>
                    <p class="mb-4">
                        Di PinjamAja, kami percaya bahwa kepercayaan adalah fondasi dari ekonomi berbagi. Tim dukungan kami tersedia 24/7 untuk membantu masalah apa pun yang mungkin timbul selama sewa.
                    </p>
                </div>
                <% } %>
                
                <%-- KONTEN: ASURANSI --%>
                <% if (pageType.equals("insurance")) { %>
                <div class="flex flex-col md:flex-row gap-8 items-center mb-12">
                    <div class="flex-1">
                        <h2 class="text-2xl font-bold text-gray-900 mb-4">Anda Terlindungi</h2>
                        <p class="mb-4 text-lg">Kami bermitra dengan penyedia asuransi terkemuka untuk menawarkan perlindungan barang Anda selama setiap sewa.</p>
                        <ul class="space-y-3">
                            <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i><span>Perlindungan hingga Rp 75.000.000 per barang</span></li>
                            <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i><span>Perlindungan terhadap kerusakan dan pencurian</span></li>
                            <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i><span>Termasuk perlindungan kewajiban</span></li>
                        </ul>
                    </div>
                    <div class="flex-1 bg-gray-100 rounded-xl h-64 w-full flex items-center justify-center">
                        <i data-lucide="shield" class="w-24 h-24 text-gray-300"></i>
                    </div>
                </div>
                <% } %>

                <%-- KONTEN: LEGAL (Syarat, Privasi, Cookies - Digabung polanya) --%>
                <% if (pageType.equals("terms") || pageType.equals("privacy") || pageType.equals("cookies")) { %>
                <div class="prose prose-sm max-w-none">
                    <p class="text-sm text-gray-500 mb-6">Terakhir diperbarui: 10 Desember 2025</p>
                    
                    <% if (pageType.equals("terms")) { %>
                        <h3 class="text-lg font-bold text-gray-900 mt-6 mb-3">1. Penerimaan Syarat</h3>
                        <p>Dengan mengakses dan menggunakan PinjamAja, Anda menerima dan setuju untuk terikat oleh syarat dan ketentuan perjanjian ini.</p>
                        <h3 class="text-lg font-bold text-gray-900 mt-6 mb-3">2. Deskripsi Layanan</h3>
                        <p>PinjamAja menyediakan platform online yang menghubungkan orang yang ingin menyewa barang dengan orang yang memiliki barang untuk disewakan.</p>
                    <% } else if (pageType.equals("privacy")) { %>
                        <h3 class="text-lg font-bold text-gray-900 mt-6 mb-3">1. Informasi yang Kami Kumpulkan</h3>
                        <p>Kami mengumpulkan informasi yang Anda berikan langsung kepada kami, seperti saat Anda membuat akun, mendaftarkan barang, atau mengajukan sewa.</p>
                    <% } else { %>
                        <h3 class="text-lg font-bold text-gray-900 mt-6 mb-3">1. Apa itu cookie?</h3>
                        <p>Cookie adalah file data kecil yang ditempatkan di komputer atau perangkat seluler Anda ketika Anda mengunjungi situs web.</p>
                    <% } %>
                </div>
                <% } %>

            </div>
        </div>
        
        <script>
            lucide.createIcons();
        </script>
    </body>
</html>