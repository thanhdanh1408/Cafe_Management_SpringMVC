package com.example.cafemanhdu.dao;

import com.example.cafemanhdu.dao.TableDao;
import com.example.cafemanhdu.model.Table;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class TableDaoImpl implements TableDao {

    @Autowired
    private DataSource dataSource;

    @Override
    public Table findById(int tableId) {
        String sql = "SELECT * FROM tables WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
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
    public Table findByQRCode(String qrCode) {
        String sql = "SELECT * FROM tables WHERE qr_code = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, qrCode);
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
    public List<Table> findAll() {
        List<Table> list = new ArrayList<>();
        String sql = "SELECT * FROM tables ORDER BY table_number";
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
    public void save(Table table) {
        String sql = "INSERT INTO tables (table_number, qr_code, status) VALUES (?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, table.getTableNumber());
            stmt.setString(2, table.getQrCode());
            stmt.setString(3, table.getStatus());

            stmt.executeUpdate();

            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) {
                table.setTableId(keys.getInt(1));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Table table) {
        String sql = "UPDATE tables SET table_number = ?, qr_code = ?, status = ? WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, table.getTableNumber());
            stmt.setString(2, table.getQrCode());
            stmt.setString(3, table.getStatus());
            stmt.setInt(4, table.getTableId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int tableId) {
        String sql = "DELETE FROM tables WHERE table_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Table mapRow(ResultSet rs) throws SQLException {
        Table table = new Table();
        table.setTableId(rs.getInt("table_id"));
        table.setTableNumber(rs.getString("table_number"));
        table.setQrCode(rs.getString("qr_code"));
        table.setStatus(rs.getString("status"));
        return table;
    }

}
