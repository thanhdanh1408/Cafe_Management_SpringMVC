package com.example.cafemanhdu.service;

import java.util.List;

import com.example.cafemanhdu.model.Order;

public interface OrderService {
	Order getOrderById(int id);
    List<Order> getOrdersByTableId(int tableId);
    List<Order> getAllOrders();
    void createOrder(Order order);
    void updateOrder(Order order);
    void deleteOrder(int id);
}
