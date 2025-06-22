<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
<title>Thêm món</title>
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
<div class="container">
    <h3>Thêm món mới</h3>
    <form id="addMenuItemForm" action="createMenuItem" method="post" onsubmit="return validateForm()">
        <div class="form-group">
			<label>Tên món:</label> 
			<input type="text" name="itemName" placeholder="Tên món" required>
		</div>
		<div class="form-group">
		    <label>Giá:</label>
        	<input type="number" id="priceInput" name="price" placeholder="Giá (Nhập số từ 0 - 100)" required min="0" max="100000" oninput="validatePrice(this)">        	
        </div>
        <div class="form-group">
        	<label>Trạng thái:</label>
        	<select name="status" required>
            	<option value="available">Có sẵn</option>
            	<option value="unavailable">Không có sẵn</option>
        	</select>
        </div>
        <button type="submit">Thêm</button>
    </form>
    <p id="errorMessage" style="color: red; display: none;"></p>
</div>

<script>
    function validatePrice(input) {
        const value = input.value;
        const errorMessage = document.getElementById("errorMessage");
        const maxPrice = 100000;

        // Kiểm tra nếu giá là rỗng hoặc không phải số
        if (!/^\d*$/.test(value)) {
            errorMessage.textContent = "Giá chỉ được nhập số!";
            errorMessage.style.display = "block";
            input.value = value.replace(/[^0-9]/g, ''); // Loại bỏ ký tự không phải số
            return false;
        }

        // Chuyển đổi thành số để kiểm tra giới hạn
        const numValue = parseInt(value) || 0;
        if (numValue > maxPrice) {
            errorMessage.textContent = `Giá không được vượt quá ${maxPrice} VND!`;
            errorMessage.style.display = "block";
            input.value = maxPrice; // Giới hạn tối đa
        } else if (numValue < 0) {
            errorMessage.textContent = "Giá phải lớn hơn hoặc bằng 0!";
            errorMessage.style.display = "block";
            input.value = 0; // Giới hạn tối thiểu
        } else {
            errorMessage.style.display = "none";
        }
        return true;
    }

    function validateForm() {
        const priceInput = document.getElementById("priceInput");
        const value = priceInput.value;
        const errorMessage = document.getElementById("errorMessage");
        const maxPrice = 100000;

        // Kiểm tra trước khi gửi form
        if (!/^\d+$/.test(value)) {
            errorMessage.textContent = "Giá chỉ được nhập số!";
            errorMessage.style.display = "block";
            return false;
        }

        const numValue = parseInt(value);
        if (numValue > maxPrice) {
            errorMessage.textContent = `Giá không được vượt quá ${maxPrice} VND!`;
            errorMessage.style.display = "block";
            return false;
        } else if (numValue < 0) {
            errorMessage.textContent = "Giá phải lớn hơn hoặc bằng 0!";
            errorMessage.style.display = "block";
            return false;
        }

        errorMessage.style.display = "none";
        return true;
    }
</script>