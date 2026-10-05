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

@WebServlet(name = "HomeController", urlPatterns = { "", "/home", "/index" })
public class HomeController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ServiceItem> popularServices = serviceDAO.getActiveServices();
        if (popularServices.size() > 6) {
            popularServices = popularServices.subList(0, 6);
        }

        request.setAttribute("popularServices", popularServices);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
