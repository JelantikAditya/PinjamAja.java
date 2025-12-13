<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Handle logout
    String logout = request.getParameter("logout");
    if ("true".equals(logout)) {
        session.invalidate();
        response.sendRedirect("landing.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Masuk / Daftar - PinjamAja</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
        };
    </script>
    <style>
        .tab-content { display: none; animation: fadeIn 0.3s ease-in-out; }
        .tab-content.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
        .role-btn { @apply w-full py-2 rounded-md border-2 font-medium transition-all; }
        .role-btn.selected { @apply border-primary bg-primary text-white; }
        .role-btn:not(.selected) { @apply border-gray-300 text-gray-600 hover:border-primary hover:text-primary; }
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
            <button onclick="switchTab('login')" id="tab-btn-login" class="py-2 text-sm font-medium rounded-md transition-all bg-white text-gray-900 shadow-sm">Masuk</button>
            <button onclick="switchTab('register')" id="tab-btn-register" class="py-2 text-sm font-medium rounded-md transition-all text-gray-500 hover:text-gray-900">Daftar</button>
        </div>

        <!-- LOGIN FORM - SIMPLIFIED (NO ROLE SELECTION) -->
        <form action="auth" method="POST" id="login-form" class="tab-content active space-y-4">
            <input type="hidden" name="action" value="login">
            
            <div class="space-y-2">
                <label class="text-sm font-medium leading-none" for="login-email">Email</label>
                <input name="email" id="login-email" type="email" placeholder="m@example.com" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
            </div>
            
            <div class="space-y-2">
                <label class="text-sm font-medium leading-none" for="login-password">Kata Sandi</label>
                <input name="password" id="login-password" type="password" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
            </div>
            
            <button type="submit" class="w-full py-2 rounded-md bg-primary text-white font-medium hover:bg-primaryHover transition-colors">
                Masuk ke PinjamAja
            </button>
        </form>

        <!-- REGISTER FORM - WITH ROLE SELECTION -->
        <form action="auth" method="POST" id="register-form" class="tab-content space-y-4">
            <input type="hidden" name="action" value="register">
            <input type="hidden" name="role" id="register-role" value="BORROWER">
            
            <div class="grid grid-cols-2 gap-4">
                <div class="space-y-2">
                    <label class="text-sm font-medium" for="first-name">Nama Depan</label>
                    <input name="firstName" id="first-name" placeholder="John" required
                           class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                </div>
                <div class="space-y-2">
                    <label class="text-sm font-medium" for="last-name">Nama Belakang</label>
                    <input name="lastName" id="last-name" placeholder="Doe" required
                           class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                </div>
            </div>
            
            <div class="space-y-2">
                <label class="text-sm font-medium" for="reg-email">Email</label>
                <input name="email" id="reg-email" type="email" placeholder="m@example.com" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
            </div>

            <div class="space-y-2">
                <label class="text-sm font-medium" for="reg-password">Kata Sandi</label>
                <input name="password" id="reg-password" type="password" placeholder="Min. 6 karakter" required minlength="6"
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
            </div>
            
            <div class="space-y-2">
                <label class="text-sm font-medium" for="confirm-password">Konfirmasi Kata Sandi</label>
                <input name="confirmPassword" id="confirm-password" type="password" placeholder="Ulangi kata sandi" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-transparent px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
            </div>

            <!-- ROLE SELECTION HANYA DI REGISTER -->
            <div class="space-y-2 pt-4 border-t">
                <label class="text-sm font-medium leading-none flex items-center gap-2">
                    <i data-lucide="users" class="w-4 h-4"></i> Daftar sebagai:
                </label>
                <div class="grid grid-cols-1 gap-2">
                    <button type="button" onclick="setRegisterRole('BORROWER')" id="reg-role-btn-borrower" 
                            class="role-btn selected">Peminjam</button>
                    <button type="button" onclick="setRegisterRole('OWNER')" id="reg-role-btn-owner" 
                            class="role-btn">Pemilik Barang</button>
                </div>
            </div>

            <div class="bg-blue-50 p-4 rounded-lg border border-blue-100 my-4">
                <div class="flex items-center gap-2 text-primary font-medium mb-2 text-sm">
                    <i data-lucide="shield" class="w-4 h-4"></i> Verifikasi Identitas
                </div>
                <p class="text-xs text-blue-700 mb-3">Untuk membangun kepercayaan, kami mewajibkan ID yang valid untuk semua akun baru.</p>
                <button type="button" class="w-full py-2 rounded-md bg-white text-blue-700 border border-blue-200 hover:bg-blue-100 transition-colors text-sm font-medium">
                    <i data-lucide="camera" class="w-3 h-3 mr-2"></i> Unggah KTP
                </button>
            </div>
            
            <button type="submit" id="btn-submit-register" class="w-full py-2 rounded-md bg-accent text-primary font-bold hover:bg-accentHover transition-colors">
                Daftar Sekarang
            </button>
        </form>
    </div>

    <div class="flex justify-center border-t pt-6 pb-6 bg-gray-50">
        <p class="text-xs text-gray-400 flex items-center gap-1">
            <i data-lucide="lock" class="w-3 h-3"></i> Koneksi Terenkripsi Aman
        </p>
    </div>
</div>

<script>
    lucide.createIcons();

    function switchTab(tabName) {
        document.getElementById('login-form').classList.toggle('active', tabName === 'login');
        document.getElementById('register-form').classList.toggle('active', tabName === 'register');
        
        const btnLogin = document.getElementById('tab-btn-login');
        const btnRegister = document.getElementById('tab-btn-register');
        
        if (tabName === 'login') {
            btnLogin.classList.add('bg-white', 'text-gray-900', 'shadow-sm');
            btnLogin.classList.remove('text-gray-500');
            btnRegister.classList.remove('bg-white', 'text-gray-900', 'shadow-sm');
            btnRegister.classList.add('text-gray-500');
        } else {
            btnRegister.classList.add('bg-white', 'text-gray-900', 'shadow-sm');
            btnRegister.classList.remove('text-gray-500');
            btnLogin.classList.remove('bg-white', 'text-gray-900', 'shadow-sm');
            btnLogin.classList.add('text-gray-500');
        }
    }

    function setRegisterRole(role) {
        document.getElementById('register-role').value = role;
        ['borrower', 'owner'].forEach(r => {
            const btn = document.getElementById('reg-role-btn-' + r);
            btn.classList.toggle('selected', r.toUpperCase() === role);
        });
        document.getElementById('btn-submit-register').innerText = 
            role === 'BORROWER' ? 'Daftar sebagai Peminjam' : 'Daftar sebagai Pemilik Barang';
    }
    
    // Validasi password match
    document.getElementById('register-form').addEventListener('submit', function(e) {
        const password = document.getElementById('reg-password').value;
        const confirm = document.getElementById('confirm-password').value;
        
        if (password !== confirm) {
            e.preventDefault();
            alert('Kata sandi tidak cocok!');
            document.getElementById('confirm-password').focus();
            return;
        }
        if (password.length < 6) {
            e.preventDefault();
            alert('Kata sandi minimal 6 karakter!');
            document.getElementById('reg-password').focus();
        }
    });
    
    // Set default
    setRegisterRole('BORROWER');
</script>
</body>
</html>