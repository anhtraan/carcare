package com.carecar.controller;

import com.carecar.dal.CarDAO;
import com.carecar.dal.CustomerDAO;
import com.carecar.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCustomerController", urlPatterns = {"/admin/customers"})
public class AdminCustomerController extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("q");
        List<Customer> customers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            customers = customerDAO.searchCustomers(keyword.trim());
        } else {
            customers = customerDAO.getAllCustomers();
        }

        // Attach cars for each customer
        for (Customer c : customers) {
            c.setCars(carDAO.getCarsByCustomerId(c.getCustomerId()));
        }

        request.setAttribute("customers", customers);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String idCard = request.getParameter("idCard");
        String notes = request.getParameter("notes");

        Customer cust = new Customer(0, null, fullName, phone, email, address, idCard, notes, null);
        customerDAO.insertCustomer(cust);

        response.sendRedirect(request.getContextPath() + "/admin/customers?msg=customer_added");
    }
}
