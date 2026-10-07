package com.carecar.model;

import java.math.BigDecimal;

public class RepairOrderPart {
    private int orderPartId;
    private int orderId;
    private int partId;
    private String partCode;
    private String partName;
    private BigDecimal unitPrice;
    private int quantity;
    private BigDecimal subtotal;
    private String notes;

    public RepairOrderPart() {
    }

    public RepairOrderPart(int orderPartId, int orderId, int partId, String partCode, String partName, BigDecimal unitPrice, int quantity, BigDecimal subtotal, String notes) {
        this.orderPartId = orderPartId;
        this.orderId = orderId;
        this.partId = partId;
        this.partCode = partCode;
        this.partName = partName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.subtotal = subtotal;
        this.notes = notes;
    }

    public int getOrderPartId() {
        return orderPartId;
    }

    public void setOrderPartId(int orderPartId) {
        this.orderPartId = orderPartId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        if (subtotal != null) {
            return subtotal;
        }
        if (unitPrice != null) {
            return unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
