<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
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
        window.onload = function() {
            var activeTab = "${activeTab}";
            var tabToOpen = activeTab ? activeTab : "pendingOrders";
            document.querySelector("[onclick*='" + tabToOpen + "']").click();
        };
    </script>
</head>
<body>
    <h1>Admin Dashboard <a href="${pageContext.request.contextPath}/"><button class="logout-btn">Thoát</button></a></h1>
    <div class="tab">
        <button class="tablinks" onclick="openTab(event, 'pendingOrders')">Pending Orders</button>
        <button class="tablinks" onclick="openTab(event, 'menuManagement')">Menu Management</button>
        <button class="tablinks" onclick="openTab(event, 'tableManagement')">Table Management</button>
        <button class="tablinks" onclick="openTab(event, 'orderHistory')">Order History</button>
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
                        <td>${order.totalAmount}</td>
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
                    <td>${item.price}</td>
                    <td>${item.status}</td>
                    <td>
                        <form action="editMenuItem" method="get">
                            <input type="hidden" name="itemId" value="${item.itemId}">
                            <button type="submit">Edit</button>
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
                        <img src="${pageContext.request.contextPath}/generateQr?qrCode=${table.qrCode}" alt="QR Code for ${table.tableNumber}" style="max-width: 100px;">
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
                        <td>${order.totalAmount}</td>
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
</body>
</html>