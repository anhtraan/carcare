package com.carecar.controller;

import com.carecar.dal.UserDAO;
import com.carecar.model.Customer;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (username == null || password == null || fullName == null || phone == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || fullName.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ các trường thông tin bắt buộc (*)");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không trùng khớp!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.getUserByUsername(username.trim()) != null) {
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.getUserByPhone(phone.trim()) != null) {
            request.setAttribute("errorMessage", "Số điện thoại này đã được đăng ký tài khoản!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPasswordHash(password.trim()); // DAO hashes with SHA-256
        user.setFullName(fullName.trim());
        user.setEmail(email != null ? email.trim() : null);
        user.setPhone(phone.trim());

        Customer cust = new Customer();
        cust.setFullName(fullName.trim());
        cust.setPhone(phone.trim());
        cust.setEmail(email != null ? email.trim() : null);
        cust.setAddress(address != null ? address.trim() : null);

        boolean ok = userDAO.registerCustomer(user, cust);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/login?msg=register_success");
        } else {
            request.setAttribute("errorMessage", "Đăng ký không thành công. Số điện thoại hoặc tên đăng nhập có thể đã tồn tại!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
