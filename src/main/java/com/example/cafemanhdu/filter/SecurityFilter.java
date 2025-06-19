package com.example.cafemanhdu.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class SecurityFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        HttpSession session = httpRequest.getSession(false);

        // Cho phép truy cập tự do các trang index, login, userLogin, scan QR, submit order, orderConfirmation, static resources
        if (requestURI.equals(contextPath + "/") ||
            requestURI.equals(contextPath + "/index") ||
            requestURI.contains("login") ||
            requestURI.contains("userLogin") ||
            requestURI.endsWith("/scanQr") ||
            requestURI.endsWith("/submitOrder") ||
            requestURI.endsWith("/orderConfirmation") ||
            requestURI.contains("css") ||
            requestURI.contains("js")) {
            chain.doFilter(request, response);
            return;
        }

        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Chỉ admin được phép vào các trang /admin
        if (requestURI.startsWith(contextPath + "/admin")) {
            if (!"admin".equals(role)) {
                httpResponse.sendRedirect(contextPath + "/");
                return;
            }
        }
        // Chỉ user được phép vào các trang /user
        else if (requestURI.startsWith(contextPath + "/user")) {
            if (!"user".equals(role)) {
                httpResponse.sendRedirect(contextPath + "/");
                return;
            }
        }

        // Các trường hợp còn lại
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
