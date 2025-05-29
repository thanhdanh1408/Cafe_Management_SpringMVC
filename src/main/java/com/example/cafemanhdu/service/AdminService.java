package com.example.cafemanhdu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.cafemanhdu.dao.MenuItemsDAO;
import com.example.cafemanhdu.dao.OrdersDAO;
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.MenuItem;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    @Autowired
    private MenuItemsDAO menuItemsDAO;
    @Autowired
    private OrdersDAO ordersDAO;

    public List<MenuItem> getAllMenuItems() throws SQLException {
        return menuItemsDAO.getAvailableItems();
    }

    public List<Order> getPendingOrders() throws SQLException {
        return ordersDAO.getPendingOrders();
    }

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        ordersDAO.updateOrderStatus(orderId, status);
    }

    public void updateItemStatus(int itemId, String status) throws SQLException {
        menuItemsDAO.updateItemStatus(itemId, status);
    }
    
    //Thêm, sửa, xóa
    public void createMenuItem(String itemName, java.math.BigDecimal price) throws SQLException {
        menuItemsDAO.createMenuItem(itemName, price);
    }

    public void updateMenuItem(int itemId, String itemName, java.math.BigDecimal price) throws SQLException {
        menuItemsDAO.updateMenuItem(itemId, itemName, price);
    }

    public void deleteMenuItem(int itemId) throws SQLException {
        menuItemsDAO.deleteMenuItem(itemId);
    }
    
    public void updateOrder(int orderId, String paymentMethod, String comments, String status) throws SQLException {
        ordersDAO.updateOrder(orderId, paymentMethod, comments, status);
    }
    //Xóa order
    public void deleteOrder(int orderId) throws SQLException {
        ordersDAO.deleteOrder(orderId);
    }
    
    //Phương thức doanh thu
    public Map<String, Object> getSalesStatistics(Date startDate, Date endDate) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        BigDecimal totalRevenue = ordersDAO.getTotalRevenue(startDate, endDate);
        int orderCount = ordersDAO.getNumberOfOrders(startDate, endDate);
        List<Order> orders = ordersDAO.getCompletedOrders(startDate, endDate);
        
        stats.put("totalRevenue", totalRevenue);
        stats.put("orderCount", orderCount);
        stats.put("orders", orders);
        
        return stats;
    }

}
