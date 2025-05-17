package com.example.cafemanhdu.service;

import java.util.List;

import com.example.cafemanhdu.model.Admin;

public interface AdminService {
	Admin getAdminById(int id);
    Admin getAdminByUsername(String username);
    List<Admin> getAllAdmins();
    void createAdmin(Admin admin);
    void updateAdmin(Admin admin);
    void deleteAdmin(int id);
}
