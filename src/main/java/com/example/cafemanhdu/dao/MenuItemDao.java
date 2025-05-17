package com.example.cafemanhdu.dao;

import java.util.List;

import com.example.cafemanhdu.model.MenuItem;

public interface MenuItemDao {
	MenuItem findById(int itemId);
    List<MenuItem> findAll();
    List<MenuItem> findAvailableItems();
    void save(MenuItem item);
    void update(MenuItem item);
    void delete(int itemId);
}
