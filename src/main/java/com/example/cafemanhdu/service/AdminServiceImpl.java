package com.example.cafemanhdu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.AdminDao;
import com.example.cafemanhdu.model.Admin;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminDao adminDao;

    @Override
    public Admin getAdminById(int id) {
        return adminDao.findById(id);
    }

    @Override
    public Admin getAdminByUsername(String username) {
        return adminDao.findByUsername(username);
    }

    @Override
    public List<Admin> getAllAdmins() {
        return adminDao.findAll();
    }

    @Override
    public void createAdmin(Admin admin) {
        adminDao.save(admin);
    }

    @Override
    public void updateAdmin(Admin admin) {
        adminDao.update(admin);
    }

    @Override
    public void deleteAdmin(int id) {
        adminDao.delete(id);
    }
}
