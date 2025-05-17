package com.example.cafemanhdu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.OrderDao;
import com.example.cafemanhdu.model.Order;

import jakarta.transaction.Transactional;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Override
    public Order getOrderById(int id) {
        return orderDao.findById(id);
    }

    @Override
    public List<Order> getOrdersByTableId(int tableId) {
        return orderDao.findByTableId(tableId);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderDao.findAll();
    }

    @Override
    @Transactional
    public void createOrder(Order order) {
        orderDao.save(order);
    }

    @Override
    @Transactional
    public void updateOrder(Order order) {
        orderDao.update(order);
    }

    @Override
    @Transactional
    public void deleteOrder(int id) {
        orderDao.delete(id);
    }

}
