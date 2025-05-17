<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Order Menu</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	padding: 10px;
	border: 1px solid #ddd;
}

th {
	background-color: #f2f2f2;
}

.error {
	color: red;
}
</style>
</head>
<body>
	<h1>Order Menu - Table ${tableId}</h1>
	<c:if test="${not empty error}">
		<p class="error">${error}</p>
	</c:if>
	<form action="submitOrder" method="post">
		<input type="hidden" name="tableId" value="${tableId}">
		<table>
			<tr>
				<th>Item Name</th>
				<th>Price</th>
				<th>Quantity</th>
			</tr>
			<c:forEach var="item" items="${menuItems}" varStatus="loop">
				<tr>
					<td>${item.itemName}</td>
					<td>${item.price}</td>
					<td><input type="number" name="items[${loop.index}].quantity"
						value="0" min="0"> <input type="hidden"
						name="items[${loop.index}].itemId" value="${item.itemId}">
						<input type="hidden" name="items[${loop.index}].itemName"
						value="${item.itemName}"> <input type="hidden"
						name="items[${loop.index}].price" value="${item.price}"></td>
				</tr>
			</c:forEach>
		</table>
		<p>
			Comments:
			<textarea name="comments"></textarea>
		</p>
		<p>
			Payment Method: <select name="paymentMethod">
				<option value="cash">Cash</option>
				<option value="transfer">Transfer</option>
			</select>
		</p>
		<button type="submit">Submit Order</button>
	</form>
</body>
</html>