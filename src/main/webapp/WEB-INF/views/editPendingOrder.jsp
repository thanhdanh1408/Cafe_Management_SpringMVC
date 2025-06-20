<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa thông tin đơn hàng</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: inline-block;
            width: 120px;
        }
        select, input[type="text"] {
            padding: 5px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Sửa thông tin đơn hàng</h2>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <form action="/CafeManagement/updatePendingOrder" method="post">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <div class="form-group">
                <label>Phương thức thanh toán:</label>
                <select name="paymentMethod">
                    <option value="cash" ${order.paymentMethod == 'cash' ? 'selected' : ''}>Tiền mặt</option>
                    <option value="transfer" ${order.paymentMethod == 'transfer' ? 'selected' : ''}>Chuyển khoản</option>
                </select>
            </div>
            <div class="form-group">
                <label>Ghi chú:</label>
                <input type="text" name="comments" value="${order.comments}">
            </div>
            <button type="submit">Lưu</button>
            <a href="/CafeManagement/admin?tab=pendingOrders"><button type="button">Hủy</button></a>
        </form>
    </div>
</body>
</html>