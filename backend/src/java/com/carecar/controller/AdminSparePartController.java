package com.carecar.controller;

import com.carecar.dal.SparePartDAO;
import com.carecar.model.SparePart;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminSparePartController", urlPatterns = {"/admin/spare-parts"})
public class AdminSparePartController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final SparePartDAO sparePartDAO = new SparePartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // 1. Kiểm tra xác thực & vai trò: Khách hàng tuyệt đối không có quyền vào trang quản lý kho
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }
        if (currentUser.isCustomer()) {
            response.sendRedirect(request.getContextPath() + "/customer/dashboard?error=access_denied");
            return;
        }

        String filter = request.getParameter("filter");
        List<SparePart> allParts = sparePartDAO.getAllParts();

        // 2. Tính toán các chỉ số thống kê kho
        int totalItems = allParts.size();
        int totalStockQuantity = 0;
        int lowStockCount = 0;
        int outOfStockCount = 0;
        BigDecimal totalInventoryValue = BigDecimal.ZERO;

        for (SparePart p : allParts) {
            int stock = p.getQuantityInStock();
            totalStockQuantity += stock;
            if (stock <= 0) {
                outOfStockCount++;
            } else if (p.isLowStock()) {
                lowStockCount++;
            }
            if (p.getCostPrice() != null && stock > 0) {
                totalInventoryValue = totalInventoryValue.add(p.getCostPrice().multiply(BigDecimal.valueOf(stock)));
            }
        }

        // 3. Lọc danh sách theo yêu cầu
        List<SparePart> displayList;
        if ("low_stock".equalsIgnoreCase(filter)) {
            displayList = sparePartDAO.getLowStockParts();
        } else if ("out_of_stock".equalsIgnoreCase(filter)) {
            displayList = new ArrayList<>();
            for (SparePart p : allParts) {
                if (p.getQuantityInStock() <= 0) {
                    displayList.add(p);
                }
            }
        } else {
            displayList = allParts;
        }

        request.setAttribute("parts", displayList);
        request.setAttribute("filter", filter);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalStockQuantity", totalStockQuantity);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("outOfStockCount", outOfStockCount);
        request.setAttribute("totalInventoryValue", totalInventoryValue);

        request.getRequestDispatcher("/WEB-INF/views/admin/spare-parts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // 1. Phân quyền nghiêm ngặt: CHỈ ADMIN mới có quyền nhập hàng, thêm phụ tùng hoặc sửa đổi số lượng tồn kho!
        // Thợ sửa chỉ có quyền xem số lượng trong kho, nếu thợ sửa cố tình POST sẽ bị từ chối quyền.
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=permission_denied");
            return;
        }

        String action = request.getParameter("action");

        // Action 1: Nhập thêm số lượng phụ tùng vào kho (Admin có thể thêm số lượng)
        if ("addStock".equals(action) || "updateStock".equals(action)) {
            int partId = parseInteger(request.getParameter("partId"));
            int qty = parseInteger(request.getParameter("quantityToAdd"));
            if (qty == 0) {
                qty = parseInteger(request.getParameter("quantityChange"));
            }

            if (partId > 0 && qty != 0) {
                boolean success = sparePartDAO.updateStock(partId, qty);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/spare-parts?msg=stock_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=update_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=invalid_quantity");
            }
            return;
        }

        // Action 2: Thêm mới một loại phụ tùng vào danh mục kho
        if ("addPart".equals(action)) {
            String partCode = request.getParameter("partCode");
            String partName = request.getParameter("partName");
            String category = request.getParameter("category");
            String unit = request.getParameter("unit");
            String costPriceStr = request.getParameter("costPrice");
            String unitPriceStr = request.getParameter("unitPrice");
            int qty = parseInteger(request.getParameter("quantityInStock"));
            int minAlert = parseInteger(request.getParameter("minStockAlert"));
            String location = request.getParameter("location");

            if (partCode == null || partCode.trim().isEmpty() || partName == null || partName.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=missing_info");
                return;
            }

            partCode = partCode.trim().toUpperCase();

            // Kiểm tra trùng mã phụ tùng
            SparePart existing = sparePartDAO.getPartByCode(partCode);
            if (existing != null) {
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=duplicate_code");
                return;
            }

            BigDecimal costPrice = parseBigDecimal(costPriceStr);
            BigDecimal unitPrice = parseBigDecimal(unitPriceStr);
            if (minAlert <= 0) minAlert = 5;

            SparePart part = new SparePart(0, partCode, partName.trim(), 
                    (category != null && !category.trim().isEmpty()) ? category.trim() : "Khác", 
                    (unit != null && !unit.trim().isEmpty()) ? unit.trim() : "Cái", 
                    unitPrice, costPrice, Math.max(0, qty), minAlert, 
                    (location != null && !location.trim().isEmpty()) ? location.trim() : "Kho chính", 
                    "ACTIVE");

            int newId = sparePartDAO.insertPart(part);
            if (newId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?msg=part_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?error=save_failed");
            }
            return;
        }

        // Action 3: Chỉnh sửa thông tin phụ tùng
        if ("editPart".equals(action)) {
            int partId = parseInteger(request.getParameter("partId"));
            SparePart existing = sparePartDAO.getPartById(partId);
            if (existing != null) {
                String partName = request.getParameter("partName");
                String category = request.getParameter("category");
                String unit = request.getParameter("unit");
                String costPriceStr = request.getParameter("costPrice");
                String unitPriceStr = request.getParameter("unitPrice");
                int minAlert = parseInteger(request.getParameter("minStockAlert"));
                String location = request.getParameter("location");
                String status = request.getParameter("status");

                if (partName != null && !partName.trim().isEmpty()) existing.setPartName(partName.trim());
                if (category != null && !category.trim().isEmpty()) existing.setCategory(category.trim());
                if (unit != null && !unit.trim().isEmpty()) existing.setUnit(unit.trim());
                if (costPriceStr != null && !costPriceStr.trim().isEmpty()) existing.setCostPrice(parseBigDecimal(costPriceStr));
                if (unitPriceStr != null && !unitPriceStr.trim().isEmpty()) existing.setUnitPrice(parseBigDecimal(unitPriceStr));
                if (minAlert > 0) existing.setMinStockAlert(minAlert);
                if (location != null && !location.trim().isEmpty()) existing.setLocation(location.trim());
                if (status != null && !status.trim().isEmpty()) existing.setStatus(status.trim());

                sparePartDAO.updatePart(existing);
                response.sendRedirect(request.getContextPath() + "/admin/spare-parts?msg=part_updated");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/spare-parts");
    }

    private int parseInteger(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(val.replaceAll("[^0-9\\-]", ""));
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private BigDecimal parseBigDecimal(String val) {
        if (val == null || val.trim().isEmpty()) return BigDecimal.ZERO;
        try {
            return new BigDecimal(val.replaceAll("[^0-9.]", ""));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}
