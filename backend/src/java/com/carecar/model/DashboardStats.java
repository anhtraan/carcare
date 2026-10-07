package com.carecar.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class DashboardStats {
    private BigDecimal todayRevenue = BigDecimal.ZERO;
    private BigDecimal monthlyRevenue = BigDecimal.ZERO;
    private int todayAppointments;
    private int activeRepairOrders;
    private int completedOrdersThisMonth;
    private int lowStockCount;
    private int totalCustomers;
    private int totalCars;

    private List<RepairOrder> recentOrders = new ArrayList<>();
    private List<Appointment> todayAppointmentsList = new ArrayList<>();
    private List<SparePart> lowStockParts = new ArrayList<>();

    public DashboardStats() {
    }

    public BigDecimal getTodayRevenue() {
        return todayRevenue;
    }

    public void setTodayRevenue(BigDecimal todayRevenue) {
        this.todayRevenue = todayRevenue;
    }

    public BigDecimal getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(BigDecimal monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }

    public int getTodayAppointments() {
        return todayAppointments;
    }

    public void setTodayAppointments(int todayAppointments) {
        this.todayAppointments = todayAppointments;
    }

    public int getActiveRepairOrders() {
        return activeRepairOrders;
    }

    public void setActiveRepairOrders(int activeRepairOrders) {
        this.activeRepairOrders = activeRepairOrders;
    }

    public int getCompletedOrdersThisMonth() {
        return completedOrdersThisMonth;
    }

    public void setCompletedOrdersThisMonth(int completedOrdersThisMonth) {
        this.completedOrdersThisMonth = completedOrdersThisMonth;
    }

    public int getLowStockCount() {
        return lowStockCount;
    }

    public void setLowStockCount(int lowStockCount) {
        this.lowStockCount = lowStockCount;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getTotalCars() {
        return totalCars;
    }

    public void setTotalCars(int totalCars) {
        this.totalCars = totalCars;
    }

    public List<RepairOrder> getRecentOrders() {
        return recentOrders;
    }

    public void setRecentOrders(List<RepairOrder> recentOrders) {
        this.recentOrders = recentOrders;
    }

    public List<Appointment> getTodayAppointmentsList() {
        return todayAppointmentsList;
    }

    public void setTodayAppointmentsList(List<Appointment> todayAppointmentsList) {
        this.todayAppointmentsList = todayAppointmentsList;
    }

    public List<SparePart> getLowStockParts() {
        return lowStockParts;
    }

    public void setLowStockParts(List<SparePart> lowStockParts) {
        this.lowStockParts = lowStockParts;
    }
}
