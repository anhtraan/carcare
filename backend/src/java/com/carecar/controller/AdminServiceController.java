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
            BigDecimal cost = new BigDecimal(request.getParameter("laborCost").replaceAll("[,\\s]", ""));
            int duration = Integer.parseInt(request.getParameter("estimatedDuration"));

            ServiceItem item = new ServiceItem(0, category, serviceName, description, cost, duration, "ACTIVE");
            serviceDAO.insertService(item);
            response.sendRedirect(request.getContextPath() + "/admin/services?msg=service_added");
            return;
        }

        if ("toggleStatus".equals(action)) {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String status = request.getParameter("status");
            serviceDAO.toggleStatus(serviceId, status);
            response.sendRedirect(request.getContextPath() + "/admin/services?msg=status_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/services");
    }
}
