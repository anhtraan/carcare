package com.carecar.controller;

import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.RepairOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TrackOrderController", urlPatterns = {"/track"})
public class TrackOrderController extends HttpServlet {

    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        List<RepairOrder> results = new ArrayList<>();
        RepairOrder singleOrder = null;

        if (query != null && !query.trim().isEmpty()) {
            query = query.trim();
            if (query.toUpperCase().startsWith("CC-")) {
                singleOrder = repairOrderDAO.getOrderByCode(query);
                if (singleOrder != null) {
                    results.add(singleOrder);
                }
            } else {
                results = repairOrderDAO.getOrdersByLicensePlate(query);
            }
            request.setAttribute("query", query);
            request.setAttribute("searched", true);
            request.setAttribute("orders", results);
            if (results.size() == 1) {
                request.setAttribute("selectedOrder", results.get(0));
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/track.jsp").forward(request, response);
    }
}
