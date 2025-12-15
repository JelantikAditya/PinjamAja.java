-- Database: pinjamaja
CREATE DATABASE IF NOT EXISTS pinjamaja;
USE pinjamaja;

-- Tabel Users (Single Table Inheritance)
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('BORROWER', 'OWNER', 'ADMIN') NOT NULL,
    balance DOUBLE DEFAULT 0,
    store_name VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Items (Barang)
-- Kolom category, image_url, rating, dan review_count sudah dimasukkan di sini
CREATE TABLE items (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    price_per_day DOUBLE NOT NULL,
    rating DOUBLE DEFAULT 0,
    review_count INT DEFAULT 0,
    owner_id VARCHAR(50) NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel Bookings (Peminjaman)
-- Kolom payment_status sudah dimasukkan di sini
CREATE TABLE bookings (
    id VARCHAR(50) PRIMARY KEY,
    borrower_id VARCHAR(50) NOT NULL,
    item_id VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'ONGOING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    payment_status VARCHAR(32) DEFAULT 'UNPAID',
    total_price DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (borrower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

-- Tabel Payments 
-- ID disesuaikan menjadi VARCHAR(50) agar konsisten dengan tabel lain
CREATE TABLE payments (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    amount DOUBLE,
    method VARCHAR(64),
    payer_id VARCHAR(50),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE SET NULL,
    FOREIGN KEY (payer_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Tabel Reviews
CREATE TABLE reviews (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- Tabel Notifications
CREATE TABLE notifications (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('EMAIL', 'APP') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert Admin Default
INSERT INTO users (id, name, email, password, role, is_verified) 
VALUES ('ADM001', 'Admin Utama', 'admin@pinjamaja.com', MD5('admin123'), 'ADMIN', TRUE);
