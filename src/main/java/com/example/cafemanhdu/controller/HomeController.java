package com.example.cafemanhdu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.cafemanhdu.service.TestJdbcService;

import com.example.cafemanhdu.service.OrderService;
import com.example.cafemanhdu.dao.MenuItemsDAO;
import com.example.cafemanhdu.model.MenuItem;
import com.example.cafemanhdu.model.OrderForm;
import com.example.cafemanhdu.service.AdminService;
import com.example.cafemanhdu.service.OrderService.OrderItem;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Controller
public class HomeController {
    @Autowired
    private TestJdbcService testJdbcService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private AdminService adminService;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Model model) {
        String jdbcMessage = testJdbcService.testConnection();
        model.addAttribute("jdbcMessage", jdbcMessage);
        return "index";
    }
    
    @GetMapping("/scanQr")
    public String scanQr(@RequestParam("qrCode") String qrCode, Model model) {
        try {
            if (orderService.validateQrCode(qrCode)) {
                int tableId = orderService.getTableIdByQrCode(qrCode);
                List<MenuItem> menuItems = orderService.getAvailableItems();
                model.addAttribute("tableId", tableId);
                model.addAttribute("menuItems", menuItems);
                return "order";
            } else {
                model.addAttribute("error", "Invalid QR Code");
                return "index";
            }
        } catch (SQLException e) {
            model.addAttribute("error", "Error validating QR code: " + e.getMessage());
            return "index";
        }
    }

    @PostMapping("/submitOrder")
    public String submitOrder(@ModelAttribute OrderForm orderForm, Model model) {
        try {
            List<OrderItem> selectedItems = new ArrayList<>();
            for (OrderForm.OrderItem formItem : orderForm.getItems()) {
                if (formItem.getQuantity() > 0) {
                    selectedItems.add(new OrderItem(formItem.getItemId(), formItem.getItemName(), formItem.getPrice(), formItem.getQuantity()));
                }
            }
            if (selectedItems.isEmpty()) {
                model.addAttribute("error", "Please select at least one item");
                model.addAttribute("tableId", orderForm.getTableId());
                model.addAttribute("menuItems", orderService.getAvailableItems());
                return "order";
            }
            orderService.submitOrder(orderForm.getTableId(), selectedItems, orderForm.getPaymentMethod(), orderForm.getComments());
            model.addAttribute("message", "Order submitted successfully!");
            return "orderConfirmation";
        } catch (SQLException e) {
            model.addAttribute("error", "Error submitting order: " + e.getMessage());
            model.addAttribute("tableId", orderForm.getTableId());
            try {
                model.addAttribute("menuItems", orderService.getAvailableItems());
            } catch (SQLException ex) {
                model.addAttribute("error", "Error loading menu: " + ex.getMessage());
            }
            return "order";
        }
    }

    @GetMapping("/admin")
    public String adminDashboard(Model model) {
        try {
            model.addAttribute("pendingOrders", adminService.getPendingOrders());
            model.addAttribute("menuItems", adminService.getAllMenuItems());
            return "adminDashboard";
        } catch (SQLException e) {
            model.addAttribute("error", "Error loading admin dashboard: " + e.getMessage());
            return "index";
        }
    }

    @PostMapping("/updateOrderStatus")
    public String updateOrderStatus(@RequestParam("orderId") int orderId, @RequestParam("status") String status, Model model) {
        try {
            adminService.updateOrderStatus(orderId, status);
            return "redirect:/admin";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating order status: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/updateItemStatus")
    public String updateItemStatus(@RequestParam("itemId") int itemId, @RequestParam("status") String status, Model model) {
        try {
            adminService.updateItemStatus(itemId, status);
            return "redirect:/admin";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating item status: " + e.getMessage());
            return "adminDashboard";
        }
    }
}