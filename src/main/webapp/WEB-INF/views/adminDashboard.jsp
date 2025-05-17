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
</style>
</head>
<body>
	<h1>Admin Dashboard</h1>
	<h2>Pending Orders</h2>
	<table>
		<tr>
			<th>Order ID</th>
			<th>Table</th>
			<th>Time</th>
			<th>Payment Method</th>
			<th>Total Amount</th>
			<th>Comments</th>
			<th>Action</th>
		</tr>
		<c:forEach var="order" items="${pendingOrders}">
			<tr>
				<td>${order.orderId}</td>
				<td>${order.tableNumber}</td>
				<td>${order.orderTime}</td>
				<td>${order.paymentMethod}</td>
				<td>${order.totalAmount}</td>
				<td>${order.comments}</td>
				<td>
					<form action="updateOrderStatus" method="post"
						style="display: inline;">
						<input type="hidden" name="orderId" value="${order.orderId}">
						<select name="status">
							<option value="preparing">Preparing</option>
							<option value="completed">Completed</option>
							<option value="cancelled">Cancelled</option>
						</select>
						<button type="submit">Update</button>
					</form>
				</td>
			</tr>
		</c:forEach>
	</table>

	<h2>Menu Management</h2>
	<table>
		<tr>
			<th>Item ID</th>
			<th>Item Name</th>
			<th>Price</th>
			<th>Status</th>
		</tr>
		<c:forEach var="item" items="${menuItems}">
			<tr>
				<td>${item.itemId}</td>
				<td>${item.itemName}</td>
				<td>${item.price}</td>
				<td>
					<form action="updateItemStatus" method="post"
						style="display: inline;">
						<input type="hidden" name="itemId" value="${item.itemId}">
						<select name="status">
							<option value="available"
								${item.status == 'available' ? 'selected' : ''}>Available</option>
							<option value="unavailable"
								${item.status == 'unavailable' ? 'selected' : ''}>Unavailable</option>
						</select>
						<button type="submit">Update</button>
					</form>
				</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>