package com.example.cafemanhdu.dao;

import java.util.List;

import com.example.cafemanhdu.model.OrderDetail;

public interface OrderDetailDao {
	OrderDetail findById(int orderDetailId);
    List<OrderDetail> findByOrderId(int orderId);
    void save(OrderDetail orderDetail);
    void deleteByOrderId(int orderId);
}
