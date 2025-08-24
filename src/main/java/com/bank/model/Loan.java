package com.bank.model;

public class Loan {
    private int id;
    private String loanType;
    private double interestRate;
    private double maxAmount;
    private int durationMonths;
    private String eligibilityCriteria;

    public Loan() {
    }

    public Loan(int id, String loanType, double interestRate, double maxAmount, int durationMonths, String eligibilityCriteria) {
        this.id = id;
        this.loanType = loanType;
        this.interestRate = interestRate;
        this.maxAmount = maxAmount;
        this.durationMonths = durationMonths;
        this.eligibilityCriteria = eligibilityCriteria;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLoanType() {
        return loanType;
    }

    public void setLoanType(String loanType) {
        this.loanType = loanType;
    }

    public double getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }

    public double getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(double maxAmount) {
        this.maxAmount = maxAmount;
    }

    public int getDurationMonths() {
        return durationMonths;
    }

    public void setDurationMonths(int durationMonths) {
        this.durationMonths = durationMonths;
    }

    public String getEligibilityCriteria() {
        return eligibilityCriteria;
    }

    public void setEligibilityCriteria(String eligibilityCriteria) {
        this.eligibilityCriteria = eligibilityCriteria;
    }

    @Override
    public String toString() {
        return "Loan{" +
                "id=" + id +
                ", loanType='" + loanType + '\'' +
                ", interestRate=" + interestRate +
                ", maxAmount=" + maxAmount +
                ", durationMonths=" + durationMonths +
                ", eligibilityCriteria='" + eligibilityCriteria + '\'' +
                '}';
    }
}
