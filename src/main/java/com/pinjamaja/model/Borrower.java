package com.pinjamaja.model;

public class Borrower extends User {
    private double balance;
    private boolean isVerified;
    
    public Borrower(String id, String name, String email, String password, double balance, boolean isVerified) {
        super(id, name, email, password, "BORROWER");
        this.balance = balance;
        this.isVerified = isVerified;
    }
    
    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean isVerified) { this.isVerified = isVerified; }
}