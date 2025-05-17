package com.example.cafemanhdu.dao;

import java.util.List;

import com.example.cafemanhdu.model.Admin;

public interface AdminDao {
	Admin findById(int adminId);
    Admin findByUsername(String username);
    List<Admin> findAll();
    void save(Admin admin);
    void update(Admin admin);
    void delete(int adminId);
}
