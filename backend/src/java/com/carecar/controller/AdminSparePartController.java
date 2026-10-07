package com.carecar.controller;

import com.carecar.dal.SparePartDAO;
import com.carecar.model.SparePart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminSparePartController", urlPatterns = {"/admin/spare-parts"})
public class AdminSparePartController extends HttpServlet {

    private SparePartDAO sparePartDAO = new SparePartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String filter = request.getParameter("filter");
        List<SparePart> list;

        if ("low_stock".equalsIgnoreCase(filter)) {
            list = sparePartDAO.getLowStockParts();
        } else {
            list = sparePartDAO.getAllParts();
        }

        request.setAttribute("parts", list);
        request.setAttribute("filter", filter);
        request.getRequestDispatcher("/WEB-INF/views/admin/spare-parts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("addPart".equals(action)) {
            String partCode = request.getParameter("partCode");
            String partName = request.getParameter("partName");
            String category = request.getParameter("category");
            String unit = request.getParameter("unit");
            BigDecimal unitPrice = new BigDecimal(request.getParameter("unitPrice").replaceAll("[,\\s]", ""));
            BigDecimal costPrice = new BigDecimal(request.getParameter("costPrice").replaceAll("[,\\s]", ""));
            int qty = Integer.parseInt(request.getParameter("quantityInStock"));
            int minAlert = Integer.parseInt(request.getParameter("minStockAlert"));
            String location = request.getParameter("location");

            SparePart part = new SparePart(0, partCode, partName, category, unit, unitPrice, costPrice, qty, minAlert, location, "ACTIVE");
            sparePartDAO.insertPart(part);
            response.sendRedirect(request.getContextPath() + "/admin/spare-parts?msg=part_added");
            return;
        }

        if ("updateStock".equals(action)) {
            int partId = Integer.parseInt(request.getParameter("partId"));
            int diff = Integer.parseInt(request.getParameter("quantityChange"));
            sparePartDAO.updateStock(partId, diff);
            response.sendRedirect(request.getContextPath() + "/admin/spare-parts?msg=stock_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/spare-parts");
    }
}
