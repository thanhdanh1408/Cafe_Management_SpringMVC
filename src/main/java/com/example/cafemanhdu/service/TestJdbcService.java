package com.example.cafemanhdu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@Service
public class TestJdbcService {
    @Autowired
    private DataSource dataSource;

    public String testConnection() {
        try (Connection connection = dataSource.getConnection()) {
            return "JDBC Connection successful!";
        } catch (SQLException e) {
            return "JDBC Connection failed: " + e.getMessage();
        }
    }
}