package com.bank.model;

import java.sql.Timestamp;

public class UserLoan {
    private int id;
    private int userId;
    private int loanId;
    private double loanAmount;
    private Timestamp startDate;
    private Timestamp endDate;
    private String status;

    public UserLoan() {
    }

    public UserLoan(int id, int userId, int loanId, double loanAmount, Timestamp startDate, Timestamp endDate, String status) {
        this.id = id;
        this.userId = userId;
        this.loanId = loanId;
        this.loanAmount = loanAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getLoanId() {
        return loanId;
    }

    public void setLoanId(int loanId) {
        this.loanId = loanId;
    }

    public double getLoanAmount() {
        return loanAmount;
    }

    public void setLoanAmount(double loanAmount) {
        this.loanAmount = loanAmount;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "UserLoan{" +
                "id=" + id +
                ", userId=" + userId +
                ", loanId=" + loanId +
                ", loanAmount=" + loanAmount +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                '}';
    }
}
