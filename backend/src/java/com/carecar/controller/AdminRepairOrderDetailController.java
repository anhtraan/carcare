package com.carecar.controller;

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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminRepairOrderDetailController", urlPatterns = {"/admin/repair-order-detail"})
public class AdminRepairOrderDetailController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminRepairOrderDetailController.class.getName());

    private static final RepairOrderDAO REPAIR_ORDER_DAO = new RepairOrderDAO();
    private static final ServiceDAO SERVICE_DAO = new ServiceDAO();
    private static final SparePartDAO SPARE_PART_DAO = new SparePartDAO();
    private static final UserDAO USER_DAO = new UserDAO();
    private static final InvoiceDAO INVOICE_DAO = new InvoiceDAO();

    private static final String REPAIR_ORDERS_URL = "/admin/repair-orders";
    private static final String DETAIL_URL_PREFIX = "/admin/repair-order-detail?id=";
    private static final String PARAM_QUANTITY = "quantity";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = parseIntegerParam(request.getParameter("id"), -1);
        if (orderId <= 0) {
            safeRedirect(request, response, REPAIR_ORDERS_URL);
            return;
        }

        RepairOrder order = REPAIR_ORDER_DAO.getOrderById(orderId);
        if (order == null) {
            safeRedirect(request, response, REPAIR_ORDERS_URL + "?error=not_found");
            return;
        }

        List<ServiceItem> allServices = SERVICE_DAO.getActiveServices();
        List<SparePart> allParts = SPARE_PART_DAO.getAllParts();
        List<User> mechanics = USER_DAO.getMechanics();
        Invoice invoice = INVOICE_DAO.getInvoiceByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("allServices", allServices);
        request.setAttribute("allParts", allParts);
        request.setAttribute("mechanics", mechanics);
        request.setAttribute("invoice", invoice);

        safeForward(request, response, "/WEB-INF/views/admin/repair-order-detail.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = parseIntegerParam(request.getParameter("orderId"), -1);
        if (orderId <= 0) {
            safeRedirect(request, response, REPAIR_ORDERS_URL);
            return;
        }

        String action = request.getParameter("action");
        String messageKey = executePostAction(action, orderId, request);

        if (messageKey != null && !messageKey.isEmpty()) {
            safeRedirect(request, response, DETAIL_URL_PREFIX + orderId + "&msg=" + messageKey);
        } else {
            safeRedirect(request, response, DETAIL_URL_PREFIX + orderId);
        }
    }

    private String executePostAction(String action, int orderId, HttpServletRequest request) {
        if (action == null) {
            return null;
        }
        return switch (action) {
            case "updateDiagnosis" -> handleUpdateDiagnosis(orderId, request);
            case "updateStatus" -> handleUpdateStatus(orderId, request);
            case "addService" -> handleAddService(orderId, request);
            case "removeService" -> handleRemoveService(orderId, request);
            case "addPart" -> handleAddPart(orderId, request);
            case "removePart" -> handleRemovePart(orderId, request);
            case "updateFinance" -> handleUpdateFinance(orderId, request);
            default -> null;
        };
    }

    private String handleUpdateDiagnosis(int orderId, HttpServletRequest request) {
        String initialDiagnosis = request.getParameter("initialDiagnosis");
        String technicianNotes = request.getParameter("technicianNotes");
        String mechIdStr = request.getParameter("mechanicId");
        String finishStr = request.getParameter("expectedFinishDate");

        Integer mechanicId = parseIntegerParam(mechIdStr, -1);
        if (mechanicId <= 0) {
            mechanicId = null;
        }

        Timestamp expectedFinish = null;
        if (finishStr != null && !finishStr.trim().isEmpty()) {
            try {
                expectedFinish = Timestamp.valueOf(finishStr.replace("T", " ") + ":00");
            } catch (IllegalArgumentException e) {
                LOGGER.log(Level.FINE, "Định dạng ngày hoàn thành dự kiến không hợp lệ", e);
            }
        }

        REPAIR_ORDER_DAO.updateOrderDiagnosis(orderId, initialDiagnosis, technicianNotes, mechanicId, expectedFinish);
        return "diagnosis_updated";
    }

    private String handleUpdateStatus(int orderId, HttpServletRequest request) {
        String newStatus = request.getParameter("newStatus");
        REPAIR_ORDER_DAO.updateOrderStatus(orderId, newStatus);
        return "status_updated";
    }

    private String handleAddService(int orderId, HttpServletRequest request) {
        String serviceSource = request.getParameter("serviceSource"); // "catalog" or "custom"
        int quantity = parseIntegerParam(request.getParameter(PARAM_QUANTITY), 1);
        if (quantity <= 0) {
            quantity = 1;
        }
        String notes = request.getParameter("notes");

        // Custom / Emergent Service added by Mechanic or Admin
        if ("custom".equalsIgnoreCase(serviceSource)
                || (request.getParameter("customServiceName") != null && !request.getParameter("customServiceName").trim().isEmpty() && parseIntegerParam(request.getParameter("serviceId"), -1) <= 0)) {
            String customServiceName = request.getParameter("customServiceName");
            String customCategory = request.getParameter("customCategory");
            if (customCategory == null || customCategory.trim().isEmpty()) {
                customCategory = "Sửa chữa phát sinh";
            }
            BigDecimal customCost = parseBigDecimalParam(request.getParameter("customLaborCost"));
            int duration = parseIntegerParam(request.getParameter("customDuration"), 30);

            if (customServiceName != null && !customServiceName.trim().isEmpty()) {
                ServiceItem newItem = new ServiceItem(0, customCategory.trim(), customServiceName.trim(),
                        notes != null ? notes.trim() : "", customCost, duration, "ACTIVE");
                int newServiceId = SERVICE_DAO.insertService(newItem);
                if (newServiceId > 0) {
                    REPAIR_ORDER_DAO.addServiceToOrder(orderId, newServiceId, customServiceName.trim(), customCost, quantity, notes);
                    return "service_added";
                }
            }
            return "service_add_error";
        }

        // Standard Catalog Service
        int serviceId = parseIntegerParam(request.getParameter("serviceId"), -1);
        ServiceItem item = (serviceId > 0) ? SERVICE_DAO.getServiceById(serviceId) : null;
        if (item != null) {
            BigDecimal price = item.getLaborCost();
            String customPriceStr = request.getParameter("customPrice");
            if (customPriceStr != null && !customPriceStr.trim().isEmpty()) {
                BigDecimal customPrice = parseBigDecimalParam(customPriceStr);
                if (customPrice.compareTo(BigDecimal.ZERO) >= 0) {
                    price = customPrice;
                }
            }
            REPAIR_ORDER_DAO.addServiceToOrder(orderId, serviceId, item.getServiceName(), price, quantity, notes);
            return "service_added";
        }
        return "service_add_error";
    }

    private String handleRemoveService(int orderId, HttpServletRequest request) {
        int orderServiceId = parseIntegerParam(request.getParameter("orderServiceId"), -1);
        if (orderServiceId > 0) {
            REPAIR_ORDER_DAO.removeServiceFromOrder(orderServiceId, orderId);
            return "service_removed";
        }
        return null;
    }

    private String handleAddPart(int orderId, HttpServletRequest request) {
        int partId = parseIntegerParam(request.getParameter("partId"), -1);
        SparePart part = (partId > 0) ? SPARE_PART_DAO.getPartById(partId) : null;
        if (part != null) {
            int quantity = parseIntegerParam(request.getParameter(PARAM_QUANTITY), 1);
            if (quantity <= 0) {
                quantity = 1;
            }
            String notes = request.getParameter("notes");
            REPAIR_ORDER_DAO.addPartToOrder(orderId, partId, part.getPartCode(), part.getPartName(), part.getUnitPrice(), quantity, notes);
            return "part_added";
        }
        return null;
    }

    private String handleRemovePart(int orderId, HttpServletRequest request) {
        int orderPartId = parseIntegerParam(request.getParameter("orderPartId"), -1);
        int partId = parseIntegerParam(request.getParameter("partId"), -1);
        int quantity = parseIntegerParam(request.getParameter(PARAM_QUANTITY), 1);
        if (orderPartId > 0 && partId > 0) {
            REPAIR_ORDER_DAO.removePartFromOrder(orderPartId, orderId, partId, quantity);
            return "part_removed";
        }
        return null;
    }

    private String handleUpdateFinance(int orderId, HttpServletRequest request) {
        BigDecimal discount = parseBigDecimalParam(request.getParameter("discountAmount"));
        BigDecimal tax = parseBigDecimalParam(request.getParameter("taxVat"));
        REPAIR_ORDER_DAO.updateDiscountAndTax(orderId, discount, tax);
        return "finance_updated";
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

    private int parseIntegerParam(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.FINE, "Không thể chuyển tham số sang số nguyên: {0}", e.getMessage());
            return defaultValue;
        }
    }

    private BigDecimal parseBigDecimalParam(String param) {
        if (param == null || param.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(param.replaceAll("[,\\s]", ""));
        } catch (Exception e) {
            LOGGER.log(Level.FINE, "Không thể chuyển tham số sang BigDecimal: {0}", e.getMessage());
            return BigDecimal.ZERO;
        }
    }
}
