<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat"%>

<%
    // 1. DATA SIMULATION (MENGGANTIKAN useApp() di React)
    // Di aplikasi nyata, data ini diambil dari Database/Servlet
    
    // Format mata uang Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // Simulasi Data Transaksi (Bookings)
    class Booking {
        String id, itemTitle, ownerId, borrowerId, status;
        double totalPrice;
        public Booking(String id, String t, String o, String b, String s, double p) {
            this.id = id; this.itemTitle = t; this.ownerId = o; 
            this.borrowerId = b; this.status = s; this.totalPrice = p;
        }
    }

    List<Booking> bookings = new ArrayList<>();
    bookings.add(new Booking("TRX-001", "Kamera Sony A7III", "Sarah J.", "Budi S.", "Selesai", 450000));
    bookings.add(new Booking("TRX-002", "Lensa Canon 24-70mm", "Mike T.", "Andi R.", "Aktif", 250000));
    bookings.add(new Booking("TRX-003", "Drone DJI Mavic", "Sarah J.", "John D.", "Menunggu", 850000));

    // Simulasi Statistik
    int itemCount = 42; // items.length
    int bookingCount = bookings.size();
    String totalVolume = rpFormat.format(186000000);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        
        <link rel="stylesheet" href="css/style.css">

        <script>
            tailwind.config = {
                darkMode: 'class',
                theme: {
                    extend: {
                        colors: {
                            border: "var(--border)",
                            input: "var(--input)",
                            ring: "var(--ring)",
                            background: "var(--background)",
                            foreground: "var(--foreground)",
                            primary: {
                                DEFAULT: "var(--primary)",
                                foreground: "var(--primary-foreground)",
                            },
                            secondary: {
                                DEFAULT: "var(--secondary)",
                                foreground: "var(--secondary-foreground)",
                            },
                            destructive: {
                                DEFAULT: "var(--destructive)",
                                foreground: "var(--destructive-foreground)",
                            },
                            muted: {
                                DEFAULT: "var(--muted)",
                                foreground: "var(--muted-foreground)",
                            },
                            card: {
                                DEFAULT: "var(--card)",
                                foreground: "var(--card-foreground)",
                            },
                        },
                        borderRadius: {
                            lg: "var(--radius)",
                            md: "calc(var(--radius) - 2px)",
                            sm: "calc(var(--radius) - 4px)",
                        },
                    }
                }
            }
        </script>
        
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>
    <body class="bg-background text-foreground antialiased min-h-screen">
        
        <div class="container mx-auto px-4 py-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-8 dark:text-white">Konsol Admin</h1>
            
            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6 pb-2">
                        <h3 class="text-sm font-medium text-muted-foreground">Pengguna Platform</h3>
                    </div>
                    <div class="p-6 pt-0">
                        <div class="text-2xl font-bold">1,234</div>
                        <p class="text-xs text-green-600">+12% minggu ini</p>
                    </div>
                </div>

                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6 pb-2">
                        <h3 class="text-sm font-medium text-muted-foreground">Daftar Aktif</h3>
                    </div>
                    <div class="p-6 pt-0">
                        <div class="text-2xl font-bold"><%= itemCount %></div>
                        <p class="text-xs text-muted-foreground">Di 8 kategori</p>
                    </div>
                </div>

                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6 pb-2">
                        <h3 class="text-sm font-medium text-muted-foreground">Total Transaksi</h3>
                    </div>
                    <div class="p-6 pt-0">
                        <div class="text-2xl font-bold"><%= bookingCount %></div>
                        <p class="text-xs text-muted-foreground">Volume: <%= totalVolume %></p>
                    </div>
                </div>
            </div>

            <div class="space-y-8">
                
                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6">
                        <h3 class="text-2xl font-semibold leading-none tracking-tight">Transaksi Terkini</h3>
                    </div>
                    <div class="p-6 pt-0">
                        <div class="relative w-full overflow-auto">
                            <table class="w-full caption-bottom text-sm">
                                <thead class="[&_tr]:border-b">
                                    <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">ID</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Barang</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Pengguna (Pemilik / Peminjam)</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Status</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Jumlah</th>
                                        <th class="h-12 px-4 text-right align-middle font-medium text-muted-foreground">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody class="[&_tr:last-child]:border-0">
                                    
                                    <% for(Booking b : bookings) { %>
                                    <tr class="border-b transition-colors hover:bg-muted/50">
                                        <td class="p-4 align-middle font-mono text-xs"><%= b.id %></td>
                                        <td class="p-4 align-middle"><%= b.itemTitle %></td>
                                        <td class="p-4 align-middle">
                                            <div class="flex flex-col text-xs">
                                                <span class="text-muted-foreground">P: <%= b.ownerId %></span>
                                                <span class="text-muted-foreground">B: <%= b.borrowerId %></span>
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle">
                                            <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80">
                                                <%= b.status %>
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle"><%= rpFormat.format(b.totalPrice) %></td>
                                        <td class="p-4 align-middle text-right">
                                            <button class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-10 w-10">
                                                <i data-lucide="more-horizontal" class="w-4 h-4"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                    
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6">
                        <h3 class="text-2xl font-semibold leading-none tracking-tight">Manajemen Pengguna</h3>
                    </div>
                    <div class="p-6 pt-0">
                         <div class="relative w-full overflow-auto">
                            <table class="w-full caption-bottom text-sm">
                                <thead class="[&_tr]:border-b">
                                    <tr class="border-b transition-colors hover:bg-muted/50">
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Pengguna</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Peran</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Status</th>
                                        <th class="h-12 px-4 text-right align-middle font-medium text-muted-foreground">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody class="[&_tr:last-child]:border-0">
                                    <tr class="border-b transition-colors hover:bg-muted/50">
                                        <td class="p-4 align-middle font-medium">Sarah J.</td>
                                        <td class="p-4 align-middle">Pemilik</td>
                                        <td class="p-4 align-middle">
                                            <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors bg-green-100 text-green-700 hover:bg-green-200">
                                                Terverifikasi
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle text-right">
                                            <button class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-accent hover:text-accent-foreground h-9 px-3 text-red-500">
                                                <i data-lucide="shield-alert" class="w-4 h-4"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>