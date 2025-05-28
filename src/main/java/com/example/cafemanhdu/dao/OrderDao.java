package com.example.cafemanhdu.dao;

import java.util.List;

import com.example.cafemanhdu.model.Order;

public interface OrderDao {
	 Order findById(int orderId);
	    List<Order> findByTableId(int tableId);
	    List<Order> findAll();
	    void save(Order order);
	    void update(Order order);
	    void delete(int orderId);
}
