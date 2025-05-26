package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.cafemanhdu.model.Table;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class TablesDAO {
	@Autowired
    private DataSource dataSource;
	
	private Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public boolean validateQrCode(String qrCode) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tables WHERE qr_code = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, qrCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public int getTableIdByQrCode(String qrCode) throws SQLException {
        String sql = "SELECT table_id FROM tables WHERE qr_code = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, qrCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("table_id");
            }
            throw new SQLException("Table not found for QR code: " + qrCode);
        }
    }

    public List<Table> getAllTables() throws SQLException {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT * FROM tables";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setTableNumber(rs.getString("table_number"));
                table.setQrCode(rs.getString("qr_code"));
                table.setStatus(rs.getString("status"));
                tables.add(table);
            }
        }
        return tables;
    }
    
    
    //Check số bàn trước khi thêm
    public boolean isTableNumberExists(String tableNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tables WHERE table_number = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tableNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
    
    //-----------------------------------------------------//
    //Thêm, Xóa bàn
    public void createTable(String tableNumber, String qrCode) throws SQLException {
        String generatedQrCode = qrCode != null && !qrCode.isEmpty() ? qrCode : "qr_table_" + System.currentTimeMillis();
        String sql = "INSERT INTO tables (table_number, qr_code, status) VALUES (?, ?, 'available')";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tableNumber);
            stmt.setString(2, generatedQrCode);
            stmt.executeUpdate();
        }
    }

    public void deleteTable(int tableId) throws SQLException {
        // Xóa các đơn hàng liên quan trước
        String deleteOrdersSql = "DELETE FROM orders WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteOrdersSql)) {
            stmt.setInt(1, tableId);
            stmt.executeUpdate();
        }

        // Xóa bàn
        String deleteTableSql = "DELETE FROM tables WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteTableSql)) {
            stmt.setInt(1, tableId);
            stmt.executeUpdate();
        }
    }
    
    
    //Reset lại id Tables khi xóa
    public void resetTableId() throws SQLException {
        String truncateOrdersSql = "DELETE FROM orders";
        String truncateTablesSql = "TRUNCATE TABLE tables";
        // Reset sequence/auto-increment cho table_id
        String resetSql = "ALTER TABLE tables AUTO_INCREMENT = 1";


        try (Connection connection = dataSource.getConnection();
        		PreparedStatement truncateOrdersStmt = connection.prepareStatement(truncateOrdersSql);
                PreparedStatement truncateTablesStmt = connection.prepareStatement(truncateTablesSql);
                PreparedStatement resetStmt = connection.prepareStatement(resetSql)) {
        	connection.setAutoCommit(false);
        	truncateOrdersStmt.executeUpdate();
            truncateTablesStmt.executeUpdate();
            resetStmt.executeUpdate();
            connection.commit();
        } catch (SQLException e) {
            throw new SQLException("Error resetting table ID: " + e.getMessage());
        }
    }
    
}