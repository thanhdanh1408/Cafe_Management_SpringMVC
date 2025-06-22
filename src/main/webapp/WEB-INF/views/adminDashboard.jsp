<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>Hệ thống Quản Lý DACK Cafe</title>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f0f2f5;
	margin: 0;
	padding: 20px;
}

.tab {
	overflow: hidden;
	border: 1px solid #ccc;
	background-color: #f1f1f1;
	border-radius: 5px 5px 0 0;
}

.tab button {
	background-color: inherit;
	float: left;
	border: none;
	outline: none;
	cursor: pointer;
	padding: 14px 16px;
	transition: 0.3s;
	font-size: 16px;
}

.tab button:hover {
	background-color: #ddd;
}

.tab button.active {
	background-color: #4CAF50;
	color: white;
}

.tabcontent {
	display: none;
	padding: 20px;
	border: 1px solid #ccc;
	border-top: none;
	background-color: #fff;
	border-radius: 0 0 5px 5px;
}

th, td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #4CAF50;
	color: white;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

tr:hover {
	background-color: #ddd;
}

.form-container {
	margin-bottom: 20px;
}

.empty-message {
	color: #888;
	font-style: italic;
}

.error-message {
	color: red;
	margin-bottom: 10px;
}

input[type="text"], select {
	padding: 5px;
	margin-right: 5px;
}

button {
	padding: 5px 10px;
	cursor: pointer;
}

.logout-btn {
	float: right;
	padding: 10px 20px;
	background-color: #ff4444;
	color: white;
	border: none;
	cursor: pointer;
}

.logout-btn:hover {
	background-color: #cc0000;
}

.chart-container {
	margin-top: 20px;
	width: 100%;
	height: 300px;
}

