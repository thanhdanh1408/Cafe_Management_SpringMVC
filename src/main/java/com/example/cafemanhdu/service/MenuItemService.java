package com.example.cafemanhdu.service;

import java.util.List;

import com.example.cafemanhdu.model.MenuItem;

public interface MenuItemService {
	MenuItem getItemById(int id);
    List<MenuItem> getAllItems();
    List<MenuItem> getAvailableItems();
    void createItem(MenuItem item);
    void updateItem(MenuItem item);
    void deleteItem(int id);
}
