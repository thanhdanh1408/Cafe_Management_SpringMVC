package com.example.cafemanhdu.service;

import java.util.List;

import com.example.cafemanhdu.model.Table;

public interface TableService {
	Table getTableById(int id);
    Table getTableByQRCode(String qrCode);
    List<Table> getAllTables();
    void createTable(Table table);
    void updateTable(Table table);
    void deleteTable(int id);
}