.edit-form {
	display: none;
	margin-top: 10px;
	padding: 10px;
	border: 1px solid #ccc;
	background-color: #f9f9f9;
}
</style>
<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    
    //JavaScript để tự động định dạng giá khi nhập
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
            priceInput.value = value;
            return true;
        } else {
            alert("Vui lòng nhập giá hợp lệ (số nguyên)!");
            priceInput.value = '';
            return false;
        }
    }
    
    function updateChart() {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const period = document.getElementById('periodFilter').value;
        const labels = ['Day', 'Week', 'Month', 'Year'];
        const data = {
            labels: labels,
            datasets: [{
                label: 'Revenue (VND)',
                data: [
                    parseFloat('${dailyRevenue}') || 0,
                    parseFloat('${weeklyRevenue}') || 0,
                    parseFloat('${monthlyRevenue}') || 0,
                    parseFloat('${yearlyRevenue}') || 0
                ],
                backgroundColor: 'rgba(76, 175, 80, 0.2)',
                borderColor: 'rgba(76, 175, 80, 1)',
                borderWidth: 1
            }]
        };
        if (window.revenueChart) {
            window.revenueChart.destroy();
        }
        window.revenueChart = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
    
    window.onload = function() {
        var activeTab = "${activeTab}";
        var tabToOpen = activeTab ? activeTab : "pendingOrders";
        document.querySelector("[onclick*='" + tabToOpen + "']").click();
    };
</script>
</head>
<body>
	<h1>
		Hệ thống Quản Lý DACK Cafe <a href="/CafeManagement/"><button
				class="logout-btn">Thoát</button></a>
	</h1>
	<div class="tab">
		<button class="tablinks" onclick="openTab(event, 'pendingOrders')">Chờ thanh toán món </button>
		<button class="tablinks" onclick="openTab(event, 'menuManagement')">Quản lý món </button>
		<button class="tablinks" onclick="openTab(event, 'tableManagement')">Quản lý bàn </button>
		<button class="tablinks" onclick="openTab(event, 'orderHistory')">Lịch sử đặt món </button>
		<button class="tablinks" onclick="openTab(event, 'revenueStatistics')">Thống kê </button>
	</div>

	<div id="pendingOrders" class="tabcontent">
		<h2>Đơn hàng</h2>
		<c:if test="${empty pendingOrders}">
			<p class="empty-message">Không có đơn hàng nào đang chờ xử lý.</p>
		</c:if>
		<c:if test="${not empty pendingOrders}">
			<table style="width: 100%">
				<tr>
					<th>STT </th>
					<th>Bàn </th>
					<th>Thời gian </th>
					<th>Phương thức thanh toán </th>
					<th>Thành tiền </th>
					<th>Ghi chú </th>
					<th>Trạng thái </th>
					<th>Món đã đặt </th>
					<th>Tuỳ chọn </th>
				</tr>
				<c:forEach var="order" items="${pendingOrders}" varStatus="loop">
					<tr>
						<td>${loop.count}</td>
						<td>${order.tableNumber}</td>
						<td><fmt:formatDate value="${order.orderTime}" pattern="dd-MM-yyyy HH:mm:ss" /></td>
						<td>
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'cash'}">Tiền mặt</c:when>
                            <c:when test="${order.paymentMethod == 'transfer'}">Chuyển khoản</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    	</td>
						<td><fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,###" /> VND</td>
						<td>${order.comments}</td>
						<td>
                        <c:choose>
                            <c:when test="${order.status == 'pending'}">Đang xử lý</c:when>
                            <c:when test="${order.status == 'preparing'}">Chuẩn bị</c:when>
                            <c:when test="${order.status == 'completed'}">Đã thanh toán</c:when>
                            <c:otherwise>${order.status}</c:otherwise>
                        </c:choose>
                    	</td>
						<td><c:choose>
								<c:when
									test="${empty order.details or order.details.size() == 0}">No items ordered
        						</c:when>
								<c:otherwise>
									<c:forEach var="detail" items="${order.details}"
										varStatus="loop">${detail.itemName} (x${detail.quantity})
										<c:if
											test="${!loop.last}">
											<br>
										</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose></td>
						<td>
							<a href="/CafeManagement/editPendingOrder?orderId=${order.orderId}"><button>Sửa</button></a>
							<form action="deleteOrder" method="post" style="display: inline;">
								<input type="hidden" name="orderId" value="${order.orderId}">
								<button type="submit">Xoá</button>
							</form>
							<form action="updateOrderStatus" method="post" style="display: inline;">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="status" value="completed">
                            <button type="submit">Hoàn Thành</button>
                        </form>
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>
	</div>

	<div id="menuManagement" class="tabcontent">
		<h2>Quản Lý Menu</h2>
		<a href="/CafeManagement/addMenuItem"><button>Thêm Món</button></a>
		<table style="width: 100%">
			<tr>
				<th>STT</th>
				<th>Tên món</th>
				<th>Giá</th>
				<th>Trạng thái</th>
				<th>Tuỳ chọn</th>
			</tr>
			<c:forEach var="item" items="${menuItems}" varStatus="loop">
				<tr>
					<td>${loop.count}</td>
					<td>${item.itemName}</td>
					<td><fmt:formatNumber value="${item.price}" type="number" pattern="#,###" /> VND</td>
					<td>
                        <c:choose>
                            <c:when test="${item.status == 'available'}">Có sẵn</c:when>
                            <c:when test="${item.status == 'unavailable'}">Không có sẵn</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    	</td>
					<td>
						<a href="/CafeManagement/editMenuItem?itemId=${item.itemId}"><button>Sửa</button></a>
						<form action="deleteMenuItem" method="post"
							style="display: inline;">
							<input type="hidden" name="itemId" value="${item.itemId}">
							<button type="submit">Xoá</button>
						</form>
						<div id="editForm-${item.itemId}" class="edit-form">
							<form action="updateMenuItem" method="post">
								<input type="hidden" name="itemId" value="${item.itemId}">
								<label>Tên món:</label> <input type="text" name="itemName"
									value="${item.itemName}" required> <label>Giá:</label>
								<input type="number" name="price" step="0.01"
									value="${item.price}" required> <label>Trạng thái:</label>
								<select name="status">
									<option value="available"
										${item.status == 'available' ? 'selected' : ''}>Có sẵn</option>
									<option value="unavailable"
										${item.status == 'unavailable' ? 'selected' : ''}>Không có sẵn</option>
								</select>
								<button type="submit">Save</button>
							</form>
						</div>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>

	<div id="tableManagement" class="tabcontent">
		<h2>Quản Lý Bàn</h2>
		<c:if test="${not empty error}">
			<p class="error-message">${error}</p>
		</c:if>
		<div class="form-container">
			<h3>Thêm bàn mới</h3>
			<form action="createTable" method="post">
				<input type="text" name="tableNumber" placeholder="Bàn số"
					required>
				<button type="submit">Thêm</button>
			</form>
		</div>
		<table style="width: 100%">
			<tr>
				<th>STT</th>
				<th>Bàn số</th>
				<th>Mã QR</th>
				<th>Trạng thái</th>
				<th>Tuỳ chọn</th>
			</tr>
			<c:forEach var="table" items="${tables}" varStatus="loop">
				<tr>
					<td>${loop.count}</td>
					<td>${table.tableNumber}</td>
					<td><img
						src="/CafeManagement/generateQr?qrCode=${table.qrCode}"
						alt="QR Code for ${table.tableNumber}"></td>
					<td>
                        <c:choose>
                            <c:when test="${table.status == 'available'}">Có sẵn</c:when>
                            <c:when test="${table.status == 'occupied'}">Không có sẵn</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    	</td>
					<td>
						<form action="deleteTable" method="post" style="display: inline;">
							<input type="hidden" name="tableId" value="${table.tableId}">
							<button type="submit">Xoá bàn</button>
						</form>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>

	<div id="orderHistory" class="tabcontent">
		<h2>Lịch Sử Đặt Món</h2>
		<c:if test="${empty orderHistory}">
			<p class="empty-message">Không có lịch sử đặt món.</p>
		</c:if>
		<c:if test="${not empty orderHistory}">
			<table style="width: 100%">
				<tr>
					<th>STT</th>
					<th>Bàn</th>
					<th>Thời gian</th>
					<th>Phương thức thanh toán</th>
					<th>Thành tiền</th>
					<th>Ghi chú</th>
					<th>Trạng thái</th>
					<th>Món đã đặt</th>
					<th>Tuỳ chọn</th>
				</tr>
				<c:forEach var="order" items="${orderHistory}" varStatus="loop">
					<tr>
						<td>${loop.count}</td>
						<td>${order.tableNumber}</td>	
						<td><fmt:formatDate value="${order.orderTime}" pattern="dd-MM-yyyy HH:mm:ss" /></td>
						<td>
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'cash'}">Tiền mặt</c:when>
                            <c:when test="${order.paymentMethod == 'transfer'}">Chuyển khoản</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    	</td>
						<td><fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,###" /> VND</td>
						<td>${order.comments}</td>
						<td>
                        <c:choose>
                            <c:when test="${order.status == 'pending'}">Đang xử lý</c:when>
                            <c:when test="${order.status == 'preparing'}">Chuẩn bị</c:when>
                            <c:when test="${order.status == 'completed'}">Đã thanh toán</c:when>
                            <c:otherwise>${order.status}</c:otherwise>
                        </c:choose>
                    	</td>
						<td><c:choose>
								<c:when
									test="${empty order.details or order.details.size() == 0}">No items ordered
        						</c:when>
        						
								<c:otherwise>
									<c:forEach var="detail" items="${order.details}"
										varStatus="loop">${detail.itemName} (x${detail.quantity})
										<c:if
											test="${!loop.last}">
											<br>
										</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose></td>
						<td>
							<form action="deleteOrderHistory" method="post"
								style="display: inline;">
								<input type="hidden" name="orderId" value="${order.orderId}">
								<button type="submit">Xóa</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>
	</div>


	<div id="revenueStatistics" class="tabcontent">
		<h2>Thống Kê</h2>
		<table style="width: 100%">
			<tr>
				<th>Chu Kỳ</th>
				<th>Doanh thu (VND)</th>
			</tr>
			<tr>
            <tr>
            <td>Hôm nay</td>
            <td><fmt:formatNumber value="${dailyRevenue}" type="number" pattern="#,###" /> VND</td>
        </tr>
        <tr>
            <td>Tuần này</td>
            <td><fmt:formatNumber value="${weeklyRevenue}" type="number" pattern="#,###" /> VND</td>
        </tr>
        <tr>
            <td>Tháng này</td>
            <td><fmt:formatNumber value="${monthlyRevenue}" type="number" pattern="#,###" /> VND</td>
        </tr>
        <tr>
            <td>Năm nay</td>
            <td><fmt:formatNumber value="${yearlyRevenue}" type="number" pattern="#,###" /> VND</td>
        </tr>
		</table>
		
		<h3>Số Lượng Món Đã Đặt (Hôm nay)</h3>
        <c:if test="${empty dailyItemOrderCounts or dailyItemOrderCounts.size() == 0}">
            <p class="empty-message">Không có có món nào được đặt hôm nay.</p>
        </c:if>
        <c:if test="${not empty dailyItemOrderCounts and dailyItemOrderCounts.size() > 0}">
            <table style="width: 100%; margin-top: 20px;">
                <tr>
                    <th>Tên món</th>
                    <th>Số Lượng Đã đặt</th>
                </tr>
                <c:forEach var="entry" items="${dailyItemOrderCounts}">
                    <tr>
                        <td>${entry.key}</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
</div>
</body>
</html>