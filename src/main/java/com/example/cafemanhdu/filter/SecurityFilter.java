package com.example.cafemanhdu.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        // Cho phép truy cập các trang liên quan đến user order
        if (requestURI.endsWith("/CafeManagement/scanQr") ||
            requestURI.endsWith("/CafeManagement/submitOrder") ||
            requestURI.endsWith("/CafeManagement/orderConfirmation")) {
            chain.doFilter(request, response);
            return;
        }

        // Các trang khác chỉ dành cho admin (tạm thời chặn user)
        if (requestURI.contains("/admin")) {
            httpResponse.sendRedirect("/CafeManagement/");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}