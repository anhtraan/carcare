package com.carecar.controller;

import com.carecar.dal.CarDAO;
import com.carecar.dal.InvoiceDAO;
import com.carecar.dal.RepairOrderDAO;
import com.carecar.dal.ServiceDAO;
import com.carecar.dal.SparePartDAO;
import com.carecar.dal.UserDAO;
import com.carecar.model.Invoice;
import com.carecar.model.RepairOrder;
import com.carecar.model.ServiceItem;
import com.carecar.model.SparePart;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "AdminRepairOrderDetailController", urlPatterns = {"/admin/repair-order-detail"})
public class AdminRepairOrderDetailController extends HttpServlet {

    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private SparePartDAO sparePartDAO = new SparePartDAO();
    private UserDAO userDAO = new UserDAO();
    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private CarDAO carDAO = new CarDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/repair-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            RepairOrder order = repairOrderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/repair-orders?error=not_found");
                return;
            }

            List<ServiceItem> allServices = serviceDAO.getActiveServices();
            List<SparePart> allParts = sparePartDAO.getAllParts();
            List<User> mechanics = userDAO.getMechanics();
            Invoice invoice = invoiceDAO.getInvoiceByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("allServices", allServices);
            request.setAttribute("allParts", allParts);
            request.setAttribute("mechanics", mechanics);
            request.setAttribute("invoice", invoice);

            request.getRequestDispatcher("/WEB-INF/views/admin/repair-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/repair-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("orderId");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/repair-orders");
            return;
        }

        int orderId = Integer.parseInt(idStr);

        if ("updateDiagnosis".equals(action)) {
            String initialDiagnosis = request.getParameter("initialDiagnosis");
            String technicianNotes = request.getParameter("technicianNotes");
            String mechIdStr = request.getParameter("mechanicId");
            String finishStr = request.getParameter("expectedFinishDate");

            Integer mechanicId = (mechIdStr != null && !mechIdStr.trim().isEmpty()) ? Integer.parseInt(mechIdStr) : null;
            Timestamp expectedFinish = null;
            if (finishStr != null && !finishStr.trim().isEmpty()) {
                try {
                    expectedFinish = Timestamp.valueOf(finishStr.replace("T", " ") + ":00");
                } catch (Exception ignored) {
                }
            }

            repairOrderDAO.updateOrderDiagnosis(orderId, initialDiagnosis, technicianNotes, mechanicId, expectedFinish);
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=diagnosis_updated");
            return;
        }

        if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("newStatus");
            repairOrderDAO.updateOrderStatus(orderId, newStatus);
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=status_updated");
            return;
        }

        if ("addService".equals(action)) {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            ServiceItem item = serviceDAO.getServiceById(serviceId);
            if (item != null) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String notes = request.getParameter("notes");
                repairOrderDAO.addServiceToOrder(orderId, serviceId, item.getServiceName(), item.getLaborCost(), quantity, notes);
            }
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=service_added");
            return;
        }

        if ("removeService".equals(action)) {
            int orderServiceId = Integer.parseInt(request.getParameter("orderServiceId"));
            repairOrderDAO.removeServiceFromOrder(orderServiceId, orderId);
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=service_removed");
            return;
        }

        if ("addPart".equals(action)) {
            int partId = Integer.parseInt(request.getParameter("partId"));
            SparePart part = sparePartDAO.getPartById(partId);
            if (part != null) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String notes = request.getParameter("notes");
                repairOrderDAO.addPartToOrder(orderId, partId, part.getPartCode(), part.getPartName(), part.getUnitPrice(), quantity, notes);
            }
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=part_added");
            return;
        }

        if ("removePart".equals(action)) {
            int orderPartId = Integer.parseInt(request.getParameter("orderPartId"));
            int partId = Integer.parseInt(request.getParameter("partId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            repairOrderDAO.removePartFromOrder(orderPartId, orderId, partId, quantity);
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=part_removed");
            return;
        }

        if ("updateFinance".equals(action)) {
            String discountStr = request.getParameter("discountAmount");
            String taxStr = request.getParameter("taxVat");

            BigDecimal discount = BigDecimal.ZERO;
            BigDecimal tax = BigDecimal.ZERO;

            if (discountStr != null && !discountStr.trim().isEmpty()) {
                try {
                    discount = new BigDecimal(discountStr.replaceAll("[,\\s]", ""));
                } catch (Exception ignored) {
                }
            }
            if (taxStr != null && !taxStr.trim().isEmpty()) {
                try {
                    tax = new BigDecimal(taxStr.replaceAll("[,\\s]", ""));
                } catch (Exception ignored) {
                }
            }

            repairOrderDAO.updateDiscountAndTax(orderId, discount, tax);
            response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=finance_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId);
    }
}
