package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.cafemanhdu.model.MenuItem;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class MenuItemsDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<MenuItem> getAvailableItems() throws SQLException {
        String sql = "SELECT item_id, item_name, price, status FROM menuitems";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            MenuItem item = new MenuItem();
            item.setItemId(rs.getInt("item_id"));
            item.setItemName(rs.getString("item_name"));
            BigDecimal price = rs.getBigDecimal("price");
            if (price != null) {
                item.setPrice(price); // Giữ nguyên đơn vị lớn (20000)
            } else {
                item.setPrice(BigDecimal.ZERO);
            }
            item.setStatus(rs.getString("status"));
            return item;
        });
    }

    public MenuItem getMenuItemById(int itemId) throws SQLException {
        String sql = "SELECT item_id, item_name, price, status FROM menuitems WHERE item_id = ?";
        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
            MenuItem item = new MenuItem();
            item.setItemId(rs.getInt("item_id"));
            item.setItemName(rs.getString("item_name"));
            BigDecimal price = rs.getBigDecimal("price");
            if (price != null) {
                item.setPrice(price); // Giữ nguyên đơn vị lớn
            } else {
                item.setPrice(BigDecimal.ZERO);
            }
            item.setStatus(rs.getString("status"));
            return item;
        }, itemId);
    }

    public void createMenuItem(String itemName, BigDecimal price, String status) throws SQLException {
        String sql = "INSERT INTO menuitems (item_name, price, status) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, itemName, price, status); // Giữ nguyên giá nhập (20000)
    }

    public void updateMenuItem(int itemId, String itemName, BigDecimal price, String status) throws SQLException {
        String sql = "UPDATE menuitems SET item_name = ?, price = ?, status = ? WHERE item_id = ?";
        jdbcTemplate.update(sql, itemName, price, status, itemId); // Giữ nguyên giá nhập
    }

    public void deleteMenuItem(int itemId) throws SQLException {
        String sql = "DELETE FROM menuitems WHERE item_id = ?";
        jdbcTemplate.update(sql, itemId);
    }
}