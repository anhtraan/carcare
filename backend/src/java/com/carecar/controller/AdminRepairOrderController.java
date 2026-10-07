package com.carecar.controller;

import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.RepairOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminRepairOrderController", urlPatterns = {"/admin/repair-orders"})
public class AdminRepairOrderController extends HttpServlet {

    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        List<RepairOrder> orders;

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            orders = repairOrderDAO.getOrdersByStatus(status);
        } else {
            orders = repairOrderDAO.getAllOrders();
        }

        request.setAttribute("orders", orders);
        request.setAttribute("selectedStatus", status);
        request.getRequestDispatcher("/WEB-INF/views/admin/repair-orders.jsp").forward(request, response);
    }
}
