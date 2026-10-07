package com.carecar.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class RepairOrder {
    private int orderId;
    private String orderCode;
    private int customerId;
    private int carId;
    private Integer receptionistId;
    private Integer mechanicId;
    private Timestamp entryDate;
    private Timestamp expectedFinishDate;
    private Timestamp actualFinishDate;
    private Integer entryMileage;
    private String initialDiagnosis;
    private String technicianNotes;
    private BigDecimal totalServiceCost = BigDecimal.ZERO;
    private BigDecimal totalPartCost = BigDecimal.ZERO;
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal taxVat = BigDecimal.ZERO;
    private BigDecimal grandTotal = BigDecimal.ZERO;
    private String orderStatus; // PENDING_INSPECTION, DIAGNOSED_QUOTED, IN_PROGRESS, COMPLETED_WAITING_PAYMENT, PAID_DELIVERED, CANCELLED
    private Timestamp createdAt;

    // Joined / Auxiliary Data
    private String customerName;
    private String customerPhone;
    private String customerAddress;
    private String carLicensePlate;
    private String carBrand;
    private String carModel;
    private String carColor;
    private String receptionistName;
    private String mechanicName;

    private List<RepairOrderService> services = new ArrayList<>();
    private List<RepairOrderPart> parts = new ArrayList<>();
    private Invoice invoice;

    public RepairOrder() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public Integer getReceptionistId() {
        return receptionistId;
    }

    public void setReceptionistId(Integer receptionistId) {
        this.receptionistId = receptionistId;
    }

    public Integer getMechanicId() {
        return mechanicId;
    }

    public void setMechanicId(Integer mechanicId) {
        this.mechanicId = mechanicId;
    }

    public Timestamp getEntryDate() {
        return entryDate;
    }

    public void setEntryDate(Timestamp entryDate) {
        this.entryDate = entryDate;
    }

    public Timestamp getExpectedFinishDate() {
        return expectedFinishDate;
    }

    public void setExpectedFinishDate(Timestamp expectedFinishDate) {
        this.expectedFinishDate = expectedFinishDate;
    }

    public Timestamp getActualFinishDate() {
        return actualFinishDate;
    }

    public void setActualFinishDate(Timestamp actualFinishDate) {
        this.actualFinishDate = actualFinishDate;
    }

    public Integer getEntryMileage() {
        return entryMileage;
    }

    public void setEntryMileage(Integer entryMileage) {
        this.entryMileage = entryMileage;
    }

    public String getInitialDiagnosis() {
        return initialDiagnosis;
    }

    public void setInitialDiagnosis(String initialDiagnosis) {
        this.initialDiagnosis = initialDiagnosis;
    }

    public String getTechnicianNotes() {
        return technicianNotes;
    }

    public void setTechnicianNotes(String technicianNotes) {
        this.technicianNotes = technicianNotes;
    }

    public BigDecimal getTotalServiceCost() {
        return totalServiceCost != null ? totalServiceCost : BigDecimal.ZERO;
    }

    public void setTotalServiceCost(BigDecimal totalServiceCost) {
        this.totalServiceCost = totalServiceCost;
    }

    public BigDecimal getTotalPartCost() {
        return totalPartCost != null ? totalPartCost : BigDecimal.ZERO;
    }

    public void setTotalPartCost(BigDecimal totalPartCost) {
        this.totalPartCost = totalPartCost;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount != null ? discountAmount : BigDecimal.ZERO;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getTaxVat() {
        return taxVat != null ? taxVat : BigDecimal.ZERO;
    }

    public void setTaxVat(BigDecimal taxVat) {
        this.taxVat = taxVat;
    }

    public BigDecimal getGrandTotal() {
        return grandTotal != null ? grandTotal : BigDecimal.ZERO;
    }

    public void setGrandTotal(BigDecimal grandTotal) {
        this.grandTotal = grandTotal;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
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

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCarLicensePlate() {
        return carLicensePlate;
    }

    public void setCarLicensePlate(String carLicensePlate) {
        this.carLicensePlate = carLicensePlate;
    }

    public String getCarBrand() {
        return carBrand;
    }

    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getCarColor() {
        return carColor;
    }

    public void setColor(String carColor) {
        this.carColor = carColor;
    }

    public String getReceptionistName() {
        return receptionistName;
    }

    public void setReceptionistName(String receptionistName) {
        this.receptionistName = receptionistName;
    }

    public String getMechanicName() {
        return mechanicName;
    }

    public void setMechanicName(String mechanicName) {
        this.mechanicName = mechanicName;
    }

    public List<RepairOrderService> getServices() {
        return services;
    }

    public void setServices(List<RepairOrderService> services) {
        this.services = services;
    }

    public List<RepairOrderPart> getParts() {
        return parts;
    }

    public void setParts(List<RepairOrderPart> parts) {
        this.parts = parts;
    }

    public Invoice getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice invoice) {
        this.invoice = invoice;
    }

    public String getCarFullTitle() {
        return (carBrand != null ? carBrand : "") + " " + (carModel != null ? carModel : "") + " - [" + (carLicensePlate != null ? carLicensePlate : "") + "]";
    }
}
