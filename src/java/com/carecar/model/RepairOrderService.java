package com.carecar.model;

import java.math.BigDecimal;

public class RepairOrderService {
    private int orderServiceId;
    private int orderId;
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    private int quantity;
    private BigDecimal subtotal;
    private String notes;

    public RepairOrderService() {
    }

    public RepairOrderService(int orderServiceId, int orderId, int serviceId, String serviceName, BigDecimal price, int quantity, BigDecimal subtotal, String notes) {
        this.orderServiceId = orderServiceId;
        this.orderId = orderId;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = subtotal;
        this.notes = notes;
    }

    public int getOrderServiceId() {
        return orderServiceId;
    }

    public void setOrderServiceId(int orderServiceId) {
        this.orderServiceId = orderServiceId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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
        if (price != null) {
            return price.multiply(BigDecimal.valueOf(quantity));
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
