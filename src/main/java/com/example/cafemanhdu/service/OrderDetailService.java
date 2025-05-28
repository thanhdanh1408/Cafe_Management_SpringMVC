package com.example.cafemanhdu.service;

import java.util.List;

import com.example.cafemanhdu.model.OrderDetail;

public interface OrderDetailService {
	OrderDetail getOrderDetailById(int id);
    List<OrderDetail> getOrderDetailsByOrderId(int orderId);
    void createOrderDetail(OrderDetail detail);
    void deleteOrderDetailsByOrderId(int orderId);
}
