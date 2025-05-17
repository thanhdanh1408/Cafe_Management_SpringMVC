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
}