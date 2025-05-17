<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Cafe Management System</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 20px;
	background-color: #f4f4f4;
}

.container {
	max-width: 800px;
	margin: 0 auto;
	text-align: center;
}

h1 {
	color: #2c3e50;
	margin-bottom: 20px;
}

.status {
	color: #27ae60;
	margin-bottom: 20px;
}

.nav-buttons {
	display: flex;
	justify-content: center;
	gap: 10px;
	flex-wrap: wrap;
}

.nav-buttons a {
	background-color: #3498db;
	color: white;
	padding: 10px 20px;
	text-decoration: none;
	border-radius: 5px;
}

.nav-buttons a:hover {
	background-color: #2980b9;
}

.qr-code {
	margin-top: 20px;
}
</style>
</head>
<body>
	<div class="container">
		<h1>Welcome to Cafe Management System</h1>
		<p class="status">
			Setup Spring MVC successful! Time:
			<%=new java.util.Date()%></p>
		<p class="status">JDBC Test: ${jdbcMessage}</p>
		<div class="nav-buttons">
			<a href="/CafeManagement/scanQr?qrCode=qr_table1">Scan QR Code
				(User)</a> <a href="/CafeManagement/admin">Admin Dashboard</a>
		</div>
		<div class="qr-code">
			<h2>Scan this QR Code to Order (Table 1)</h2>
			<img src="/CafeManagement/generateQr" alt="QR Code for Table 1">
		</div>
	</div>
</body>
</html>