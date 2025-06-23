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
        HttpSession session = httpRequest.getSession(false); // Không tạo session mới nếu chưa tồn tại

        // Cho phép truy cập các trang không yêu cầu đăng nhập
        if (requestURI.endsWith("/CafeManagement/") ||
            requestURI.endsWith("/CafeManagement/scanQr") ||
            requestURI.endsWith("/CafeManagement/submitOrder") ||
            requestURI.endsWith("/CafeManagement/orderConfirmation")) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra đăng nhập cho các trang admin
        if (requestURI.contains("/admin") ||
            requestURI.contains("/editPendingOrder")) {
            if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
                // Chưa đăng nhập, chuyển hướng về index với thông báo
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/?error=Chưa đăng nhập");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}