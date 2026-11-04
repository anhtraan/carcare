package com.carecar.controller;

import com.carecar.dal.CarDAO;
import com.carecar.dal.CustomerDAO;
import com.carecar.model.Customer;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCustomerController", urlPatterns = {"/admin/customers"})
public class AdminCustomerController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkCustomerAccess(request, response)) {
            return;
        }

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
        
        if (!checkCustomerAccess(request, response)) {
            return;
        }

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

    private boolean checkCustomerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Thợ máy không được phép xem toàn bộ danh bạ khách hàng
        if (currentUser == null || (!currentUser.isAdmin() && !currentUser.isReceptionist())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=access_denied");
            return false;
        }
        return true;
    }
}
