package com.carecar.filter;

import com.carecar.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/customer/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestURI.substring(contextPath.length());

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (relativePath.startsWith("/admin")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login?error=auth_required&redirect=" + relativePath);
                return;
            }

            // Must be ADMIN, MECHANIC, or RECEPTIONIST
            if (!currentUser.isAdmin() && !currentUser.isMechanic() && !currentUser.isReceptionist()) {
                httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
                return;
            }
        } else if (relativePath.startsWith("/customer")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login?error=auth_required&redirect=" + relativePath);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
