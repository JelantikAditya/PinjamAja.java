<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PinjamAja - Sewa Barang Aman & Mudah</title>
        
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
            .rotate-hover:hover {
                transform: rotate(0deg) !important;
            }
        </style>
    </head>
    <body class="bg-white font-sans text-slate-800">
        
        <div class="flex flex-col min-h-screen">
            
            <nav class="bg-white sticky top-0 z-50 border-b border-gray-100">
                <div class="container mx-auto px-4 h-20 flex items-center justify-between">
                    <a href="landing.jsp" class="flex items-center gap-2 group">
                        <div class="bg-primary text-white p-1.5 rounded-lg group-hover:scale-110 transition-transform">
                             <i data-lucide="hexagon" class="w-6 h-6 fill-current"></i>
                        </div>
                        <span class="text-xl font-bold text-primary tracking-tight">PinjamAja</span>
                    </a>

                    <div class="flex items-center gap-6">
                        <a href="auth.jsp" class="text-sm font-semibold text-gray-600 hover:text-primary transition-colors">
                            Masuk
                        </a>
                        <a href="auth.jsp" class="px-6 py-2.5 text-sm font-bold text-primary bg-accent rounded-lg hover:bg-accentHover transition-colors shadow-sm hover:shadow-md">
                            Daftar
                        </a>
                    </div>
                </div>
            </nav>

            <section class="relative bg-primary py-20 lg:py-28 overflow-hidden">
                <div class="absolute inset-0 opacity-10" style="background-image: url('https://www.transparenttextures.com/patterns/cubes.png');"></div>
                
                <div class="container mx-auto px-4 relative z-10">
                    <div class="grid lg:grid-cols-2 gap-12 items-center">
                        <div class="text-center lg:text-left text-white space-y-6">
                            <h1 class="text-4xl lg:text-6xl font-extrabold leading-tight tracking-tight">
                                Rent items you need, <br/>
                                <span class="text-accent">earn from items you don't</span>
                            </h1>
                            <p class="text-xl text-blue-100 max-w-lg mx-auto lg:mx-0">
                                Bergabunglah dengan komunitas berbagi peer-to-peer terbesar. Hemat uang dengan menyewa, dan hasilkan uang dengan membagikan barang yang tidak Anda gunakan.
                            </p>
                            <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start pt-4">
                                <a href="borrower_dashboard.jsp" class="inline-flex items-center justify-center bg-accent text-primary hover:bg-accentHover font-bold text-lg px-8 h-14 rounded-full shadow-lg transition-colors">
                                    Mulai Menyewa Sekarang
                                </a>
                                <a href="auth.jsp" class="inline-flex items-center justify-center bg-transparent text-white border-2 border-white hover:bg-white/10 font-bold text-lg px-8 h-14 rounded-full transition-colors">
                                    Daftarkan Barang Anda
                                </a>
                            </div>
                        </div>
                        
                        <div class="hidden lg:block relative">
                            <div class="relative rounded-2xl overflow-hidden shadow-2xl border-4 border-white/20 transform rotate-2 transition-transform duration-500 rotate-hover">
                                <img src="https://images.unsplash.com/photo-1694813646614-18aca47bc81f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080" 
                                     alt="Happy people sharing" 
                                     class="w-full h-auto object-cover">
                                <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/60 to-transparent p-8">
                                    <p class="text-white font-medium">"Saya menyewa kamera untuk perjalanan saya dan berhemat Rp 4.500.000!" - Alex</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-20 bg-white">
                <div class="container mx-auto px-4">
                    <div class="text-center mb-16">
                        <h2 class="text-3xl font-bold text-gray-900 mb-4">Mengapa memilih PinjamAja?</h2>
                        <p class="text-gray-500 max-w-2xl mx-auto">Kami membangun platform yang mengutamakan keamanan, kepercayaan, dan kemudahan penggunaan bagi pemilik dan peminjam.</p>
                    </div>
                    <div class="grid md:grid-cols-3 gap-8">
                        <div class="bg-[#F6F7FB] p-8 rounded-2xl border border-gray-100 hover:shadow-lg transition-shadow">
                            <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mb-6 text-primary">
                                <i data-lucide="shield-check" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-900 mb-3">Pengguna Terverifikasi</h3>
                            <p class="text-gray-600">Setiap pengguna melalui proses verifikasi identitas yang ketat untuk memastikan komunitas yang aman.</p>
                        </div>
                        <div class="bg-[#F6F7FB] p-8 rounded-2xl border border-gray-100 hover:shadow-lg transition-shadow">
                            <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mb-6 text-green-600">
                                <i data-lucide="trending-up" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-900 mb-3">Hasilkan Pendapatan Pasif</h3>
                            <p class="text-gray-600">Ubah barang berdebu Anda menjadi uang tunai. Tetapkan harga dan jadwal ketersediaan Anda sendiri.</p>
                        </div>
                        <div class="bg-[#F6F7FB] p-8 rounded-2xl border border-gray-100 hover:shadow-lg transition-shadow">
                            <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center mb-6 text-yellow-600">
                                <i data-lucide="users" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold text-gray-900 mb-3">Komunitas Utama</h3>
                            <p class="text-gray-600">Bergabunglah dengan ribuan anggota yang saling membantu mengakses sumber daya secara lebih berkelanjutan.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-24 bg-white">
                <div class="container mx-auto px-4">
                    <div class="bg-primary rounded-3xl p-12 text-center text-white relative overflow-hidden">
                        <div class="relative z-10 max-w-2xl mx-auto space-y-8">
                            <h2 class="text-3xl md:text-4xl font-bold">Siap bergabung dengan ekonomi berbagi?</h2>
                            <p class="text-blue-100 text-lg">Baik Anda ingin meminjam bor untuk proyek akhir pekan atau menyewakan perlengkapan kamera Anda, PinjamAja membuatnya aman dan mudah.</p>
                            <a href="auth.jsp" class="inline-flex items-center justify-center bg-accent text-primary hover:bg-accentHover font-bold text-lg px-12 h-14 rounded-full shadow-lg transition-colors">
                                Mulai Hari Ini
                            </a>
                        </div>
                        <div class="absolute top-0 left-0 -ml-20 -mt-20 w-64 h-64 rounded-full bg-white/10 blur-3xl"></div>
                        <div class="absolute bottom-0 right-0 -mr-20 -mb-20 w-80 h-80 rounded-full bg-accent/20 blur-3xl"></div>
                    </div>
                </div>
            </section>
            
        </div>

        <script>
            lucide.createIcons();
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