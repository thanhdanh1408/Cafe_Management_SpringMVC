package com.example.cafemanhdu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.TableDao;
import com.example.cafemanhdu.model.Table;

@Service
public class TableServiceImpl implements TableService {

    @Autowired
    private TableDao tableDao;

    @Override
    public Table getTableById(int id) {
        return tableDao.findById(id);
    }

    @Override
    public Table getTableByQRCode(String qrCode) {
        return tableDao.findByQRCode(qrCode);
    }

    @Override
    public List<Table> getAllTables() {
        return tableDao.findAll();
    }

    @Override
    public void createTable(Table table) {
        tableDao.save(table);
    }

    @Override
    public void updateTable(Table table) {
        tableDao.update(table);
    }

    @Override
    public void deleteTable(int id) {
        tableDao.delete(id);
    }

}
