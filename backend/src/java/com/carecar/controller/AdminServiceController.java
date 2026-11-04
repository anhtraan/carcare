package com.carecar.controller;

import com.carecar.dal.ServiceDAO;
import com.carecar.model.ServiceItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminServiceController", urlPatterns = {"/admin/services"})
public class AdminServiceController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<ServiceItem> services = serviceDAO.getAllServices();
        List<String> categories = serviceDAO.getCategories();

        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("addService".equals(action)) {
            String category = request.getParameter("category");
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            BigDecimal cost = parseBigDecimal(request.getParameter("laborCost"));
            int duration = parseInteger(request.getParameter("estimatedDuration"), 60);

            ServiceItem item = new ServiceItem(0, category, serviceName, description, cost, duration, "ACTIVE");
            serviceDAO.insertService(item);
            response.sendRedirect(request.getContextPath() + "/admin/services?msg=service_added");
            return;
        }

        if ("editService".equals(action)) {
            int serviceId = parseInteger(request.getParameter("serviceId"), 0);
            String category = request.getParameter("category");
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            BigDecimal cost = parseBigDecimal(request.getParameter("laborCost"));
            int duration = parseInteger(request.getParameter("estimatedDuration"), 60);
            String status = request.getParameter("status");
            if (status == null || status.trim().isEmpty()) {
                status = "ACTIVE";
            }

            if (serviceId > 0) {
                ServiceItem item = new ServiceItem(serviceId, category, serviceName, description, cost, duration, status);
                serviceDAO.updateService(item);
                response.sendRedirect(request.getContextPath() + "/admin/services?msg=service_updated");
                return;
            }
        }

        if ("toggleStatus".equals(action)) {
            int serviceId = parseInteger(request.getParameter("serviceId"), 0);
            String status = request.getParameter("status");
            if (serviceId > 0) {
                serviceDAO.toggleStatus(serviceId, status);
                response.sendRedirect(request.getContextPath() + "/admin/services?msg=status_updated");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/services");
    }

    private BigDecimal parseBigDecimal(String val) {
        if (val == null || val.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(val.replaceAll("[,\\s]", ""));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private int parseInteger(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
