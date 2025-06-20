<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Place Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        .message {
            color: green;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .quantity-controls {
            display: flex;
            align-items: center;
        }
        .quantity-btn {
            width: 30px;
            height: 30px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 0 5px;
        }
        .quantity-btn:hover {
            background-color: #45a049;
        }
        .quantity-input {
            width: 50px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        select, input[type="text"] {
            padding: 5px;
            margin-right: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button[type="submit"] {
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function updateQuantity(itemId, change) {
            var input = document.querySelector('input[name="items[' + itemId + '].quantity"]');
            var currentValue = parseInt(input.value) || 0;
            var newValue = currentValue + change;

            // Giới hạn từ 0 đến 10
            if (newValue >= 0 && newValue <= 10) {
                input.value = newValue;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Đặt món Bàn ${tableId}</h2>
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
                <tr>
                    <th>Item</th>
                    <th>Price</th>
                    <th>Quantity</th>
                </tr>
                <c:forEach var="item" items="${menuItems}">
                    <tr>
                        <td>${item.itemName}</td>
                        <td>${item.price}</td>
                        <td class="quantity-controls">
                            <button type="button" class="quantity-btn" onclick="updateQuantity(${item.itemId}, -1)">-</button>
                            <input type="text" class="quantity-input" name="items[${item.itemId}].quantity" value="0" readonly>
                            <button type="button" class="quantity-btn" onclick="updateQuantity(${item.itemId}, 1)">+</button>
                            <input type="hidden" name="items[${item.itemId}].itemId" value="${item.itemId}">
                            <input type="hidden" name="items[${item.itemId}].itemName" value="${item.itemName}">
                            <input type="hidden" name="items[${item.itemId}].price" value="${item.price}">
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <div style="margin-top: 20px;">
                <label>Phương thức thanh toán: </label>
                <select name="paymentMethod">
                    <option value="cash">Tiền mặt</option>
                    <option value="transfer">Chuyển Khoản</option>
                </select>
                <label>Ghi chú:</label>
                <input type="text" name="comments">
                <button type="submit">Xác nhận đặt món</button>
            </div>
        </form>
    </div>
</body>
</html>