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
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminInvoiceController", urlPatterns = {"/admin/invoices", "/admin/invoice-detail", "/admin/checkout"})
public class AdminInvoiceController extends HttpServlet {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        if ("/admin/invoice-detail".equals(path)) {
            String invIdStr = request.getParameter("id");
            String orderIdStr = request.getParameter("orderId");
            Invoice invoice = null;

            if (invIdStr != null && !invIdStr.trim().isEmpty()) {
                invoice = invoiceDAO.getInvoiceById(Integer.parseInt(invIdStr));
            } else if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                invoice = invoiceDAO.getInvoiceByOrderId(Integer.parseInt(orderIdStr));
            }

            if (invoice != null) {
                RepairOrder order = repairOrderDAO.getOrderById(invoice.getOrderId());
                request.setAttribute("invoice", invoice);
                request.setAttribute("order", order);
                request.getRequestDispatcher("/WEB-INF/views/admin/invoice-detail.jsp").forward(request, response);
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/invoices");
                return;
            }
        }

        List<Invoice> list = invoiceDAO.getAllInvoices();
        request.setAttribute("invoices", list);
        request.getRequestDispatcher("/WEB-INF/views/admin/invoices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            RepairOrder order = repairOrderDAO.getOrderById(orderId);
            if (order != null) {
                String paymentMethod = request.getParameter("paymentMethod");
                String notes = request.getParameter("notes");

                HttpSession session = request.getSession(false);
                User currentUser = (User) session.getAttribute("currentUser");

                Invoice invoice = new Invoice();
                invoice.setOrderId(orderId);
                invoice.setAmountPaid(order.getGrandTotal());
                invoice.setPaymentMethod(paymentMethod != null ? paymentMethod : "CASH");
                invoice.setPaymentStatus("PAID");
                invoice.setCreatedBy(currentUser != null ? currentUser.getUserId() : null);
                invoice.setNotes(notes);

                int invoiceId = invoiceDAO.createInvoice(invoice);
                if (invoiceId > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/invoice-detail?id=" + invoiceId + "&msg=paid_success");
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/invoices");
    }
}
