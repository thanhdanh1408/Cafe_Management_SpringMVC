package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.OrderDetail;
import com.example.cafemanhdu.model.MenuItem;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OrdersDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int createOrder(int tableId, String paymentMethod, BigDecimal totalAmount, String comments) throws SQLException {
        String sql = "INSERT INTO orders (table_id, payment_method, total_amount, comments, status) VALUES (?, ?, ?, ?, 'pending')";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"order_id"});
            ps.setInt(1, tableId);
            ps.setString(2, paymentMethod);
            ps.setBigDecimal(3, totalAmount);
            ps.setString(4, comments);
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }
    
    public void updateOrder(int orderId, String paymentMethod, String comments, String status) throws SQLException {
        String sql = "UPDATE orders SET payment_method = ?, comments = ?, status = ? WHERE order_id = ?";
        jdbcTemplate.update(sql, paymentMethod, comments, status, orderId);
    }

    public void deleteOrder(int orderId) throws SQLException {
        String deleteDetailsSql = "DELETE FROM orderdetails WHERE order_id = ?";
        String deleteOrderSql = "DELETE FROM orders WHERE order_id = ?";
        jdbcTemplate.update(deleteDetailsSql, orderId);
        jdbcTemplate.update(deleteOrderSql, orderId);
    }

    public void createOrderDetails(int orderId, List<OrderDetail> details) throws SQLException {
        String sql = "INSERT INTO orderdetails (order_id, item_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
        jdbcTemplate.batchUpdate(sql, details, details.size(), (ps, detail) -> {
            ps.setInt(1, orderId);
            ps.setInt(2, detail.getItemId());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getSubtotal());
        });
    }
    
    public List<OrderDetail> getOrderDetails(int orderId) throws SQLException {
        String sql = "SELECT od.item_id, od.quantity, od.subtotal, mi.item_name " +
                     "FROM orderdetails od " +
                     "LEFT JOIN menuitems mi ON od.item_id = mi.item_id " +
                     "WHERE od.order_id = ?";
        List<OrderDetail> details = jdbcTemplate.query(sql, (rs, rowNum) -> {
            OrderDetail detail = new OrderDetail();
            detail.setItemId(rs.getInt("item_id"));
            detail.setQuantity(rs.getInt("quantity"));
            detail.setSubtotal(rs.getBigDecimal("subtotal"));
            detail.setItemName(rs.getString("item_name") != null ? rs.getString("item_name") : "Unknown Item");
            return detail;
        }, orderId);
        System.out.println("getOrderDetails for orderId " + orderId + ": " + (details != null ? details.size() : "null")); // Debug log
        return details != null ? details : new ArrayList<>();
    }

    public List<Order> getPendingOrders() throws SQLException {
        String sql = "SELECT o.order_id, o.table_id, t.table_number, o.order_time, o.payment_method, o.total_amount, o.comments, o.status " +
                     "FROM orders o JOIN tables t ON o.table_id = t.table_id WHERE o.status = 'pending'";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setTableId(rs.getInt("table_id"));
            order.setTableNumber(rs.getString("table_number"));
            order.setOrderTime(rs.getTimestamp("order_time"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setComments(rs.getString("comments"));
            order.setStatus(rs.getString("status"));
            return order;
        });
    }

    public List<Order> getOrderHistory() throws SQLException {
        String sql = "SELECT o.order_id, o.table_id, t.table_number, o.order_time, o.payment_method, o.total_amount, o.comments, o.status " +
                     "FROM orders o JOIN tables t ON o.table_id = t.table_id WHERE o.status != 'pending'";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setTableId(rs.getInt("table_id"));
            order.setTableNumber(rs.getString("table_number"));
            order.setOrderTime(rs.getTimestamp("order_time"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setComments(rs.getString("comments"));
            order.setStatus(rs.getString("status"));
            return order;
        });
    }

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        jdbcTemplate.update(sql, status, orderId);
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.order_id, o.table_id, t.table_number, o.order_time, o.payment_method, o.total_amount, o.comments, o.status " +
                     "FROM orders o JOIN tables t ON o.table_id = t.table_id WHERE o.order_id = ?";
        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setTableId(rs.getInt("table_id"));
            order.setTableNumber(rs.getString("table_number"));
            order.setOrderTime(rs.getTimestamp("order_time"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setComments(rs.getString("comments"));
            order.setStatus(rs.getString("status"));
            return order;
        }, orderId);
    }

    // Thống kê
    public BigDecimal calculateDailyRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE DATE(order_time) = CURDATE()";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    public BigDecimal calculateWeeklyRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE WEEK(order_time) = WEEK(CURDATE()) AND YEAR(order_time) = YEAR(CURDATE())";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    public BigDecimal calculateMonthlyRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE MONTH(order_time) = MONTH(CURDATE()) AND YEAR(order_time) = YEAR(CURDATE())";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    public BigDecimal calculateYearlyRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE YEAR(order_time) = YEAR(CURDATE())";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }
    
    public Map<String, Integer> getDailyItemOrderCounts() throws SQLException {
        String sql = "SELECT mi.item_name, SUM(od.quantity) as total_quantity " +
                     "FROM orderdetails od " +
                     "JOIN menuitems mi ON od.item_id = mi.item_id " +
                     "JOIN orders o ON od.order_id = o.order_id " +
                     "WHERE DATE(o.order_time) = CURDATE() " +
                     "GROUP BY mi.item_name";
        return jdbcTemplate.query(sql, rs -> {
            Map<String, Integer> itemCounts = new HashMap<>();
            while (rs.next()) {
                itemCounts.put(rs.getString("item_name"), rs.getInt("total_quantity"));
            }
            return itemCounts;
        });
    }
}