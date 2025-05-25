<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Place Order</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .error { color: red; }
        .message { color: green; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        input[type="number"] { width: 60px; }
        button { padding: 5px 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Place Order for Table ${tableId}</h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:if test="${not empty message}">
            <p class="message">${message}</p>
        </c:if>
        <form action="submitOrder" method="post">
            <input type="hidden" name="tableId" value="${tableId}">
            <input type="hidden" name="qrCode" value="${qrCode}">
            <table>
                <tr><th>Item</th><th>Price</th><th>Quantity</th></tr>
                <c:forEach var="item" items="${menuItems}">
                    <tr>
                        <td>${item.itemName}</td>
                        <td>${item.price}</td>
                        <td><input type="number" name="items[${item.itemId}].quantity" value="0" min="0"></td>
                        <input type="hidden" name="items[${item.itemId}].itemId" value="${item.itemId}">
                        <input type="hidden" name="items[${item.itemId}].itemName" value="${item.itemName}">
                        <input type="hidden" name="items[${item.itemId}].price" value="${item.price}">
                    </tr>
                </c:forEach>
            </table>
            <div style="margin-top: 20px;">
                <label>Payment Method:</label>
                <select name="paymentMethod">
                    <option value="cash">Cash</option>
                    <option value="card">Card</option>
                </select>
                <label>Comments:</label>
                <input type="text" name="comments">
                <button type="submit">Submit Order</button>
            </div>
        </form>
    </div>
</body>
</html>