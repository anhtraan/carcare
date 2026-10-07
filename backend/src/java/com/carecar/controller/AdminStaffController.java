package com.carecar.controller;

import com.carecar.dal.UserDAO;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminStaffController", urlPatterns = {"/admin/staff"})
public class AdminStaffController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> staffList = userDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/WEB-INF/views/admin/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("addStaff".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            User u = new User();
            u.setUsername(username);
            u.setFullName(fullName);
            u.setRole(role);
            u.setPhone(phone);
            u.setEmail(email);

            userDAO.createStaff(u, password);
            response.sendRedirect(request.getContextPath() + "/admin/staff?msg=staff_added");
            return;
        }

        if ("toggleStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            userDAO.updateStatus(userId, status);
            response.sendRedirect(request.getContextPath() + "/admin/staff?msg=status_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }
}
