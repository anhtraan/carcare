package com.carecar.controller;

import com.carecar.util.CSRFTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chống tấn công Logout CSRF qua thẻ <img> hoặc liên kết ngầm từ website khác:
        // Yêu cầu phải có CSRF Token hợp lệ khi đăng xuất qua GET
        if (CSRFTokenUtil.validateToken(request)) {
            processLogout(request, response);
        } else {
            // Không thực hiện đăng xuất ngầm, chuyển hướng an toàn về trang chủ
            response.sendRedirect(request.getContextPath() + "/home?msg=invalid_logout_request");
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home?msg=logged_out");
    }
}
