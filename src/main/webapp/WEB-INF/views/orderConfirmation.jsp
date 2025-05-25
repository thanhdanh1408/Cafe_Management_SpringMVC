<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        .message { color: green; font-size: 18px; }
        button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Order Confirmation</h2>
        <p class="message">Order thành công, quý khách chờ trong ít phút...</p>
        <a href="/CafeManagement/scanQr?qrCode=${qrCode}">
            <button>Quay lại trang Order</button>
        </a>
    </div>
</body>
</html>