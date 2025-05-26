<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-style.css">
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