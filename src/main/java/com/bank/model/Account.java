package com.bank.model;

import java.time.LocalDate;

public class Account {
    private int id;
    private int amount;     
    private String accountType = "SAVINGS"; // Default account type
    private LocalDate creationDate;
    private double interestRate = 0.0; // Default interest rate

    public Account(int id, int amount) {
        this.id = id;
        this.amount = amount;
    }

    public Account(int id, int amount, String accountType) {
        this.id = id;
        this.amount = amount;
        this.accountType = accountType;
    }

    public Account(int id, int amount, String accountType, double interestRate) {
        this.id = id;
        this.amount = amount;
        this.accountType = accountType;
        this.interestRate = interestRate;
    }

    public Account(int id, int amount, String accountType, LocalDate creationDate) {
        this.id = id;
        this.amount = amount;
        this.accountType = accountType;
        this.creationDate = creationDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public LocalDate getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDate creationDate) {
        this.creationDate = creationDate ;
    }

    public double getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }

    // Calculate interest for a given number of years
    public double calculateInterest(int years) {
        return amount * (interestRate / 100) * years;
    }

    // Calculate future value after a given number of years
    public double calculateFutureValue(int years) {
        return amount + calculateInterest(years);
    }
}
