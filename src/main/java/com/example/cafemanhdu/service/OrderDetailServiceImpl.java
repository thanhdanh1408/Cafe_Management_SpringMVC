package com.example.cafemanhdu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cafemanhdu.dao.OrderDetailDao;
import com.example.cafemanhdu.model.OrderDetail;

import jakarta.transaction.Transactional;

@Service
public class OrderDetailServiceImpl implements OrderDetailService {

    @Autowired
    private OrderDetailDao orderDetailDao;

    @Override
    public OrderDetail getOrderDetailById(int id) {
        return orderDetailDao.findById(id);
    }

    @Override
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        return orderDetailDao.findByOrderId(orderId);
    }

    @Override
    @Transactional
    public void createOrderDetail(OrderDetail detail) {
        orderDetailDao.save(detail);
    }

    @Override
    @Transactional
    public void deleteOrderDetailsByOrderId(int orderId) {
        orderDetailDao.deleteByOrderId(orderId);
    }

}
