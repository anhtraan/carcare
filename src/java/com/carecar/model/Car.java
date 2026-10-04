package com.carecar.model;

import java.sql.Timestamp;

public class Car {
    private int carId;
    private int customerId;
    private String licensePlate;
    private String brand;
    private String model;
    private Integer yearManufactured;
    private String color;
    private String vinNumber;
    private int currentMileage;
    private String notes;
    private Timestamp createdAt;

    // Auxiliary field
    private String customerName;
    private String customerPhone;

    public Car() {
    }

    public Car(int carId, int customerId, String licensePlate, String brand, String model, Integer yearManufactured, String color, String vinNumber, int currentMileage, String notes, Timestamp createdAt) {
        this.carId = carId;
        this.customerId = customerId;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.yearManufactured = yearManufactured;
        this.color = color;
        this.vinNumber = vinNumber;
        this.currentMileage = currentMileage;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Integer getYearManufactured() {
        return yearManufactured;
    }

    public void setYearManufactured(Integer yearManufactured) {
        this.yearManufactured = yearManufactured;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getVinNumber() {
        return vinNumber;
    }

    public void setVinNumber(String vinNumber) {
        this.vinNumber = vinNumber;
    }

    public int getCurrentMileage() {
        return currentMileage;
    }

    public void setCurrentMileage(int currentMileage) {
        this.currentMileage = currentMileage;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getFullCarInfo() {
        return brand + " " + model + " (" + licensePlate + ")";
    }
}
