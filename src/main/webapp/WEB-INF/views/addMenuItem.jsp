<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
<title>Thêm món</title>
<style>
body {
	font-family: 'Segoe UI', Arial, sans-serif;
	background: linear-gradient(120deg, #ffe9c6 0%, #fff7eb 100%);
	margin: 0;
	padding: 0;
	min-height: 100vh;
}

.container {
	max-width: 420px;
	margin: 60px auto;
	background: #fff8f0;
	padding: 36px 32px 30px 32px;
	border-radius: 16px;
	box-shadow: 0 8px 36px 0 rgba(97, 65, 40, 0.18);
}

h3 {
	color: #795548;
	margin-bottom: 28px;
	font-size: 1.5rem;
	text-align: center;
	letter-spacing: 0.5px;
	font-weight: bold;
}

.form-group {
	margin-bottom: 22px;
}

label {
	color: #5d4037;
	font-size: 1.07rem;
	font-weight: 600;
	display: block;
	margin-bottom: 7px;
}

input[type="text"], input[type="number"], select {
	width: 100%;
	padding: 11px 12px;
	font-size: 1.08rem;
	border: 1.5px solid #d7ccc8;
	border-radius: 7px;
	background: #fff;
	transition: border 0.15s;
	outline: none;
	box-sizing: border-box;
}
input[type="text"]:focus, input[type="number"]:focus, select:focus {
	border-color: #bcaaa4;
}

button {
	width: 100%;
	padding: 13px;
	background: linear-gradient(90deg, #ffb77c 0%, #ad7745 100%);
	color: #fff;
	border: none;
	border-radius: 9px;
	font-size: 1.13rem;
	font-weight: bold;
	cursor: pointer;
	letter-spacing: 1px;
	box-shadow: 0 2px 8px 0 rgba(97,65,40,0.08);
	transition: background 0.15s, transform 0.13s;
	margin-top: 12px;
}
button:hover {
	background: linear-gradient(90deg, #ad7745 0%, #ffb77c 100%);
	transform: translateY(-2px) scale(1.03);
}

#errorMessage {
	margin-top: 10px;
	font-weight: 500;
	letter-spacing: 0.5px;
}

@media (max-width: 540px) {
	.container {
		padding: 20px 6vw;
	}
}
</style>
</head>
<body>
<div class="container">
    <h3>Thêm món mới</h3>
    <form id="addMenuItemForm" action="createMenuItem" method="post" onsubmit="return validateForm()">
        <div class="form-group">
			<label>Tên món:</label> 
			<input type="text" name="itemName" placeholder="Tên món" required>
		</div>
		<div class="form-group">
		    <label>Giá:</label>
        	<input type="number" id="priceInput" name="price" placeholder="Nhập giá (0 - 100,000)" required min="0" max="100000" oninput="validatePrice(this)" step="1000">        	
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
    <p id="errorMessage" style="color: #ff5722; display: none;"></p>
</div>

<script>
    function validatePrice(input) {
        const value = input.value;
        const errorMessage = document.getElementById("errorMessage");
        const maxPrice = 100000;

        if (!/^\d*$/.test(value)) {
            errorMessage.textContent = "Giá chỉ được nhập số!";
            errorMessage.style.display = "block";
            input.value = value.replace(/[^0-9]/g, '');
            return false;
        }

        const numValue = parseInt(value) || 0;
        if (numValue > maxPrice) {
            errorMessage.textContent = `Giá không được vượt quá ${maxPrice} VND!`;
            errorMessage.style.display = "block";
            input.value = maxPrice;
        } else if (numValue < 0) {
            errorMessage.textContent = "Giá phải lớn hơn hoặc bằng 0!";
            errorMessage.style.display = "block";
            input.value = 0;
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
</body>
