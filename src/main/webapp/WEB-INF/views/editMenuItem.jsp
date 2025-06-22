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
    flex: 0 0 120px;
    color: #7d5a3a;
    font-weight: 500;
}
input[type="text"], input[type="number"], select {
    flex: 1;
    padding: 10px 8px;
    border: 1.5px solid #d2b48c;
    border-radius: 7px;
    font-size: 1rem;
    background: #fff;
    color: #7d5a3a;
    transition: border 0.15s;
    margin-left: 6px;
}
input[type="text"]:focus, input[type="number"]:focus, select:focus {
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
<script>
    function validatePrice(input) {
        let value = input.value.replace(/[^0-9]/g, '');
        if (value) {
            let number = parseInt(value);
            if (!isNaN(number)) {
                input.value = number; // Chỉ giữ số nguyên
            } else {
                input.value = '';
            }
        }
    }

    function validateForm() {
        let priceInput = document.getElementById('priceInput');
        let value = priceInput.value;
        const maxPrice = 100000;

        if (!/^\d+$/.test(value)) {
            alert("Vui lòng nhập giá hợp lệ (số nguyên)!");
            priceInput.value = '';
            return false;
        }

        const numValue = parseInt(value);
        if (numValue > maxPrice) {
            alert(`Giá không được vượt quá ${maxPrice} VND!`);
            priceInput.value = maxPrice;
            return false;
        } else if (numValue < 0) {
            alert("Giá phải lớn hơn hoặc bằng 0!");
            priceInput.value = 0;
            return false;
        }
        return true;
    }
</script>
</head>
<body>
    <div class="container">
        <h2>Sửa món</h2>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <form action="/CafeManagement/updateMenuItem" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="itemId" value="${item.itemId}">
            <div class="form-group">
                <label>Tên món:</label> 
                <input type="text" name="itemName" value="${item.itemName}" required>
            </div>
            <div class="form-group">
                <label>Giá (VND):</label> 
                <input type="number" id="priceInput" name="price" value="${item.price}" required min="0" max="100000" oninput="validatePrice(this)" step="1000">
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
                <button type="button">Hủy</button>
            </a>
        </form>
    </div>
</body>
</html>
