package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.cafemanhdu.model.MenuItem;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class MenuItemsDAO {
    @Autowired
    private DataSource dataSource;

    public List<MenuItem> getAvailableItems() throws SQLException {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT item_id, item_name, price FROM menuitems WHERE status = 'available'";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setStatus("available");
                items.add(item);
            }
        }
        return items;
    }

    public void updateItemStatus(int itemId, String status) throws SQLException {
        String sql = "UPDATE menuitems SET status = ? WHERE item_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, itemId);
            stmt.executeUpdate();
        }
    }
}