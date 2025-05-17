<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }
        .success { color: green; font-size: 24px; }
        .link { margin-top: 20px; }
    </style>
</head>
<body>
    <h1>Order Confirmation</h1>
    <p class="success">${message}</p>
    <div class="link">
        <a href="/CafeManagement/">Return to Home</a> | 
        <a href="/CafeManagement/admin">Go to Admin Dashboard</a>
    </div>
</body>
</html>