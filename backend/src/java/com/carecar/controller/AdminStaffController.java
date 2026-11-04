package com.carecar.controller;

import com.carecar.dal.UserDAO;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet(name = "AdminStaffController", urlPatterns = {"/admin/staff"})
public class AdminStaffController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Set<String> ALLOWED_STAFF_ROLES = Set.of("ADMIN", "MECHANIC", "RECEPTIONIST");
    private static final Set<String> ALLOWED_STATUSES = Set.of("ACTIVE", "INACTIVE", "LOCKED");

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminPermission(request, response)) {
            return;
        }

        List<User> staffList = userDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/WEB-INF/views/admin/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if ("addStaff".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            // 1. Kiểm tra dữ liệu bắt buộc
            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()
                    || fullName == null || fullName.trim().isEmpty() || role == null || role.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=missing_fields");
                return;
            }

            username = username.trim().toLowerCase();
            role = role.trim().toUpperCase();

            // 2. Kiểm tra Role theo Whitelist nghiêm ngặt (chỉ cho phép ADMIN, MECHANIC, RECEPTIONIST)
            if (!ALLOWED_STAFF_ROLES.contains(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=invalid_role");
                return;
            }

            // 3. Kiểm tra xem username đã tồn tại hay chưa
            if (userDAO.getUserByUsername(username) != null) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=username_exists");
                return;
            }

            User u = new User();
            u.setUsername(username);
            u.setFullName(fullName.trim());
            u.setRole(role);
            u.setPhone(phone != null ? phone.trim() : "");
            u.setEmail(email != null ? email.trim() : "");

            userDAO.createStaff(u, password.trim());
            response.sendRedirect(request.getContextPath() + "/admin/staff?msg=staff_added");
            return;
        }

        if ("toggleStatus".equals(action)) {
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("currentUser");

            int userId = 0;
            try {
                userId = Integer.parseInt(request.getParameter("userId"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=invalid_id");
                return;
            }

            String status = request.getParameter("status");
            if (status != null) {
                status = status.trim().toUpperCase();
            }

            // 1. Validate status theo Whitelist
            if (status == null || !ALLOWED_STATUSES.contains(status)) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=invalid_status");
                return;
            }

            // 2. Chặn tự khóa tài khoản của chính mình hoặc khóa tài khoản Root Admin (userId = 1)
            if (currentUser != null && (userId == currentUser.getUserId() || userId == 1)) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=cannot_lock_self");
                return;
            }

            userDAO.updateStatus(userId, status);
            response.sendRedirect(request.getContextPath() + "/admin/staff?msg=status_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }

    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=access_denied");
            return false;
        }
        return true;
    }
}
