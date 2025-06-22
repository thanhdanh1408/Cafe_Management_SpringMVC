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
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import java.io.OutputStream;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.example.cafemanhdu.service.OrderService;
import com.example.cafemanhdu.dao.MenuItemsDAO;
import com.example.cafemanhdu.dao.OrdersDAO;
import com.example.cafemanhdu.dao.TablesDAO;
import com.example.cafemanhdu.model.MenuItem;
import com.example.cafemanhdu.model.Order;
import com.example.cafemanhdu.model.OrderDetail;
import com.example.cafemanhdu.model.OrderForm;
import com.example.cafemanhdu.model.Table;
import com.example.cafemanhdu.service.AdminService;
import com.example.cafemanhdu.service.OrderService.OrderItem;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
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
    @Autowired
    private TablesDAO TablesDAO;
    @Autowired
    private OrdersDAO OrdersDAO;
    
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
    
    @GetMapping("/tableInfo")
    public String tableInfo(@RequestParam("qr_code") String qrCode, Model model) {
        try {
            int tableId = TablesDAO.getTableIdByQrCode(qrCode);
            model.addAttribute("tableId", tableId);
            // Nếu muốn lấy thêm info thì lấy tiếp ở đây (nếu cần)
            // Table table = tablesDAO.getTableById(tableId);
            // model.addAttribute("table", table);
            return "tableInfo"; // Tên file JSP
        } catch (SQLException e) {
            model.addAttribute("error", "Không tìm thấy bàn với mã QR này!");
            return "tableInfo"; // Trang báo lỗi
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
                model.addAttribute("error", "Vui lòng chọn ít nhất một mục");
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
            List<Order> pendingOrders = adminService.getPendingOrders();
            for (Order order : pendingOrders) {
                order.setTotalAmount(order.getTotalAmount().multiply(new java.math.BigDecimal("1000")));
            }
            model.addAttribute("pendingOrders", pendingOrders);

            model.addAttribute("menuItems", adminService.getAllMenuItems());
            model.addAttribute("tables", orderService.getAllTables());

            List<Order> orderHistory = orderService.getOrderHistory();
            for (Order order : orderHistory) {
                order.setTotalAmount(order.getTotalAmount().multiply(new java.math.BigDecimal("1000")));
            }
            model.addAttribute("orderHistory", orderHistory);

            // Nhân doanh thu với 1000 để hiển thị
            BigDecimal dailyRevenue = orderService.calculateDailyRevenue() != null ? orderService.calculateDailyRevenue() : BigDecimal.ZERO;
            BigDecimal weeklyRevenue = orderService.calculateWeeklyRevenue() != null ? orderService.calculateWeeklyRevenue() : BigDecimal.ZERO;
            BigDecimal monthlyRevenue = orderService.calculateMonthlyRevenue() != null ? orderService.calculateMonthlyRevenue() : BigDecimal.ZERO;
            BigDecimal yearlyRevenue = orderService.calculateYearlyRevenue() != null ? orderService.calculateYearlyRevenue() : BigDecimal.ZERO;
            model.addAttribute("dailyRevenue", dailyRevenue.multiply(new java.math.BigDecimal("1000")));
            model.addAttribute("weeklyRevenue", weeklyRevenue.multiply(new java.math.BigDecimal("1000")));
            model.addAttribute("monthlyRevenue", monthlyRevenue.multiply(new java.math.BigDecimal("1000")));
            model.addAttribute("yearlyRevenue", yearlyRevenue.multiply(new java.math.BigDecimal("1000")));

            // Nhân giá với 1000 để hiển thị
            List<MenuItem> menuItems = adminService.getAllMenuItems();
            for (MenuItem item : menuItems) {
                item.setPrice(item.getPrice().multiply(new java.math.BigDecimal("1000")));
            }
            model.addAttribute("menuItems", menuItems);

            // Gán chi tiết đơn hàng
            List<Order> pendingOrdersList = (List<Order>) model.getAttribute("pendingOrders");
            for (Order order : pendingOrdersList) {
                List<OrderDetail> details = orderService.getOrderDetails(order.getOrderId());
                if (details != null && !details.isEmpty()) {
                    order.setDetails(details);
                    System.out.println("Assigned details to orderId " + order.getOrderId() + ": " + details.size() + " items");
                } else {
                    order.setDetails(new ArrayList<>());
                    System.out.println("No details assigned for order ID: " + order.getOrderId());
                }
            }

            List<Order> orderHistoryList = (List<Order>) model.getAttribute("orderHistory");
            for (Order order : orderHistoryList) {
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

    @PostMapping("/login")
    public String loginAdmin(HttpServletRequest request, Model model) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if ("admin".equals(username) && "123".equals(password)) {
            request.getSession().setAttribute("role", "admin");
            return "redirect:/admin"; // hoặc trang dashboard admin
        } else {
            model.addAttribute("error", "Sai tài khoản hoặc mật khẩu");
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
            Model model) {
        try {
            adminService.updateOrder(orderId, paymentMethod, comments);
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
    
    @GetMapping("/editPendingOrder")
    public String editPendingOrder(@RequestParam("orderId") int orderId, Model model) {
        try {
            Order order = orderService.getOrderById(orderId); // Lấy thông tin đơn hàng
            model.addAttribute("order", order);
            return "editPendingOrder";
        } catch (SQLException e) {
            model.addAttribute("error", "Error loading order: " + e.getMessage());
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
            adminService.updateOrder(orderId, paymentMethod, comments);
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
    
    //Phương thức tạo món
    @PostMapping("/createMenuItem")
    public String createMenuItem(@RequestParam("itemName") String itemName, @RequestParam("price") BigDecimal price, @RequestParam("status") String status, Model model) {
        try {
        	try {
        	// Chia cho 1000 để chuyển từ 20000 (20.000 VND) thành 20.00
            BigDecimal priceValue = price.divide(new java.math.BigDecimal("1000"), 2, java.math.BigDecimal.ROUND_HALF_UP);
            if (priceValue.compareTo(BigDecimal.ZERO) < 0 || priceValue.compareTo(new BigDecimal("100000")) > 0) {
                model.addAttribute("error", "Giá phải từ 0 đến 100.000 VND!");
                return "addMenuItem";
            	} 
        	} catch (NumberFormatException e) {
                model.addAttribute("error", "Giá chỉ được nhập số!");
                return "addMenuItem";
            }
            
            adminService.createMenuItem(itemName, price, status);
            return "redirect:/admin?tab=menuManagement";
        } catch (SQLException e) {
            model.addAttribute("error", "Error creating menu item: " + e.getMessage());
            return "adminDashboard";
        }
    }
    
    //Trang thêm món
    @GetMapping("/addMenuItem")
    public String showAddMenuItemPage() {
        return "addMenuItem"; // Trả về trang addMenuItem.jsp
    }

    @GetMapping("/editMenuItem")
    public String editMenuItem(@RequestParam("itemId") int itemId, Model model) {
        try {
            MenuItem item = adminService.getMenuItemById(itemId); // Giả sử có phương thức này
            if (item != null) {
                // Nhân giá với 1000 để hiển thị
                item.setPrice(item.getPrice().multiply(new java.math.BigDecimal("1000")));
                model.addAttribute("item", item);
            } else {
                model.addAttribute("error", "Menu item not found!");
                return "adminDashboard";
            }
            return "editMenuItem"; 
        } catch (SQLException e) {
            model.addAttribute("error", "Error loading menu item: " + e.getMessage());
            try {
                model.addAttribute("menuItems", adminService.getAllMenuItems());
                model.addAttribute("pendingOrders", adminService.getPendingOrders());
                model.addAttribute("tables", orderService.getAllTables());
                model.addAttribute("orderHistory", orderService.getOrderHistory());
                model.addAttribute("activeTab", "menuManagement");
            } catch (SQLException ex) {
                model.addAttribute("error", "Error reloading data: " + ex.getMessage());
            }
            return "adminDashboard";
        }
    }
    
    @PostMapping("/updateMenuItem")
    public String updateMenuItem(@RequestParam("itemId") int itemId, @RequestParam("itemName") String itemName, 
                                @RequestParam("price") BigDecimal price, @RequestParam("status") String status, Model model) {
        try {
        	// Chia cho 1000 để chuyển từ 20000 (20.000 VND) thành 20.00
            BigDecimal priceValue = price.divide(new java.math.BigDecimal("1000"), 2, java.math.BigDecimal.ROUND_HALF_UP);
            adminService.updateMenuItem(itemId, itemName, price, status);
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
            OrdersDAO.reorderOrderIds(); // Sắp xếp lại orderId
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