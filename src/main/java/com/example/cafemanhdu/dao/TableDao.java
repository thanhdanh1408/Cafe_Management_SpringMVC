package com.example.cafemanhdu.dao;

import java.util.List;

import com.example.cafemanhdu.model.Table;

public interface TableDao {
	 Table findById(int tableId);
	    Table findByQRCode(String qrCode);
	    List<Table> findAll();
	    void save(Table table);
	    void update(Table table);
	    void delete(int tableId);
}
