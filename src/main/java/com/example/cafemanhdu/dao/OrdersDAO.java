package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.OrderDetail;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class OrdersDAO {
    @Autowired
    private DataSource dataSource;

    public int createOrder(int tableId, String paymentMethod, java.math.BigDecimal totalAmount, String comments) throws SQLException {
        String sql = "INSERT INTO orders (table_id, payment_method, total_amount, comments, status) VALUES (?, ?, ?, ?, 'pending')";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, tableId);
            stmt.setString(2, paymentMethod);
            stmt.setBigDecimal(3, totalAmount);
            stmt.setString(4, comments);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            throw new SQLException("Failed to create order");
        }
    }

    public void createOrderDetails(int orderId, List<OrderDetail> details) throws SQLException {
        String sql = "INSERT INTO orderdetails (order_id, item_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (OrderDetail detail : details) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, detail.getItemId());
                stmt.setInt(3, detail.getQuantity());
                stmt.setBigDecimal(4, detail.getSubtotal());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public List<Order> getPendingOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.table_id, t.table_number, o.order_time, o.payment_method, o.total_amount, o.comments, o.status " +
                    "FROM orders o JOIN tables t ON o.table_id = t.table_id WHERE o.status = 'pending'";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setTableId(rs.getInt("table_id"));
                order.setTableNumber(rs.getString("table_number"));
                order.setOrderTime(rs.getTimestamp("order_time"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setComments(rs.getString("comments"));
                order.setStatus(rs.getString("status"));
                orders.add(order);
            }
        }
        return orders;
    }

    public List<Order> getOrderHistory() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.table_id, t.table_number, o.order_time, o.payment_method, o.total_amount, o.comments, o.status " +
                    "FROM orders o JOIN tables t ON o.table_id = t.table_id WHERE o.status != 'pending'";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setTableId(rs.getInt("table_id"));
                order.setTableNumber(rs.getString("table_number"));
                order.setOrderTime(rs.getTimestamp("order_time"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setComments(rs.getString("comments"));
                order.setStatus(rs.getString("status"));
                orders.add(order);
            }
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }

    public void updateOrder(int orderId, String paymentMethod, String comments, String status) throws SQLException {
        String sql = "UPDATE orders SET payment_method = ?, comments = ?, status = ? WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentMethod);
            stmt.setString(2, comments);
            stmt.setString(3, status);
            stmt.setInt(4, orderId);
            stmt.executeUpdate();
        }
    }

    public void deleteOrder(int orderId) throws SQLException {
        String deleteDetailsSql = "DELETE FROM order_details WHERE order_id = ?";
        String deleteOrderSql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement deleteDetailsStmt = conn.prepareStatement(deleteDetailsSql);
             PreparedStatement deleteOrderStmt = conn.prepareStatement(deleteOrderSql)) {
            conn.setAutoCommit(false);
            deleteDetailsStmt.setInt(1, orderId);
            deleteDetailsStmt.executeUpdate();
            deleteOrderStmt.setInt(1, orderId);
            deleteOrderStmt.executeUpdate();
            conn.commit();
        } catch (SQLException e) {
            throw new SQLException("Error deleting order: " + e.getMessage());
        }
    }
}