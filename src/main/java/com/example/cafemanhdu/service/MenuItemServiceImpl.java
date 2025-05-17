package com.example.cafemanhdu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.MenuItemDao;
import com.example.cafemanhdu.model.MenuItem;

@Service
public class MenuItemServiceImpl implements MenuItemService {
    @Autowired
    private MenuItemDao menuItemDao;

    public MenuItem getItemById(int id) {
        return menuItemDao.findById(id);
    }

    public List<MenuItem> getAllItems() {
        return menuItemDao.findAll();
    }

    public List<MenuItem> getAvailableItems() {
        return menuItemDao.findAvailableItems();
    }

    public void createItem(MenuItem item) {
        menuItemDao.save(item);
    }

    public void updateItem(MenuItem item) {
        menuItemDao.update(item);
    }

    public void deleteItem(int id) {
        menuItemDao.delete(id);
    }

}
