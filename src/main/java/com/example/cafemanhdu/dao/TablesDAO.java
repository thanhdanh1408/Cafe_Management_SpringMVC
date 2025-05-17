package com.example.cafemanhdu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class TablesDAO {
    @Autowired
    private DataSource dataSource;

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
}