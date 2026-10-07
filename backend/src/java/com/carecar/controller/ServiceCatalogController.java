package com.carecar.controller;

import com.carecar.dal.ServiceDAO;
import com.carecar.model.ServiceItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceCatalogController", urlPatterns = {"/services"})
public class ServiceCatalogController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String selectedCategory = request.getParameter("category");
        List<ServiceItem> services = serviceDAO.getActiveServices();
        List<String> categories = serviceDAO.getCategories();

        if (selectedCategory != null && !selectedCategory.trim().isEmpty() && !selectedCategory.equalsIgnoreCase("ALL")) {
            services = services.stream()
                    .filter(s -> s.getCategory().equalsIgnoreCase(selectedCategory))
                    .toList();
        }

        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", selectedCategory);
        request.getRequestDispatcher("/WEB-INF/views/services.jsp").forward(request, response);
    }
}
