package com.example.cafemanhdu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.MenuItemsDAO;
import com.example.cafemanhdu.dao.OrdersDAO;
import com.example.cafemanhdu.dao.TablesDAO;
import com.example.cafemanhdu.model.OrderDetail;
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.MenuItem;
import com.example.cafemanhdu.model.Table;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class OrderService {
    @Autowired
    private TablesDAO tablesDAO;
    @Autowired
    private MenuItemsDAO menuItemsDAO;
    @Autowired
    private OrdersDAO ordersDAO;

    public boolean validateQrCode(String qrCode) throws SQLException {
        return tablesDAO.validateQrCode(qrCode);
    }

    public int getTableIdByQrCode(String qrCode) throws SQLException {
        return tablesDAO.getTableIdByQrCode(qrCode);
    }

    public List<MenuItem> getAvailableItems() throws SQLException {
        return menuItemsDAO.getAvailableItems();
    }

    public void submitOrder(int tableId, List<OrderItem> items, String paymentMethod, String comments) throws SQLException {
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderDetail> orderDetails = new ArrayList<>();

        for (OrderItem item : items) {
            BigDecimal subtotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            totalAmount = totalAmount.add(subtotal);
            OrderDetail detail = new OrderDetail();
            detail.setItemId(item.getItemId());
            detail.setQuantity(item.getQuantity());
            detail.setSubtotal(subtotal);
            orderDetails.add(detail);
        }

        int orderId = ordersDAO.createOrder(tableId, paymentMethod, totalAmount, comments);
        ordersDAO.createOrderDetails(orderId, orderDetails);
    }

    public List<OrderDetail> getOrderDetails(int orderId) throws SQLException {
        return ordersDAO.getOrderDetails(orderId);
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

    public List<Table> getAllTables() throws SQLException {
        return tablesDAO.getAllTables();
    }

    public void createTable(String tableNumber) throws SQLException {
        tablesDAO.createTable(tableNumber, null);
    }

    public void deleteTable(int tableId) throws SQLException {
        tablesDAO.deleteTable(tableId);
    }
    
    // Reset id table
    public void resetTableId() throws SQLException {
        tablesDAO.resetTableId();
    }

    public List<Order> getOrderHistory() throws SQLException {
        return ordersDAO.getOrderHistory();
    }
    
    // Thống kê
    public BigDecimal calculateDailyRevenue() throws SQLException {
        return ordersDAO.calculateDailyRevenue();
    }

    public BigDecimal calculateWeeklyRevenue() throws SQLException {
        return ordersDAO.calculateWeeklyRevenue();
    }

    public BigDecimal calculateMonthlyRevenue() throws SQLException {
        return ordersDAO.calculateMonthlyRevenue();
    }

    public BigDecimal calculateYearlyRevenue() throws SQLException {
        return ordersDAO.calculateYearlyRevenue();
    }
    
    public Map<String, Integer> getDailyItemOrderCounts() throws SQLException {
        return ordersDAO.getDailyItemOrderCounts();
    }

    // Thêm phương thức để lấy dữ liệu chỉnh sửa
    public Order getOrderById(int orderId) throws SQLException {
        return ordersDAO.getOrderById(orderId);
    }

    public MenuItem getMenuItemById(int itemId) throws SQLException {
        return menuItemsDAO.getMenuItemById(itemId);
    }

    public static class OrderItem {
        private int itemId;
        private String itemName;
        private BigDecimal price;
        private int quantity;

        public OrderItem(int itemId, String itemName, BigDecimal price, int quantity) {
            this.itemId = itemId;
            this.itemName = itemName;
            this.price = price;
            this.quantity = quantity;
        }

        public int getItemId() { return itemId; }
        public String getItemName() { return itemName; }
        public BigDecimal getPrice() { return price; }
        public int getQuantity() { return quantity; }
    }
}