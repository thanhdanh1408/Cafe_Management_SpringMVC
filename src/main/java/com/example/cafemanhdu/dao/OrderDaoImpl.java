package com.example.cafemanhdu.dao;

import com.example.cafemanhdu.dao.OrderDao;
import com.example.cafemanhdu.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class OrderDaoImpl implements OrderDao {

    @Autowired
    private DataSource dataSource;

    @Override
    public Order findById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Order> findByTableId(int tableId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_time DESC";
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void save(Order order) {
        String sql = "INSERT INTO orders (table_id, admin_id, order_time, status, payment_method, total_amount, comments) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getTableId());
            if (order.getAdminId() != null) {
                stmt.setInt(2, order.getAdminId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setTimestamp(3, new Timestamp(order.getOrderTime().getTime()));
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getPaymentMethod());
            stmt.setDouble(6, order.getTotalAmount());
            stmt.setString(7, order.getComments());

            stmt.executeUpdate();

            // Set generated ID
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) {
                order.setOrderId(keys.getInt(1));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Order order) {
        String sql = "UPDATE orders SET table_id = ?, admin_id = ?, status = ?, payment_method = ?, " +
                     "total_amount = ?, comments = ? WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, order.getTableId());
            if (order.getAdminId() != null) {
                stmt.setInt(2, order.getAdminId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, order.getStatus());
            stmt.setString(4, order.getPaymentMethod());
            stmt.setDouble(5, order.getTotalAmount());
            stmt.setString(6, order.getComments());
            stmt.setInt(7, order.getOrderId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setTableId(rs.getInt("table_id"));
        int adminId = rs.getInt("admin_id");
        order.setAdminId(rs.wasNull() ? null : adminId); // nullable
        order.setOrderTime(rs.getDate("order_time"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setComments(rs.getString("comments"));
        return order;
    }

}
