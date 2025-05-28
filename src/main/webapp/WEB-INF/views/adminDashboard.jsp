<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .tab { overflow: hidden; border-bottom: 1px solid #ccc; }
        .tab button { background-color: inherit; float: left; border: none; outline: none; cursor: pointer; padding: 14px 16px; transition: 0.3s; }
        .tab button:hover { background-color: #ddd; }
        .tab button.active { background-color: #4CAF50; color: white; }
        .tabcontent { display: none; padding: 20px; border: 1px solid #ccc; border-top: none; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        .form-container { margin-bottom: 20px; }
        .empty-message { color: #888; font-style: italic; }
        .error-message { color: red; margin-bottom: 10px; }
        input[type="text"], select, input[type="date"] { padding: 5px; margin-right: 5px; }
        button { padding: 5px 10px; cursor: pointer; }
        .logout-btn { float: right; padding: 10px 20px; background-color: #ff4444; color: white; border: none; cursor: pointer; }
        .logout-btn:hover { background-color: #cc0000; }
        
        /* Sales Stats Styles */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #ffffff;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin: 15px 0;
        }
        
        .filter-container {
            margin: 25px 0;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .filter-container select, .filter-container input[type="date"] {
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
        }
        
        .stat-title {
            color: #4CAF50;
            margin: 0;
        }
        
        .chart-container {
            margin-top: 30px;
            height: 400px;
        }
        
        .order-details {
            margin-top: 30px;
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .order-details h3 {
            margin-top: 0;
            color: #2c3e50;
        }
    </style>
    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
        
        function toggleDateInput() {
            var period = document.getElementById('periodSelect').value;
            var dateInput = document.getElementById('dateInput');
            dateInput.style.display = period === 'custom' ? 'inline-block' : 'none';
        }
        
        document.getElementById('dateInput').addEventListener('change', function() {
            if (document.getElementById('periodSelect').value === 'custom') {
                document.getElementById('statsForm').submit();
            }
        });
        
        document.getElementById('periodSelect').addEventListener('change', function() {
            toggleDateInput();
            document.getElementById('statsForm').submit();
        });
        
        window.onload = function() {
            toggleDateInput();
            var activeTab = "${activeTab}";
            var urlParams = new URLSearchParams(window.location.search);
            var tabToOpen = activeTab ? activeTab : 
                urlParams.has('period') ? "salesStats" : "pendingOrders";
            document.querySelector("[onclick*='" + tabToOpen + "']").click();
        };
    </script>
</head>
<body>
    <h1>Admin Dashboard <a href="/CafeManagement/"><button class="logout-btn">Thoát</button></a></h1>
    <div class="tab">
        <button class="tablinks" onclick="openTab(event, 'pendingOrders')">Pending Orders</button>
        <button class="tablinks" onclick="openTab(event, 'menuManagement')">Menu Management</button>
        <button class="tablinks" onclick="openTab(event, 'tableManagement')">Table Management</button>
        <button class="tablinks" onclick="openTab(event, 'orderHistory')">Order History</button>
        <button class="tablinks" onclick="openTab(event, 'salesStats')">Sales Statistics</button>
    </div>

    <div id="pendingOrders" class="tabcontent">
        <h2>Pending Orders</h2>
        <c:if test="${empty pendingOrders}">
            <p class="empty-message">No pending orders available.</p>
        </c:if>
        <c:if test="${not empty pendingOrders}">
            <table>
                <tr><th>Order ID</th><th>Table</th><th>Time</th><th>Payment Method</th><th>Total Amount</th><th>Comments</th><th>Status</th><th>Action</th></tr>
                <c:forEach var="order" items="${pendingOrders}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.tableNumber}</td>
                        <td>${order.orderTime}</td>
                        <td>
                            <form action="updatePendingOrder" method="post" style="display:inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="text" name="paymentMethod" value="${order.paymentMethod}" required>
                                <input type="text" name="comments" value="${order.comments}">
                                <select name="status">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="preparing">Preparing</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                                <button type="submit">Update</button>
                            </form>
                        </td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                        <td>${order.comments}</td>
                        <td>${order.status}</td>
                        <td>
                            <form action="deleteOrder" method="post" style="display:inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </div>

    <div id="menuManagement" class="tabcontent">
        <h2>Menu Management</h2>
        <div class="form-container">
            <h3>Add New Menu Item</h3>
            <form action="createMenuItem" method="post">
                <input type="text" name="itemName" placeholder="Item Name" required>
                <input type="number" name="price" step="0.01" placeholder="Price" required>
                <button type="submit">Add</button>
            </form>
        </div>
        <table>
            <tr><th>Item ID</th><th>Item Name</th><th>Price</th><th>Status</th><th>Action</th></tr>
            <c:forEach var="item" items="${menuItems}">
                <tr>
                    <td>${item.itemId}</td>
                    <td>${item.itemName}</td>
                    <td><fmt:formatNumber value="${item.price}" type="currency"/></td>
                    <td>${item.status}</td>
                    <td>
                        <form action="updateMenuItem" method="post" style="display:inline;">
                            <input type="hidden" name="itemId" value="${item.itemId}">
                            <input type="text" name="itemName" value="${item.itemName}" required>
                            <input type="number" name="price" step="0.01" value="${item.price}" required>
                            <button type="submit">Update</button>
                        </form>
                        <form action="deleteMenuItem" method="post" style="display:inline;">
                            <input type="hidden" name="itemId" value="${item.itemId}">
                            <button type="submit">Delete</button>
                        </form>
                        <form action="updateItemStatus" method="post" style="display:inline;">
                            <input type="hidden" name="itemId" value="${item.itemId}">
                            <select name="status">
                                <option value="available" ${item.status == 'available' ? 'selected' : ''}>Available</option>
                                <option value="unavailable" ${item.status == 'unavailable' ? 'selected' : ''}>Unavailable</option>
                            </select>
                            <button type="submit">Update Status</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div id="tableManagement" class="tabcontent">
        <h2>Table Management</h2>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
        <div class="form-container">
            <h3>Add New Table</h3>
            <form action="createTable" method="post">
                <input type="text" name="tableNumber" placeholder="Table Number" required>
                <button type="submit">Add</button>
            </form>
        </div>
        <table>
            <tr><th>Table ID</th><th>Table Number</th><th>QR Code</th><th>Status</th><th>Action</th></tr>
            <c:forEach var="table" items="${tables}">
                <tr>
                    <td>${table.tableId}</td>
                    <td>${table.tableNumber}</td>
                    <td>
                        <img src="/CafeManagement/generateQr?qrCode=${table.qrCode}" alt="QR Code for ${table.tableNumber}" width="100">
                    </td>
                    <td>${table.status}</td>
                    <td>
                        <form action="deleteTable" method="post" style="display:inline;">
                            <input type="hidden" name="tableId" value="${table.tableId}">
                            <button type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div id="orderHistory" class="tabcontent">
        <h2>Order History</h2>
        <c:if test="${empty orderHistory}">
            <p class="empty-message">No order history available.</p>
        </c:if>
        <c:if test="${not empty orderHistory}">
            <table>
                <tr><th>Order ID</th><th>Table</th><th>Time</th><th>Payment Method</th><th>Total Amount</th><th>Comments</th><th>Status</th><th>Action</th></tr>
                <c:forEach var="order" items="${orderHistory}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.tableNumber}</td>
                        <td>${order.orderTime}</td>
                        <td>
                            <form action="updateOrderHistory" method="post" style="display:inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="text" name="paymentMethod" value="${order.paymentMethod}" required>
                                <input type="text" name="comments" value="${order.comments}">
                                <select name="status">
                                    <option value="preparing" ${order.status == 'preparing' ? 'selected' : ''}>Preparing</option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <button type="submit">Update</button>
                            </form>
                        </td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                        <td>${order.comments}</td>
                        <td>${order.status}</td>
                        <td>
                            <form action="deleteOrderHistory" method="post" style="display:inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </div>

    <div id="salesStats" class="tabcontent">
        <h2>Thống kê doanh thu</h2>
        
        <div class="filter-container">
            <form action="salesStats" method="get" id="statsForm">
                <select name="period" id="periodSelect">
                    <option value="today" ${period == 'today' ? 'selected' : ''}>Hôm nay</option>
                    <option value="week" ${period == 'week' ? 'selected' : ''}>Tuần này</option>
                    <option value="month" ${period == 'month' ? 'selected' : ''}>Tháng này</option>
                    <option value="custom" ${period == 'custom' ? 'selected' : ''}>Tùy chỉnh</option>
                </select>
                <input type="date" name="selectedDate" id="dateInput" value="${selectedDate}" style="display: ${period == 'custom' ? 'inline-block' : 'none'}; margin-left: 10px;">
            </form>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h3 class="stat-title">Tổng doanh thu</h3>
                <p class="stat-value">
                    <c:if test="${not empty stats.totalRevenue}">
                        <fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencyCode="VND"/>
                    </c:if>
                    <c:if test="${empty stats.totalRevenue}">0 ₫</c:if>
                </p>
            </div>
            
            <div class="stat-card">
                <h3 class="stat-title">Số đơn hàng</h3>
                <p class="stat-value">${not empty stats.orderCount ? stats.orderCount : 0}</p>
            </div>
        </div>

        <div class="order-details">
            <h3>Chi tiết đơn hàng</h3>
            <c:if test="${empty stats.orders}">
                <p class="empty-message">Không có đơn hàng nào trong khoảng thời gian này.</p>
            </c:if>
            <c:if test="${not empty stats.orders}">
                <table>
                    <tr>
                        <th>Order ID</th>
                        <th>Thời gian</th>
                        <th>Bàn</th>
                        <th>Phương thức thanh toán</th>
                        <th>Tổng tiền</th>
                        <th>Ghi chú</th>
                        <th>Trạng thái</th>
                    </tr>
                    <c:forEach var="order" items="${stats.orders}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td>${order.tableNumber}</td>
                            <td>${order.paymentMethod}</td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND"/></td>
                            <td>${order.comments}</td>
                            <td>${order.status}</td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
        </div>
    </div>

    <script>
        function toggleDateInput() {
            var period = document.getElementById('periodSelect').value;
            var dateInput = document.getElementById('dateInput');
            dateInput.style.display = period === 'custom' ? 'inline-block' : 'none';
        }

        document.getElementById('dateInput').addEventListener('change', function() {
            if (document.getElementById('periodSelect').value === 'custom') {
                document.getElementById('statsForm').submit();
            }
        });

        document.getElementById('periodSelect').addEventListener('change', function() {
            toggleDateInput();
            document.getElementById('statsForm').submit();
        });

        window.onload = function() {
            toggleDateInput();
            var activeTab = "${activeTab}";
            var urlParams = new URLSearchParams(window.location.search);
            var tabToOpen = activeTab ? activeTab : 
                urlParams.has('period') ? "salesStats" : "pendingOrders";
            document.querySelector("[onclick*='" + tabToOpen + "']").click();
        };
    </script>
</body>
</html>