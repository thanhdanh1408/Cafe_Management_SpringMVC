<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sửa thông tin đơn hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f7f4ef;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 520px;
            margin: 36px auto;
            background-color: #faeee0;
            padding: 32px 30px 24px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 24px 0 rgba(180,146,108,0.08);
            border: 1.5px solid #e6dbc8;
        }
        h2 {
            color: #b4926c;
            text-align: center;
            margin-bottom: 30px;
            font-size: 1.5rem;
            letter-spacing: 0.5px;
        }
        .form-group {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        label {
            flex: 0 0 150px;
            color: #7d5a3a;
            font-weight: 500;
        }
        select, input[type="text"] {
            flex: 1;
            padding: 10px 8px;
            border: 1.5px solid #d2b48c;
            border-radius: 7px;
            font-size: 1rem;
            background: #fff;
            color: #7d5a3a;
            margin-left: 6px;
            transition: border 0.15s;
        }
        select:focus, input[type="text"]:focus {
            border-color: #b4926c;
            outline: none;
        }
        button {
            padding: 10px 28px;
            background: #d2b48c;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-right: 14px;
            transition: background 0.14s;
            box-shadow: 0 1px 4px 0 rgba(180,146,108,0.09);
        }
        button:hover {
            background: #b4926c;
        }
        a {
            text-decoration: none;
        }
        p[style*="color: red"] {
            margin-bottom: 16px;
            font-weight: 500;
            color: #c86e48 !important;
            text-align: center;
        }
        @media (max-width: 600px) {
            .container { padding: 18px 5vw; }
            .form-group { flex-direction: column; align-items: stretch; }
            label { margin-bottom: 5px; margin-left: 0; }
            button { width: 100%; margin-bottom: 10px; }
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
