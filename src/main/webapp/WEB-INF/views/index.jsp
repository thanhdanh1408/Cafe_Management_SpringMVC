<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập Admin - Cafe Management</title>
    <meta charset="UTF-8">
    <style>
        body {
            background: #f9f6f2;
            font-family: 'Segoe UI', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            background: #fff8f0;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(97, 65, 40, 0.16);
            width: 350px;
        }
        h2 {
            color: #6d4c41;
            margin-bottom: 24px;
            text-align: center;
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        form {
            margin-bottom: 10px;
        }
        label {
            color: #4e342e;
            font-weight: 500;
        }
        input[type="text"], input[type="password"] {
            width: 93%;
            padding: 10px 12px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #d7ccc8;
            border-radius: 6px;
            font-size: 1rem;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #a1887f;
            border: none;
            color: #fff;
            border-radius: 8px;
            font-size: 1.05rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        button:hover {
            background: #6d4c41;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Đăng nhập Admin</h2>
        <form action="login" method="post">
            <label for="username">Tài khoản:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit" name="role" value="admin">Đăng nhập</button>
        </form>
    </div>
</body>
</html>
