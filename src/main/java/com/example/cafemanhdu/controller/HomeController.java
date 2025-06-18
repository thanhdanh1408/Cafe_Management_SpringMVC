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
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.OrderDetail;
import com.example.cafemanhdu.model.OrderForm;
import com.example.cafemanhdu.model.Table;
import com.example.cafemanhdu.service.AdminService;
import com.example.cafemanhdu.service.OrderService.OrderItem;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
                model.addAttribute("qrCode", qrCode); // Lưu qrCode để quay lại
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
            model.addAttribute("qrCode", orderForm.getQrCode()); // Truyền qrCode sang trang xác nhận
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
    public String adminDashboard(Model model, @RequestParam(value = "tab", defaultValue = "pendingOrders") String tab) {
        try {
            model.addAttribute("pendingOrders", adminService.getPendingOrders());
            model.addAttribute("menuItems", adminService.getAllMenuItems());
            model.addAttribute("tables", orderService.getAllTables());
            model.addAttribute("orderHistory", orderService.getOrderHistory());
            model.addAttribute("dailyRevenue", orderService.calculateDailyRevenue());
            model.addAttribute("weeklyRevenue", orderService.calculateWeeklyRevenue());
            model.addAttribute("monthlyRevenue", orderService.calculateMonthlyRevenue());
            model.addAttribute("yearlyRevenue", orderService.calculateYearlyRevenue());
            
         // Gán chi tiết đơn hàng
            List<Order> pendingOrders = (List<Order>) model.getAttribute("pendingOrders");
            for (Order order : pendingOrders) {
                List<OrderDetail> details = orderService.getOrderDetails(order.getOrderId());
                if (details != null && !details.isEmpty()) {
                    order.setDetails(details);
                    System.out.println("Assigned details to orderId " + order.getOrderId() + ": " + details.size() + " items");
                } else {
                    order.setDetails(new ArrayList<>());
                    System.out.println("No details assigned for order ID: " + order.getOrderId());
                }
            }
            List<Order> orderHistory = (List<Order>) model.getAttribute("orderHistory");
            for (Order order : orderHistory) {
                List<OrderDetail> details = orderService.getOrderDetails(order.getOrderId());
                if (details != null && !details.isEmpty()) {
                    order.setDetails(details);
                    System.out.println("Assigned details to orderId " + order.getOrderId() + ": " + details.size() + " items");
                } else {
                    order.setDetails(new ArrayList<>());
                    System.out.println("No details assigned for order ID: " + order.getOrderId());
                }
            }
            
         // Thêm thống kê số lượng order của các món
            Map<String, Integer> dailyItemOrderCounts = orderService.getDailyItemOrderCounts();
            model.addAttribute("dailyItemOrderCounts", dailyItemOrderCounts);
            
            model.addAttribute("activeTab", tab);
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
            return "redirect:/admin?tab=pendingOrders";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating order status: " + e.getMessage());
            return "adminDashboard";
        }
    }
    
    @PostMapping("/updatePendingOrder")
    public String updatePendingOrder(
            @RequestParam("orderId") int orderId,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam("comments") String comments,
            @RequestParam("status") String status,
            Model model) {
        try {
            adminService.updateOrder(orderId, paymentMethod, comments, status);
            return "redirect:/admin?tab=pendingOrders";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating order: " + e.getMessage());
            try {
                model.addAttribute("pendingOrders", adminService.getPendingOrders());
                model.addAttribute("menuItems", adminService.getAllMenuItems());
                model.addAttribute("tables", orderService.getAllTables());
                model.addAttribute("orderHistory", orderService.getOrderHistory());
                model.addAttribute("activeTab", "pendingOrders");
            } catch (SQLException ex) {
                model.addAttribute("error", "Error reloading data: " + ex.getMessage());
            }
            return "adminDashboard";
        }
    }

    @PostMapping("/updateOrderHistory")
    public String updateOrderHistory(
            @RequestParam("orderId") int orderId,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam("comments") String comments,
            @RequestParam("status") String status,
            Model model) {
        try {
            adminService.updateOrder(orderId, paymentMethod, comments, status);
            return "redirect:/admin?tab=orderHistory";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating order history: " + e.getMessage());
            try {
                model.addAttribute("pendingOrders", adminService.getPendingOrders());
                model.addAttribute("menuItems", adminService.getAllMenuItems());
                model.addAttribute("tables", orderService.getAllTables());
                model.addAttribute("orderHistory", orderService.getOrderHistory());
                model.addAttribute("activeTab", "orderHistory");
            } catch (SQLException ex) {
                model.addAttribute("error", "Error reloading data: " + ex.getMessage());
            }
            return "adminDashboard";
        }
    }
    
    @PostMapping("/deleteOrderHistory")
    public String deleteOrderHistory(@RequestParam("orderId") int orderId, Model model) {
        try {
            adminService.deleteOrder(orderId); // Sử dụng cùng logic xóa như Pending Orders
            return "redirect:/admin?tab=orderHistory";
        } catch (SQLException e) {
            model.addAttribute("error", "Error deleting order history: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/updateItemStatus")
    public String updateItemStatus(@RequestParam("itemId") int itemId, @RequestParam("status") String status, Model model) {
        try {
            adminService.updateItemStatus(itemId, status);
            return "redirect:/admin?tab=menuManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating item status: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/createMenuItem")
    public String createMenuItem(@RequestParam("itemName") String itemName, @RequestParam("price") java.math.BigDecimal price, Model model) {
        try {
            adminService.createMenuItem(itemName, price);
            return "redirect:/admin?tab=menuManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error creating menu item: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/updateMenuItem")
    public String updateMenuItem(@RequestParam("itemId") int itemId, @RequestParam("itemName") String itemName, 
                                @RequestParam("price") java.math.BigDecimal price, @RequestParam("status") String status, Model model) {
        try {
            adminService.updateMenuItem(itemId, itemName, price);
            adminService.updateItemStatus(itemId, status); // Cập nhật status
            return "redirect:/admin?tab=menuManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error updating menu item: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/deleteMenuItem")
    public String deleteMenuItem(@RequestParam("itemId") int itemId, Model model) {
        try {
            adminService.deleteMenuItem(itemId);
            return "redirect:/admin?tab=menuManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error deleting menu item: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/deleteOrder")
    public String deleteOrder(@RequestParam("orderId") int orderId, Model model) {
        try {
            adminService.deleteOrder(orderId);
            return "redirect:/admin?tab=pendingOrders";
        } catch (SQLException e) {
            model.addAttribute("error", "Error deleting order: " + e.getMessage());
            return "adminDashboard";
        }
    }

    @PostMapping("/createTable")
    public String createTable(@RequestParam("tableNumber") String tableNumber, Model model) {
        try {
            orderService.createTable(tableNumber);
            return "redirect:/admin?tab=tableManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Số bàn đã có, hãy chọn số khác");
            try {
                model.addAttribute("pendingOrders", adminService.getPendingOrders());
                model.addAttribute("menuItems", adminService.getAllMenuItems());
                model.addAttribute("tables", orderService.getAllTables());
                model.addAttribute("orderHistory", orderService.getOrderHistory());
                model.addAttribute("activeTab", "tableManagement");
            } catch (SQLException ex) {
                model.addAttribute("error", "Error reloading data: " + ex.getMessage());
            }
            return "adminDashboard";
        }
    }

    @PostMapping("/deleteTable")
    public String deleteTable(@RequestParam("tableId") int tableId, Model model) {
        try {
            orderService.deleteTable(tableId);
            List<Table> tables = orderService.getAllTables();
            if (tables.isEmpty()) {
                orderService.resetTableId();
            }
            return "redirect:/admin?tab=tableManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error deleting table: " + e.getMessage());
            try {
                model.addAttribute("pendingOrders", adminService.getPendingOrders());
                model.addAttribute("menuItems", adminService.getAllMenuItems());
                model.addAttribute("tables", orderService.getAllTables());
                model.addAttribute("orderHistory", orderService.getOrderHistory());
                model.addAttribute("activeTab", "tableManagement");
            } catch (SQLException ex) {
                model.addAttribute("error", "Error reloading data: " + ex.getMessage());
            }
            return "adminDashboard";
        }
    }
}