package com.carecar.model;

import java.math.BigDecimal;

public class ServiceItem {
    private int serviceId;
    private String category;
    private String serviceName;
    private String description;
    private BigDecimal laborCost;
    private int estimatedDuration; // in minutes
    private String status; // ACTIVE, INACTIVE

    public ServiceItem() {
    }

    public ServiceItem(int serviceId, String category, String serviceName, String description, BigDecimal laborCost, int estimatedDuration, String status) {
        this.serviceId = serviceId;
        this.category = category;
        this.serviceName = serviceName;
        this.description = description;
        this.laborCost = laborCost;
        this.estimatedDuration = estimatedDuration;
        this.status = status;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getLaborCost() {
        return laborCost;
    }

    public void setLaborCost(BigDecimal laborCost) {
        this.laborCost = laborCost;
    }

    public int getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(int estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
