<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Masuk / Daftar - PinjamAja</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        
        <link rel="stylesheet" href="css/style.css">
        
        <script src="https://unpkg.com/lucide@latest"></script>

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: '#2B6CB0',
                            primaryHover: '#1A4E85',
                            accent: '#FFD54A',
                            accentHover: '#FFC000'
                        }
                    }
                }
            }
        </script>

        <style>
            .tab-content {
                display: none;
                animation: fadeIn 0.3s ease-in-out;
            }
            .tab-content.active {
                display: block;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(5px); }
                to { opacity: 1; transform: translateY(0); }
            }
        </style>
    </head>
    <body class="bg-[#F6F7FB] min-h-screen flex items-center justify-center py-12 px-4 font-sans text-slate-800">

        <div class="w-full max-w-md bg-white rounded-xl shadow-xl overflow-hidden border border-gray-100">
            
            <div class="p-6 pb-2 text-center">
                <div class="mx-auto w-12 h-12 bg-primary rounded-xl flex items-center justify-center mb-4 text-white shadow-lg shadow-blue-200">
                    <i data-lucide="hexagon" class="w-8 h-8 fill-current"></i>
                </div>
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">Selamat Datang di PinjamAja</h1>
                <p class="text-sm text-gray-500 mt-2">
                    Bergabung dengan komunitas untuk menyewa atau meminjamkan barang dengan aman.
                </p>
            </div>

            <div class="p-6 pt-2">
                
                <div class="grid grid-cols-2 bg-gray-100 p-1 rounded-lg mb-6">
                    <button onclick="switchTab('login')" id="tab-btn-login" class="py-2 text-sm font-medium rounded-md transition-all bg-white text-gray-900 shadow-sm">
                        Masuk
                    </button>
                    <button onclick="switchTab('register')" id="tab-btn-register" class="py-2 text-sm font-medium rounded-md transition-all text-gray-500 hover:text-gray-900">
                        Daftar
                    </button>
                </div>

                <div id="content-login" class="tab-content active space-y-4">
                    <div class="space-y-2">
                        <label class="text-sm font-medium leading-none" for="email">Email</label>
                        <input class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2" id="email" type="email" placeholder="m@example.com">
                    </div>
                    <div class="space-y-2">
                        <label class="text-sm font-medium leading-none" for="password">Kata Sandi</label>
                        <input class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2" id="password" type="password">
                    </div>
                    
                    <div class="pt-4 space-y-3">
                        <button onclick="handleLogin('BORROWER')" class="w-full inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 bg-primary text-white hover:bg-primaryHover transition-colors">
                            Masuk sebagai Peminjam
                        </button>
                        <button onclick="handleLogin('OWNER')" class="w-full inline-flex items-center justify-center rounded-md text-sm font-medium h-10 px-4 py-2 border border-primary text-primary hover:bg-blue-50 transition-colors">
                            Masuk sebagai Pemilik Barang
                        </button>
                        <button onclick="handleLogin('ADMIN')" class="w-full inline-flex items-center justify-center rounded-md text-xs font-medium h-8 px-4 py-2 text-gray-400 hover:text-gray-600">
                            Masuk Admin (Demo)
                        </button>
                    </div>
                </div>

                <div id="content-register" class="tab-content space-y-4">
                    
                    <div class="grid grid-cols-2 gap-4 mb-2">
                        <div id="role-borrower" onclick="selectRole('BORROWER')" 
                             class="cursor-pointer rounded-xl border-2 p-4 flex flex-col items-center justify-center gap-2 transition-all border-primary bg-blue-50 text-primary">
                            <i data-lucide="user" class="w-6 h-6"></i>
                            <span class="font-semibold text-sm">Peminjam</span>
                        </div>
                        <div id="role-owner" onclick="selectRole('OWNER')" 
                             class="cursor-pointer rounded-xl border-2 border-gray-200 p-4 flex flex-col items-center justify-center gap-2 transition-all hover:border-blue-200 text-gray-600">
                            <i data-lucide="package" class="w-6 h-6"></i>
                            <span class="font-semibold text-sm">Pemilik Barang</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label class="text-sm font-medium" for="first-name">Nama Depan</label>
                            <input class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary" id="first-name" placeholder="John">
                        </div>
                        <div class="space-y-2">
                            <label class="text-sm font-medium" for="last-name">Nama Belakang</label>
                            <input class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary" id="last-name" placeholder="Doe">
                        </div>
                    </div>
                    
                    <div class="space-y-2">
                        <label class="text-sm font-medium" for="reg-email">Email</label>
                        <input class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary" id="reg-email" type="email" placeholder="m@example.com">
                    </div>

                    <div class="bg-blue-50 p-4 rounded-lg border border-blue-100 my-4">
                        <div class="flex items-center gap-2 text-primary font-medium mb-2 text-sm">
                            <i data-lucide="shield" class="w-4 h-4"></i> Verifikasi Identitas
                        </div>
                        <p class="text-xs text-blue-700 mb-3">Untuk membangun kepercayaan, kami mewajibkan ID yang valid untuk semua akun baru.</p>
                        <button class="w-full inline-flex items-center justify-center rounded-md text-sm font-medium h-9 px-3 bg-white text-blue-700 border border-blue-200 hover:bg-blue-100 transition-colors">
                            <i data-lucide="camera" class="w-3 h-3 mr-2"></i> Unggah KTP
                        </button>
                    </div>

                    <div class="pt-2">
                        <button onclick="handleRegister()" id="btn-submit-register" class="w-full inline-flex items-center justify-center rounded-md text-sm font-bold h-10 px-4 py-2 bg-accent text-primary hover:bg-accentHover transition-colors">
                            Buat Akun Peminjam
                        </button>
                    </div>
                </div>

            </div>

            <div class="flex justify-center border-t pt-6 pb-6 bg-gray-50">
                <p class="text-xs text-gray-400 flex items-center gap-1">
                    <i data-lucide="lock" class="w-3 h-3"></i> Koneksi Terenkripsi Aman
                </p>
            </div>
        </div>

        <script>
            lucide.createIcons();

            let currentRegisterRole = 'BORROWER';

            function switchTab(tabName) {
                document.getElementById('content-login').classList.remove('active');
                document.getElementById('content-register').classList.remove('active');
                
                const btnLogin = document.getElementById('tab-btn-login');
                const btnRegister = document.getElementById('tab-btn-register');
                
                btnLogin.classList.remove('bg-white', 'text-gray-900', 'shadow-sm');
                btnLogin.classList.add('text-gray-500');
                
                btnRegister.classList.remove('bg-white', 'text-gray-900', 'shadow-sm');
                btnRegister.classList.add('text-gray-500');

                if(tabName === 'login') {
                    document.getElementById('content-login').classList.add('active');
                    btnLogin.classList.add('bg-white', 'text-gray-900', 'shadow-sm');
                    btnLogin.classList.remove('text-gray-500');
                } else {
                    document.getElementById('content-register').classList.add('active');
                    btnRegister.classList.add('bg-white', 'text-gray-900', 'shadow-sm');
                    btnRegister.classList.remove('text-gray-500');
                }
            }

            function selectRole(role) {
                currentRegisterRole = role;
                const boxBorrower = document.getElementById('role-borrower');
                const boxOwner = document.getElementById('role-owner');
                const btnSubmit = document.getElementById('btn-submit-register');

                const activeClasses = ['border-primary', 'bg-blue-50', 'text-primary'];
                const inactiveClasses = ['border-gray-200', 'text-gray-600'];

                if (role === 'BORROWER') {
                    boxBorrower.classList.add(...activeClasses);
                    boxBorrower.classList.remove(...inactiveClasses);
                    
                    boxOwner.classList.remove(...activeClasses);
                    boxOwner.classList.add(...inactiveClasses);
                    
                    btnSubmit.innerText = "Buat Akun Peminjam";
                } else {
                    boxOwner.classList.add(...activeClasses);
                    boxOwner.classList.remove(...inactiveClasses);
                    
                    boxBorrower.classList.remove(...activeClasses);
                    boxBorrower.classList.add(...inactiveClasses);
                    
                    btnSubmit.innerText = "Buat Akun Pemilik";
                }
            }

            // LOGIC LOGIN YANG SUDAH DIPERBAIKI (ROUTING)
            function handleLogin(role) {
                const buttons = document.querySelectorAll('button');
                buttons.forEach(btn => btn.disabled = true);
                
                setTimeout(() => {
                    if (role === 'BORROWER') {
                        // Masuk sebagai Peminjam -> Halaman Jelajah
                        window.location.href = "borrower_dashboard.jsp";
                    } else if (role === 'OWNER') {
                        // Masuk sebagai Pemilik -> Dashboard Pemilik
                        window.location.href = "owner_dashboard.jsp";
                    } else {
                        // Masuk sebagai Admin (Demo) -> Dashboard Admin
                        window.location.href = "admin_dashboard.jsp";
                    }
                }, 800);
            }
            
            function handleRegister() {
                 handleLogin(currentRegisterRole);
            }
        </script>
    </body>
</html>