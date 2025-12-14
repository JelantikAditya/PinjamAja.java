<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.NumberFormat, java.sql.*, com.pinjamaja.util.DBConnection"%>

<%
    // Format mata uang Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rpFormat = NumberFormat.getCurrencyInstance(indonesia);

    // Default values
    int userCount = 0;
    int itemCount = 0;
    int bookingCount = 0;
    double totalPayments = 0.0;

    List<Map<String, Object>> recentBookings = new ArrayList<>();
    List<Map<String, Object>> recentPayments = new ArrayList<>();
    List<Map<String, Object>> usersList = new ArrayList<>();

    // Query DB for platform-wide stats and recent activity
    try (Connection conn = DBConnection.getConnection()) {
        // Users count
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as c FROM users");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) userCount = rs.getInt("c");
        }

        // Items count
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as c FROM items");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) itemCount = rs.getInt("c");
        }

        // Bookings count
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as c FROM bookings");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) bookingCount = rs.getInt("c");
        }

        // Total payments volume
        try (PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(amount),0) as s FROM payments");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalPayments = rs.getDouble("s");
        }

        // Recent bookings (latest 10)
        String bookingsSql = "SELECT b.id, i.name as item_title, i.image_url as item_image_url, " +
                             "u.name as borrower_name, o.name as owner_name, b.start_date, b.end_date, b.total_price, b.status, b.payment_status " +
                             "FROM bookings b " +
                             "JOIN items i ON b.item_id = i.id " +
                             "JOIN users u ON b.borrower_id = u.id " +
                             "JOIN users o ON i.owner_id = o.id " +
                             "ORDER BY b.created_at DESC LIMIT 10";
        try (PreparedStatement ps = conn.prepareStatement(bookingsSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("itemTitle", rs.getString("item_title"));
                m.put("itemImageUrl", rs.getString("item_image_url"));
                m.put("borrowerName", rs.getString("borrower_name"));
                m.put("ownerName", rs.getString("owner_name"));
                m.put("startDate", rs.getDate("start_date") != null ? rs.getDate("start_date").toString() : "");
                m.put("endDate", rs.getDate("end_date") != null ? rs.getDate("end_date").toString() : "");
                m.put("totalPrice", rs.getDouble("total_price"));
                m.put("status", rs.getString("status"));
                m.put("paymentStatus", rs.getString("payment_status") == null ? "UNPAID" : rs.getString("payment_status"));
                recentBookings.add(m);
            }
        }

        // Recent payments (latest 10)
        String paymentsSql = "SELECT p.id, p.booking_id, p.amount, p.method, p.payer_id, p.paid_at FROM payments p ORDER BY p.paid_at DESC LIMIT 10";
        try (PreparedStatement ps = conn.prepareStatement(paymentsSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("bookingId", rs.getString("booking_id"));
                m.put("amount", rs.getDouble("amount"));
                m.put("method", rs.getString("method"));
                m.put("payerId", rs.getString("payer_id"));
                m.put("paidAt", rs.getTimestamp("paid_at"));
                recentPayments.add(m);
            }
        }
        // Users list (latest 50)
        String usersSql = "SELECT id, name, email, role, is_verified FROM users ORDER BY created_at DESC LIMIT 50";
        try (PreparedStatement ps = conn.prepareStatement(usersSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("name", rs.getString("name"));
                m.put("email", rs.getString("email"));
                m.put("role", rs.getString("role"));
                m.put("isVerified", rs.getBoolean("is_verified"));
                usersList.add(m);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
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
                        <div class="text-2xl font-bold"><%= userCount %></div>
                        <p class="text-xs text-muted-foreground">Total pengguna terdaftar</p>
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
                        <p class="text-xs text-muted-foreground">Total volume: <%= rpFormat.format(totalPayments) %></p>
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
                                    <% for (Map<String,Object> b : recentBookings) {
                                        String status = (String) b.get("status");
                                        String paymentStatus = (String) b.get("paymentStatus");
                                        String statusCls = "bg-gray-100 text-gray-800";
                                        if ("PENDING".equals(status)) statusCls = "bg-yellow-50 text-yellow-700";
                                        else if ("APPROVED".equals(status) || "ONGOING".equals(status)) statusCls = "bg-blue-50 text-blue-700";
                                        else if ("COMPLETED".equals(status) || "FINISHED".equals(status)) statusCls = "bg-green-50 text-green-700";
                                    %>
                                    <tr class="border-b transition-colors hover:bg-muted/50">
                                        <td class="p-4 align-middle font-mono text-xs"><%= b.get("id") %></td>
                                        <td class="p-4 align-middle">
                                            <div class="flex items-center gap-3">
                                                <img src="<%= b.get("itemImageUrl") %>" class="w-10 h-10 rounded object-cover bg-gray-100" />
                                                <div><%= b.get("itemTitle") %></div>
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle">
                                            <div class="flex flex-col text-xs">
                                                <span class="text-muted-foreground">P: <%= b.get("ownerName") %></span>
                                                <span class="text-muted-foreground">B: <%= b.get("borrowerName") %></span>
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle">
                                            <div class="flex items-center gap-2">
                                                <span class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold <%= statusCls %>"><%= status %></span>
                                                <span class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold <%= "PAID".equals(paymentStatus) ? "bg-green-50 text-green-700" : "bg-red-50 text-red-700" %>"><%= "PAID".equals(paymentStatus) ? "Dibayar" : "Belum Dibayar" %></span>
                                            </div>
                                        </td>
                                        <td class="p-4 align-middle"><%= rpFormat.format(b.get("totalPrice")) %></td>
                                        <td class="p-4 align-middle text-right">
                                            <a href="BookingServlet?view=<%= b.get("id") %>" class="inline-flex items-center justify-center rounded-md text-sm font-medium h-10 w-10 hover:bg-accent hover:text-accent-foreground">
                                                <i data-lucide="more-horizontal" class="w-4 h-4"></i>
                                            </a>
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
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Nama</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Email</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Peran</th>
                                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Status</th>
                                        <th class="h-12 px-4 text-right align-middle font-medium text-muted-foreground">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody class="[&_tr:last-child]:border-0">
                                    <% if (usersList.isEmpty()) { %>
                                        <tr><td class="p-4" colspan="5">Belum ada pengguna terdaftar.</td></tr>
                                    <% } else { %>
                                        <% for (Map<String,Object> u : usersList) {
                                            boolean isVerified = Boolean.TRUE.equals(u.get("isVerified"));
                                        %>
                                        <tr class="border-b transition-colors hover:bg-muted/50">
                                            <td class="p-4 align-middle font-medium"><%= u.get("name") %></td>
                                            <td class="p-4 align-middle text-xs text-gray-600"><%= u.get("email") %></td>
                                            <td class="p-4 align-middle"><%= u.get("role") %></td>
                                            <td class="p-4 align-middle">
                                                <% if (isVerified) { %>
                                                    <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors bg-green-100 text-green-700">Terverifikasi</div>
                                                <% } else { %>
                                                    <div class="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors bg-red-50 text-red-700">Belum Diverifikasi</div>
                                                <% } %>
                                            </td>
                                            <td class="p-4 align-middle text-right">
                                                <form action="admin/user" method="POST" style="display:inline;" onsubmit="return confirm('Hapus akun ini?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="userId" value="<%= u.get("id") %>">
                                                    <button type="submit" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-red-50 text-red-600 h-9 px-3">Hapus</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    <% } %>
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