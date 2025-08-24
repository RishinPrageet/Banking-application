package com.bank.model;

public class LoanEligibilityRequest {
    private int income;
    private int age;
    private String employment;
    private boolean hasGold;
    private boolean hasProperty;
    private boolean hasAdmission;
    private int businessVintage;
    private int turnover;

    public LoanEligibilityRequest() {
    }

    public LoanEligibilityRequest(int income, int age, String employment, boolean hasGold, boolean hasProperty, 
                                 boolean hasAdmission, int businessVintage, int turnover) {
        this.income = income;
        this.age = age;
        this.employment = employment;
        this.hasGold = hasGold;
        this.hasProperty = hasProperty;
        this.hasAdmission = hasAdmission;
        this.businessVintage = businessVintage;
        this.turnover = turnover;
    }

    public int getIncome() {
        return income;
    }

    public void setIncome(int income) {
        this.income = income;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getEmployment() {
        return employment;
    }

    public void setEmployment(String employment) {
        this.employment = employment;
    }

    public boolean isHasGold() {
        return hasGold;
    }

    public void setHasGold(boolean hasGold) {
        this.hasGold = hasGold;
    }

    public boolean isHasProperty() {
        return hasProperty;
    }

    public void setHasProperty(boolean hasProperty) {
        this.hasProperty = hasProperty;
    }

    public boolean isHasAdmission() {
        return hasAdmission;
    }

    public void setHasAdmission(boolean hasAdmission) {
        this.hasAdmission = hasAdmission;
    }

    public int getBusinessVintage() {
        return businessVintage;
    }

    public void setBusinessVintage(int businessVintage) {
        this.businessVintage = businessVintage;
    }

    public int getTurnover() {
        return turnover;
    }

    public void setTurnover(int turnover) {
        this.turnover = turnover;
    }
}
