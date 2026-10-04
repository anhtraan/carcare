package com.carecar.model;

import java.math.BigDecimal;

public class SparePart {
    private int partId;
    private String partCode;
    private String partName;
    private String category;
    private String unit;
    private BigDecimal unitPrice;
    private BigDecimal costPrice;
    private int quantityInStock;
    private int minStockAlert;
    private String location;
    private String status; // ACTIVE, INACTIVE

    public SparePart() {
    }

    public SparePart(int partId, String partCode, String partName, String category, String unit, BigDecimal unitPrice, BigDecimal costPrice, int quantityInStock, int minStockAlert, String location, String status) {
        this.partId = partId;
        this.partCode = partCode;
        this.partName = partName;
        this.category = category;
        this.unit = unit;
        this.unitPrice = unitPrice;
        this.costPrice = costPrice;
        this.quantityInStock = quantityInStock;
        this.minStockAlert = minStockAlert;
        this.location = location;
        this.status = status;
    }

    public int getPartId() {
        return partId;
    }

    public void setPartId(int partId) {
        this.partId = partId;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(BigDecimal costPrice) {
        this.costPrice = costPrice;
    }

    public int getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(int quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public int getMinStockAlert() {
        return minStockAlert;
    }

    public void setMinStockAlert(int minStockAlert) {
        this.minStockAlert = minStockAlert;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isLowStock() {
        return this.quantityInStock <= this.minStockAlert;
    }
}
