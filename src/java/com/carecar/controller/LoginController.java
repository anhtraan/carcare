package com.carecar.controller;

import com.carecar.dal.UserDAO;
import com.carecar.model.User;
import com.carecar.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isAdmin() || user.isMechanic() || user.isReceptionist()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/dashboard");
            }
            return;
        }

        String error = request.getParameter("error");
        if ("auth_required".equals(error)) {
            request.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
        } else if ("access_denied".equals(error)) {
            request.setAttribute("errorMessage", "Bạn không có quyền truy cập trang quản trị!");
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usernameOrPhone = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (usernameOrPhone == null || password == null || usernameOrPhone.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập tên đăng nhập/số điện thoại và mật khẩu.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(usernameOrPhone.trim(), password.trim());
        if (user != null) {
            // Tự động nâng cấp mã hóa mật khẩu lên chuẩn PBKDF2-SHA256 (10,000 vòng lặp) nếu là hash cũ
            if (PasswordUtil.needsUpgrade(user.getPasswordHash())) {
                String newPbkdf2Hash = PasswordUtil.hashPassword(password.trim());
                userDAO.updatePassword(user.getUserId(), newPbkdf2Hash);
                user.setPasswordHash(newPbkdf2Hash);
            }

            // Phòng chống tấn công Session Fixation: Hủy session cũ và tạo session mới
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("currentUser", user);

            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login")) {
                response.sendRedirect(request.getContextPath() + redirect);
                return;
            }

            if (user.isAdmin() || user.isMechanic() || user.isReceptionist()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/dashboard");
            }
        } else {
            request.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác!");
            request.setAttribute("enteredUsername", usernameOrPhone);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
