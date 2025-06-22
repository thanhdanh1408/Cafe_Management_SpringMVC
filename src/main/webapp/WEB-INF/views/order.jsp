<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt món - Cafe</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f4ef;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 540px;
            margin: 44px auto 0 auto;
            background: #faeee0;
            padding: 34px 26px 26px 26px;
            border-radius: 20px;
            box-shadow: 0 6px 36px 0 rgba(180,146,108,0.13);
            border: 1.5px solid #e6dbc8;
            animation: fadeIn 0.7s cubic-bezier(.43,.03,.62,.88);
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(32px) scale(0.96);}
            80% { opacity: 0.88;}
            100% { opacity: 1; transform: none;}
        }
        h2 {
            color: #b4926c;
            text-align: center;
            font-size: 1.5rem;
            letter-spacing: 0.5px;
            margin-bottom: 22px;
        }
        .error {
            color: #c86e48;
            background: #ffe5e0;
            border-radius: 7px;
            padding: 9px 0;
            font-weight: 600;
            text-align: center;
        }
        .message {
            color: #49705a;
            background: #e0ffe6;
            border-radius: 7px;
            padding: 9px 0;
            font-weight: 600;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 9px;
            margin-top: 10px;
        }
        th, td {
            padding: 13px 9px;
            text-align: left;
        }
        th {
            background: #d2b48c;
            color: #fff;
            font-size: 1.01rem;
            border-radius: 11px 11px 0 0;
            letter-spacing: 0.4px;
            border-bottom: 1.5px solid #e6dbc8;
            text-align: center;
        }
        tr {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px 0 rgba(191,160,116,0.06);
            transition: box-shadow 0.14s;
        }
        tr:nth-child(even) {
            background: #faeee0;
        }
        tr:hover {
            box-shadow: 0 6px 14px 0 rgba(191,160,116,0.12);
            background: #ede0ca;
        }
        .quantity-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
        }
        .quantity-btn {
            width: 33px;
            height: 33px;
            background: #d2b48c;
            color: #fff;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.22rem;
            font-weight: bold;
            transition: background 0.17s, transform 0.13s;
            box-shadow: 0 2px 8px 0 rgba(191,160,116,0.07);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .quantity-btn:hover {
            background: #b4926c;
            transform: scale(1.09);
        }
        .quantity-input {
            width: 46px;
            padding: 7px 0;
            text-align: center;
            border: 1.5px solid #d2b48c;
            border-radius: 7px;
            background: #fff;
            font-size: 1.04rem;
            color: #7d5a3a;
            font-weight: 600;
        }
        select, input[type="text"] {
            padding: 10px 8px;
            margin-right: 8px;
            border: 1.5px solid #d2b48c;
            border-radius: 7px;
            font-size: 1rem;
            background: #fff;
            color: #7d5a3a;
            transition: border 0.13s;
        }
        select:focus, input[type="text"]:focus {
            border-color: #b4926c;
            outline: none;
        }
        .action-row {
            margin-top: 23px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
        }
        label {
            color: #7d5a3a;
            font-weight: 500;
            margin-right: 6px;
        }
        button[type="submit"] {
            padding: 12px 32px;
            background: #d2b48c;
            color: #fff;
            border: none;
            border-radius: 9px;
            font-size: 1.09rem;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 1px 4px 0 rgba(180,146,108,0.09);
            transition: background 0.15s, transform 0.12s;
        }
        button[type="submit"]:hover {
            background: #b4926c;
            transform: scale(1.04) translateY(-2px);
        }
        /* Responsive: lấp đầy màn hình điện thoại */
        @media (max-width: 700px) {
            .container { 
                width: 100vw;
                max-width: 100vw;
                min-width: 0;
                padding: 2vw 1vw 5vw 1vw;
                border-radius: 0;
                margin: 0;
                box-shadow: none;
            }
            table, th, td { 
                font-size: 1rem;
                padding-left: 3px;
                padding-right: 3px;
            }
            th, td { padding: 9px 2px;}
            .quantity-input { width: 32px; padding: 6px 0;}
        }
        @media (max-width: 500px) {
            h2 { font-size: 1.12rem;}
            .container { padding: 2vw 0.5vw 4vw 0.5vw;}
            .action-row { flex-direction: column; align-items: stretch;}
            select, input[type="text"] { width: 98%; margin: 7px 0;}
            button[type="submit"] { width: 100%; }
        }
    </style>
    <script>
        function updateQuantity(itemId, change) {
            var input = document.querySelector('input[name="items[' + itemId + '].quantity"]');
            var currentValue = parseInt(input.value) || 0;
            var newValue = currentValue + change;
            if (newValue >= 0 && newValue <= 10) {
                input.value = newValue;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Đặt món cho Bàn ${tableId}</h2>
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
                    <th>Món</th>
                    <th>Giá (VND)</th>
                    <th>Số lượng</th>
                </tr>
                <c:forEach var="item" items="${menuItems}">
                    <tr>
                        <td>${item.itemName}</td>
                        <td><fmt:formatNumber value="${item.price}" type="number" pattern="#,###" /> VND</td>
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
            <div class="action-row">
                <div>
                    <label>Phương thức thanh toán: </label>
                    <select name="paymentMethod">
                        <option value="cash">Tiền mặt</option>
                        <option value="transfer">Chuyển khoản</option>
                    </select>
                </div>
                <div>
                    <label>Ghi chú:</label>
                    <input type="text" name="comments" placeholder="Thêm yêu cầu cho quán...">
                </div>
                <button type="submit">Xác nhận đặt món</button>
            </div>
        </form>
    </div>
</body>
</html>
