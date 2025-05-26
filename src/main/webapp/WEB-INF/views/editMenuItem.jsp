<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Menu Item</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .error-message {
            color: #d32f2f;
            text-align: center;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus,
        .form-group select:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
        }
        .button-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        button[type="submit"] {
            background-color: #4CAF50;
            color: white;
        }
        button[type="submit"]:hover {
            background-color: #45a049;
        }
        button[type="button"] {
            background-color: #f44336;
            color: white;
        }
        button[type="button"]:hover {
            background-color: #e53935;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Edit Menu Item</h2>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
        <form action="updateMenuItem" method="post">
            <input type="hidden" name="itemId" value="${item.itemId}">
            <div class="form-group">
                <label for="itemName">Item Name:</label>
                <input type="text" id="itemName" name="itemName" value="${item.itemName}" required>
            </div>
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" step="0.01" value="${item.price}" required>
            </div>
            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status">
                    <option value="available" ${item.status == 'available' ? 'selected' : ''}>Available</option>
                    <option value="unavailable" ${item.status == 'unavailable' ? 'selected' : ''}>Unavailable</option>
                </select>
            </div>
            <div class="button-group">
                <button type="submit">Save Changes</button>
                <a href="${pageContext.request.contextPath}/admin?activeTab=menuManagement">
                    <button type="button">Cancel</button>
                </a>
            </div>
        </form>
    </div>
</body>
</html>