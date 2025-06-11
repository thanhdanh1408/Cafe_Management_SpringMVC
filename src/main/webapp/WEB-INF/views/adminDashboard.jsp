<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

.tab {
	overflow: hidden;
	border-bottom: 1px solid #ccc;
}

.tab button {
	background-color: inherit;
	float: left;
	border: none;
	outline: none;
	cursor: pointer;
	padding: 14px 16px;
	transition: 0.3s;
}

.tab button:hover {
	background-color: #ddd;
}

.tab button.active {
	background-color: #4CAF50;
	color: white;
}

.tabcontent {
	display: none;
	padding: 20px;
	border: 1px solid #ccc;
	border-top: none;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

th, td {
	padding: 10px;
	border: 1px solid #ddd;
}

th {
	background-color: #f2f2f2;
}

.form-container {
	margin-bottom: 20px;
}

.empty-message {
	color: #888;
	font-style: italic;
}

.error-message {
	color: red;
	margin-bottom: 10px;
}

input[type="text"], select {
	padding: 5px;
	margin-right: 5px;
}

button {
	padding: 5px 10px;
	cursor: pointer;
}

.logout-btn {
	float: right;
	padding: 10px 20px;
	background-color: #ff4444;
	color: white;
	border: none;
	cursor: pointer;
}

.logout-btn:hover {
	background-color: #cc0000;
}

.edit-form {
	display: none;
	margin-top: 10px;
	padding: 10px;
	border: 1px solid #ccc;
	background-color: #f9f9f9;
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
    function toggleEditForm(itemId) {
        var form = document.getElementById('editForm-' + itemId);
        if (form.style.display === 'none' || form.style.display === '') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
    
    function updateChart() {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const period = document.getElementById('periodFilter').value;
        const labels = ['Day', 'Week', 'Month', 'Year'];
        const data = {
            labels: labels,
            datasets: [{
                label: 'Revenue (VND)',
                data: [
                    parseFloat('${dailyRevenue}') || 0,
                    parseFloat('${weeklyRevenue}') || 0,
                    parseFloat('${monthlyRevenue}') || 0,
                    parseFloat('${yearlyRevenue}') || 0
                ],
                backgroundColor: 'rgba(76, 175, 80, 0.2)',
                borderColor: 'rgba(76, 175, 80, 1)',
                borderWidth: 1
            }]
        };
        if (window.revenueChart) {
            window.revenueChart.destroy();
        }
        window.revenueChart = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
    
    window.onload = function() {
        var activeTab = "${activeTab}";
        var tabToOpen = activeTab ? activeTab : "pendingOrders";
        document.querySelector("[onclick*='" + tabToOpen + "']").click();
    };
</script>
</head>
<body>
	<h1>
		Admin Dashboard <a href="/CafeManagement/"><button
				class="logout-btn">Thoát</button></a>
	</h1>
	<div class="tab">
		<button class="tablinks" onclick="openTab(event, 'pendingOrders')">Pending
			Orders</button>
		<button class="tablinks" onclick="openTab(event, 'menuManagement')">Menu
			Management</button>
		<button class="tablinks" onclick="openTab(event, 'tableManagement')">Table
			Management</button>
		<button class="tablinks" onclick="openTab(event, 'orderHistory')">Order
			History</button>
	</div>

	<div id="pendingOrders" class="tabcontent">
    <h2>Pending Orders</h2>
    <c:if test="${empty pendingOrders}">
        <p class="empty-message">No pending orders available.</p>
    </c:if>
    <c:if test="${not empty pendingOrders}">
        <table>
            <tr>
                <th>Order ID</th>
                <th>Table</th>
                <th>Time</th>
                <th>Payment Method</th>
                <th>Total Amount</th>
                <th>Comments</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <c:forEach var="order" items="${pendingOrders}">
                <tr>
                    <td>${order.orderId}</td>
                    <td>${order.tableNumber}</td>
                    <td>${order.orderTime}</td>
                    <td>${order.paymentMethod}</td> <!-- Hiển thị tĩnh -->
                    <td>${order.totalAmount}</td>
                    <td>${order.comments}</td>
                    <td>${order.status}</td>
                    <td>
                        <button onclick="toggleEditForm(${order.orderId})">Edit</button>
                        <form action="deleteOrder" method="post" style="display: inline;">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <button type="submit">Delete</button>
                        </form>
                        <div id="editForm-${order.orderId}" class="edit-form">
                            <form action="updatePendingOrder" method="post">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <label>Payment Method:</label>
                                <select name="paymentMethod">
                                	<option value="cash" ${order.paymentMethod == 'cash' ? 'selected' : ''}>Tiền mặt</option>
                                	<option value="card" ${order.paymentMethod == 'Chuyển khoản' ? 'selected' : ''}>Chuyển khoản</option>
                                </select>
                                <br>
                                <label>Comments:</label>
                                <input type="text" name="comments" value="${order.comments}">
                                <br>
                                <label>Status:</label>
                                <select name="status">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="preparing" ${order.status == 'preparing' ? 'selected' : ''}>Preparing</option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <button type="submit">Save</button>
                            </form>
                        </div>
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
				<input type="number" name="price" step="0.01" placeholder="Price"
					required>
				<button type="submit">Add</button>
			</form>
		</div>
		<table>
			<tr>
				<th>Item ID</th>
				<th>Item Name</th>
				<th>Price</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			<c:forEach var="item" items="${menuItems}">
				<tr>
					<td>${item.itemId}</td>
					<td>${item.itemName}</td>
					<td>${item.price}</td>
					<td>${item.status}</td>
					<td>
						<button onclick="toggleEditForm(${item.itemId})">Edit</button>
						<form action="deleteMenuItem" method="post"
							style="display: inline;">
							<input type="hidden" name="itemId" value="${item.itemId}">
							<button type="submit">Delete</button>
						</form>
						<div id="editForm-${item.itemId}" class="edit-form">
							<form action="updateMenuItem" method="post">
								<input type="hidden" name="itemId" value="${item.itemId}">
								<label>Name:</label> <input type="text" name="itemName"
									value="${item.itemName}" required> <label>Price:</label>
								<input type="number" name="price" step="0.01"
									value="${item.price}" required> <label>Status:</label>
								<select name="status">
									<option value="available"
										${item.status == 'available' ? 'selected' : ''}>Available</option>
									<option value="unavailable"
										${item.status == 'unavailable' ? 'selected' : ''}>Unavailable</option>
								</select>
								<button type="submit">Save</button>
							</form>
						</div>
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
				<input type="text" name="tableNumber" placeholder="Table Number"
					required>
				<button type="submit">Add</button>
			</form>
		</div>
		<table>
			<tr>
				<th>Table ID</th>
				<th>Table Number</th>
				<th>QR Code</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			<c:forEach var="table" items="${tables}">
				<tr>
					<td>${table.tableId}</td>
					<td>${table.tableNumber}</td>
					<td><img
						src="/CafeManagement/generateQr?qrCode=${table.qrCode}"
						alt="QR Code for ${table.tableNumber}"></td>
					<td>${table.status}</td>
					<td>
						<form action="deleteTable" method="post" style="display: inline;">
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
				<tr>
					<th>Order ID</th>
					<th>Table</th>
					<th>Time</th>
					<th>Payment Method</th>
					<th>Total Amount</th>
					<th>Comments</th>
					<th>Status</th>
					<th>Action</th>
				</tr>
				<c:forEach var="order" items="${orderHistory}">
					<tr>
						<td>${order.orderId}</td>
						<td>${order.tableNumber}</td>
						<td>${order.orderTime}</td>
						<td>${order.paymentMethod}</td>
						<td>${order.totalAmount}</td>
						<td>${order.comments}</td>
						<td>${order.status}</td>
						<td>
							<form action="deleteOrderHistory" method="post"
								style="display: inline;">
								<input type="hidden" name="orderId" value="${order.orderId}">
								<button type="submit">Delete</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>
	</div>
	
<%-- 	<div id="revenueStatistics" class="tabcontent">
        <h2>Revenue Statistics</h2>
        <div>
            <label for="periodFilter">Select Period:</label>
            <select id="periodFilter" onchange="updateChart()">
                <option value="all">All</option>
                <option value="day">Day</option>
                <option value="week">Week</option>
                <option value="month">Month</option>
                <option value="year">Year</option>
            </select>
        </div>
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>
        <table>
            <tr>
                <th>Period</th>
                <th>Revenue (VND)</th>
            </tr>
            <tr>
                <td>Daily</td>
                <td><c:out value="${dailyRevenue}"/> VND</td>
            </tr>
            <tr>
                <td>Weekly</td>
                <td><c:out value="${weeklyRevenue}"/> VND</td>
            </tr>
            <tr>
                <td>Monthly</td>
                <td><c:out value="${monthlyRevenue}"/> VND</td>
            </tr>
            <tr>
                <td>Yearly</td>
                <td><c:out value="${yearlyRevenue}"/> VND</td>
            </tr>
        </table>
    </div> --%>
</body>
</html>