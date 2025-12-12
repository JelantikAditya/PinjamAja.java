package com.pinjamaja.model;

public class Owner extends User {
    private String storeName;
    private boolean isVerified;
    
    public Owner(String id, String name, String email, String password, String storeName, boolean isVerified) {
        super(id, name, email, password, "OWNER");
        this.storeName = storeName;
        this.isVerified = isVerified;
    }
    
    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean isVerified) { this.isVerified = isVerified; }
}