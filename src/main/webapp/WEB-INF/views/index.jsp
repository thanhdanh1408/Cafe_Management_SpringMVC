<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập Admin - Cafe Management</title>
    <meta charset="UTF-8">
    <style>
        body {
            background: #f7f4ef;
            font-family: 'Segoe UI', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-box {
            background: #faeee0;
            padding: 40px 32px 32px 32px;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(180,146,108,0.16);
            width: 350px;
            animation: fadeIn 0.8s ease;
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(32px) scale(0.97);}
            80% { opacity: 0.8; }
            100% { opacity: 1; transform: none;}
        }
        h2 {
            color: #b4926c;
            margin-bottom: 28px;
            text-align: center;
            font-family: 'Segoe UI', Arial, sans-serif;
            letter-spacing: 0.5px;
            font-size: 1.4rem;
        }
        .error-message {
            color: #ff5722;
            text-align: center;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }
        form {
            margin-bottom: 10px;
        }
        label {
            color: #7d5a3a;
            font-weight: 500;
        }
        input[type="text"], input[type="password"] {
            width: 93%;
            padding: 10px 12px;
            margin-top: 6px;
            margin-bottom: 17px;
            border: 1.5px solid #d2b48c;
            border-radius: 7px;
            font-size: 1rem;
            color: #7d5a3a;
            background: #fff;
            transition: border 0.13s;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #b4926c;
            outline: none;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #d2b48c;
            border: none;
            color: #fff;
            border-radius: 8px;
            font-size: 1.05rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.16s, transform 0.13s;
            margin-top: 10px;
            box-shadow: 0 1px 4px 0 rgba(180,146,108,0.09);
        }
        button:hover {
            background: #b4926c;
            transform: translateY(-2px) scale(1.03);
        }
        @media (max-width: 600px) {
            .login-box {
                width: 96vw;
                padding: 26px 5vw 22px 5vw;
            }
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Đăng nhập Admin</h2>
        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty param.error}">
            <div class="error-message">${param.error}</div>
        </c:if>
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