package com.carecar.controller;

import com.carecar.dal.InvoiceDAO;
import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.Invoice;
import com.carecar.model.RepairOrder;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminInvoiceController", urlPatterns = {"/admin/invoices", "/admin/invoice-detail", "/admin/checkout"})
public class AdminInvoiceController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminInvoiceController.class.getName());

    private static final InvoiceDAO INVOICE_DAO = new InvoiceDAO();
    private static final RepairOrderDAO REPAIR_ORDER_DAO = new RepairOrderDAO();

    private static final String INVOICES_URL = "/admin/invoices";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/invoice-detail".equals(path)) {
            showInvoiceDetail(request, response);
            return;
        }

        List<Invoice> list = INVOICE_DAO.getAllInvoices();
        request.setAttribute("invoices", list);
        safeForward(request, response, "/WEB-INF/views/admin/invoices.jsp");
    }

    private void showInvoiceDetail(HttpServletRequest request, HttpServletResponse response) {
        int invId = parseIntegerParam(request.getParameter("id"));
        int orderId = parseIntegerParam(request.getParameter("orderId"));
        Invoice invoice = null;

        if (invId > 0) {
            invoice = INVOICE_DAO.getInvoiceById(invId);
        } else if (orderId > 0) {
            invoice = INVOICE_DAO.getInvoiceByOrderId(orderId);
        }

        if (invoice != null) {
            RepairOrder order = REPAIR_ORDER_DAO.getOrderById(invoice.getOrderId());
            request.setAttribute("invoice", invoice);
            request.setAttribute("order", order);
            safeForward(request, response, "/WEB-INF/views/admin/invoice-detail.jsp");
        } else {
            safeRedirect(request, response, INVOICES_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            processCheckout(request, response);
            return;
        }

        safeRedirect(request, response, INVOICES_URL);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response) {
        int orderId = parseIntegerParam(request.getParameter("orderId"));
        if (orderId <= 0) {
            safeRedirect(request, response, INVOICES_URL);
            return;
        }

        RepairOrder order = REPAIR_ORDER_DAO.getOrderById(orderId);
        if (order == null) {
            safeRedirect(request, response, INVOICES_URL);
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        Invoice invoice = new Invoice();
        invoice.setOrderId(orderId);
        invoice.setAmountPaid(order.getGrandTotal());
        invoice.setPaymentMethod(paymentMethod != null ? paymentMethod : "CASH");
        invoice.setPaymentStatus("PAID");
        invoice.setCreatedBy(currentUser != null ? currentUser.getUserId() : null);
        invoice.setNotes(notes);

        int invoiceId = INVOICE_DAO.createInvoice(invoice);
        if (invoiceId > 0) {
            safeRedirect(request, response, "/admin/invoice-detail?id=" + invoiceId + "&msg=paid_success");
        } else {
            safeRedirect(request, response, INVOICES_URL);
        }
    }

    private void safeForward(HttpServletRequest request, HttpServletResponse response, String viewPath) {
        try {
            request.getRequestDispatcher(viewPath).forward(request, response);
        } catch (ServletException | IOException e) {
            LOGGER.log(Level.SEVERE, e, () -> "Lỗi chuyển tiếp trang: " + viewPath);
        }
    }

    private void safeRedirect(HttpServletRequest request, HttpServletResponse response, String redirectPath) {
        try {
            response.sendRedirect(request.getContextPath() + redirectPath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, e, () -> "Lỗi điều hướng trang: " + redirectPath);
        }
    }

    private int parseIntegerParam(String param) {
        if (param == null || param.trim().isEmpty()) {
            return -1;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.FINE, "Chuỗi tham số số không hợp lệ: {0}", e.getMessage());
            return -1;
        }
    }
}
