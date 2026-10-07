package com.carecar.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FormatUtil {

    private static final DecimalFormat CURRENCY_FORMAT = new DecimalFormat("#,###");
    private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");

    public static String formatCurrency(BigDecimal amount) {
        if (amount == null) {
            return "0 ₫";
        }
        return CURRENCY_FORMAT.format(amount) + " ₫";
    }

    public static String formatCurrency(double amount) {
        return CURRENCY_FORMAT.format(amount) + " ₫";
    }

    public static String formatDateTime(Date date) {
        if (date == null) {
            return "—";
        }
        return DATE_TIME_FORMAT.format(date);
    }

    public static String formatDate(Date date) {
        if (date == null) {
            return "—";
        }
        return DATE_FORMAT.format(date);
    }

    public static String getOrderStatusText(String status) {
        if (status == null) return "Không xác định";
        switch (status) {
            case "PENDING_INSPECTION":
                return "Chờ tiếp nhận & Kiểm tra";
            case "DIAGNOSED_QUOTED":
                return "Đã kiểm tra & Chờ duyệt báo giá";
            case "IN_PROGRESS":
                return "Đang tiến hành sửa chữa";
            case "COMPLETED_WAITING_PAYMENT":
                return "Sửa chữa xong (Chờ thanh toán)";
            case "PAID_DELIVERED":
                return "Đã thanh toán & Đã giao xe";
            case "CANCELLED":
                return "Đã hủy lệnh";
            default:
                return status;
        }
    }

    public static String getOrderStatusBadgeClass(String status) {
        if (status == null) return "badge-secondary";
        switch (status) {
            case "PENDING_INSPECTION":
                return "badge-warning";
            case "DIAGNOSED_QUOTED":
                return "badge-info";
            case "IN_PROGRESS":
                return "badge-primary";
            case "COMPLETED_WAITING_PAYMENT":
                return "badge-success";
            case "PAID_DELIVERED":
                return "badge-delivered";
            case "CANCELLED":
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }

    public static String getAppointmentStatusText(String status) {
        if (status == null) return "Chờ xử lý";
        switch (status) {
            case "PENDING":
                return "Chờ xác nhận";
            case "CONFIRMED":
                return "Đã xác nhận";
            case "COMPLETED":
                return "Đã hoàn thành";
            case "CANCELLED":
                return "Đã hủy";
            default:
                return status;
        }
    }

    public static String getAppointmentBadgeClass(String status) {
        if (status == null) return "badge-warning";
        switch (status) {
            case "PENDING":
                return "badge-warning";
            case "CONFIRMED":
                return "badge-info";
            case "COMPLETED":
                return "badge-success";
            case "CANCELLED":
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }
}
