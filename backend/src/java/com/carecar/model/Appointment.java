package com.carecar.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Appointment {
    private int appointmentId;
    private Integer customerId; // nullable
    private Integer carId;      // nullable
    private String customerName;
    private String phone;
    private String licensePlate;
    private String carBrandModel;
    private Date appointmentDate;
    private String timeSlot;
    private String requestedService;
    private String notes;
    private String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
    private Timestamp createdAt;

    public Appointment() {
    }

    public Appointment(int appointmentId, Integer customerId, Integer carId, String customerName, String phone, String licensePlate, String carBrandModel, Date appointmentDate, String timeSlot, String requestedService, String notes, String status, Timestamp createdAt) {
        this.appointmentId = appointmentId;
        this.customerId = customerId;
        this.carId = carId;
        this.customerName = customerName;
        this.phone = phone;
        this.licensePlate = licensePlate;
        this.carBrandModel = carBrandModel;
        this.appointmentDate = appointmentDate;
        this.timeSlot = timeSlot;
        this.requestedService = requestedService;
        this.notes = notes;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getCarId() {
        return carId;
    }

    public void setCarId(Integer carId) {
        this.carId = carId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getCarBrandModel() {
        return carBrandModel;
    }

    public void setCarBrandModel(String carBrandModel) {
        this.carBrandModel = carBrandModel;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getRequestedService() {
        return requestedService;
    }

    public void setRequestedService(String requestedService) {
        this.requestedService = requestedService;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
