package com.pinjamaja.model;

public class Barang {
    private String idBarang;
    private String namaBarang;
    private String deskripsi;
    private double hargaPerHari;
    private String ownerId;
    private boolean isAvailable;
    
    public Barang(String idBarang, String namaBarang, String deskripsi, double hargaPerHari, String ownerId, boolean isAvailable) {
        this.idBarang = idBarang;
        this.namaBarang = namaBarang;
        this.deskripsi = deskripsi;
        this.hargaPerHari = hargaPerHari;
        this.ownerId = ownerId;
        this.isAvailable = isAvailable;
    }
    
    // Getters and Setters
    public String getIdBarang() { return idBarang; }
    public void setIdBarang(String idBarang) { this.idBarang = idBarang; }
    public String getNamaBarang() { return namaBarang; }
    public void setNamaBarang(String namaBarang) { this.namaBarang = namaBarang; }
    public String getDeskripsi() { return deskripsi; }
    public void setDeskripsi(String deskripsi) { this.deskripsi = deskripsi; }
    public double getHargaPerHari() { return hargaPerHari; }
    public void setHargaPerHari(double hargaPerHari) { this.hargaPerHari = hargaPerHari; }
    public String getOwnerId() { return ownerId; }
    public void setOwnerId(String ownerId) { this.ownerId = ownerId; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }
}