package com.example.cafemanhdu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.cafemanhdu.dao.MenuItemsDAO;
import com.example.cafemanhdu.dao.OrdersDAO;
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.MenuItem;

import java.sql.SQLException;
import java.util.List;

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

}