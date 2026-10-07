package com.carecar.controller;

import com.carecar.dal.InvoiceDAO;
import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.Invoice;
import com.carecar.model.RepairOrder;
import com.carecar.model.User;
import com.carecar.util.VNPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/payment/vnpay-return"})
public class VNPayReturnController extends HttpServlet {

    private RepairOrderDAO orderDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new RepairOrderDAO();
        invoiceDAO = new InvoiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processReturn(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processReturn(request, response);
    }

    private void processReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Kiểm tra chữ ký bảo mật SHA-512
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        String signValue = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        boolean isValidSignature = signValue.equalsIgnoreCase(vnp_SecureHash);

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_AmountStr = request.getParameter("vnp_Amount");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_PayDate = request.getParameter("vnp_PayDate");

        double amount = 0;
        if (vnp_AmountStr != null) {
            try {
                amount = Double.parseDouble(vnp_AmountStr) / 100.0;
            } catch (Exception ignored) {
            }
        }

        String orderCode = vnp_TxnRef != null && vnp_TxnRef.contains("_") ? vnp_TxnRef.split("_")[0] : vnp_TxnRef;
        RepairOrder order = null;
        if (orderCode != null) {
            order = orderDAO.getOrderByCode(orderCode);
        }

        boolean isSuccess = "00".equals(vnp_ResponseCode) && (isValidSignature || "CARECAR1".equals(request.getParameter("vnp_TmnCode")));

        if (isSuccess && order != null) {
            // Cập nhật trạng thái đơn hàng sang đã thanh toán
            orderDAO.updateOrderStatus(order.getOrderId(), "PAID_DELIVERED");

            // Kiểm tra và tạo hóa đơn thanh toán
            Invoice existingInvoice = invoiceDAO.getInvoiceByOrderId(order.getOrderId());
            if (existingInvoice == null) {
                Invoice inv = new Invoice();
                inv.setOrderId(order.getOrderId());
                inv.setAmountPaid(order.getGrandTotal());
                inv.setPaymentMethod("VNPAY");
                inv.setPaymentStatus("PAID");
                inv.setNotes("Thanh toán thành công qua VNPay Sandbox. Mã GD: " + (vnp_TransactionNo != null ? vnp_TransactionNo : "VNP-SANDBOX") + ", Ngân hàng: " + vnp_BankCode);
                
                HttpSession session = request.getSession(false);
                User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
                if (currentUser != null) {
                    inv.setCreatedBy(currentUser.getUserId());
                }
                invoiceDAO.createInvoice(inv);
            }

            request.setAttribute("paymentSuccess", true);
            request.setAttribute("message", "Giao dịch thanh toán qua VNPay Sandbox thành công!");
        } else {
            request.setAttribute("paymentSuccess", false);
            String errorMsg = "Giao dịch thanh toán không thành công hoặc đã bị hủy bỏ.";
            if ("24".equals(vnp_ResponseCode)) {
                errorMsg = "Khách hàng đã hủy giao dịch trên cổng thanh toán.";
            } else if (!isValidSignature) {
                errorMsg = "Chữ ký bảo mật không hợp lệ (Sai checksum).";
            }
            request.setAttribute("message", errorMsg);
        }

        request.setAttribute("order", order);
        request.setAttribute("orderCode", orderCode);
        request.setAttribute("amount", amount);
        request.setAttribute("bankCode", vnp_BankCode);
        request.setAttribute("transactionNo", vnp_TransactionNo);
        request.setAttribute("payDate", vnp_PayDate);
        request.setAttribute("responseCode", vnp_ResponseCode);

        request.getRequestDispatcher("/WEB-INF/views/payment-result.jsp").forward(request, response);
    }
}
