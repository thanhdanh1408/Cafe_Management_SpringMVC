<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>Edit Menu Item</title>
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

input[type="text"], input[type="number"] {
	padding: 5px;
	width: 200px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

select {
	padding: 5px;
	width: 210px;
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
   <script>
        function formatPrice(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            if (value) {
                let number = parseInt(value);
                if (!isNaN(number)) {
                    input.value = number.toLocaleString('vi-VN');
                } else {
                    input.value = '';
                }
            } else {
                input.value = '';
            }
        }

        function formatPriceBeforeSubmit() {
            let priceInput = document.getElementById('priceInput');
            let value = priceInput.value.replace(/[^0-9]/g, '');
            if (value && !isNaN(parseInt(value))) {
                priceInput.value = value; // Gửi giá trị số nguyên (VD: 20000)
                return true;
            } else {
                alert("Vui lòng nhập giá hợp lệ (số nguyên)!");
                priceInput.value = '';
                return false;
            }
        }
    </script>
<body>
	<div class="container">
		<h2>Sửa món</h2>
		<c:if test="${not empty error}">
			<p style="color: red;">${error}</p>
		</c:if>
		<form action="/CafeManagement/updateMenuItem" method="post">
			<input type="hidden" name="itemId" value="${item.itemId}">
			<div class="form-group">
				<label>Tên món:</label> 
				<input type="text" name="itemName" value="${item.itemName}" required>
			</div>
			<div class="form-group">
				<label>Giá:</label> 
				<input type="text" id="priceInput" name="price" value="<fmt:formatNumber value='${item.price}' type='number' pattern='#,###' />" required oninput="formatPrice(this)">
			</div>
			<div class="form-group">
				<label>Trạng thái:</label> 
				<select name="status">
					<option value="available" ${item.status == 'available' ? 'selected' : ''}>Có sẵn</option>
					<option value="unavailable" ${item.status == 'unavailable' ? 'selected' : ''}>Không có sẵn</option>
				</select>
			</div>
			<button type="submit">Lưu</button>
			<a href="/CafeManagement/admin?tab=menuManagement">
			<button type="button">Hủy</button></a>
		</form>
	</div>
</body>
</html>