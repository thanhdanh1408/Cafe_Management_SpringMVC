<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Xác nhận đặt món - Cafe</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f4ef;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 440px;
            margin: 48px auto 0 auto;
            background: #faeee0;
            padding: 36px 30px 30px 30px;
            border-radius: 18px;
            box-shadow: 0 6px 36px 0 rgba(180,146,108,0.11);
            border: 1.5px solid #e6dbc8;
            text-align: center;
            animation: fadeIn 0.7s cubic-bezier(.43,.03,.62,.88);
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(30px) scale(0.98);}
            80% { opacity: 0.85;}
            100% { opacity: 1; transform: none;}
        }
        h2 {
            color: #b4926c;
            margin-bottom: 23px;
            font-size: 1.35rem;
            letter-spacing: 0.5px;
        }
        .message {
            color: #49705a;
            background: #e0ffe6;
            font-size: 1.15rem;
            border-radius: 8px;
            padding: 15px 7px;
            margin-bottom: 26px;
            font-weight: 600;
            box-shadow: 0 2px 10px 0 rgba(191,160,116,0.06);
        }
        button {
            padding: 12px 30px;
            background: #d2b48c;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1.07rem;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 1px 4px 0 rgba(180,146,108,0.09);
            transition: background 0.16s, transform 0.12s;
        }
        button:hover {
            background: #b4926c;
            transform: scale(1.04) translateY(-1.5px);
        }
        @media (max-width: 700px) {
            .container {
                width: 100vw;
                max-width: 100vw;
                min-width: 0;
                padding: 7vw 2vw 5vw 2vw;
                border-radius: 0;
                margin: 0;
                box-shadow: none;
            }
            h2 { font-size: 1.13rem;}
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Thông tin đặt món</h2>
        <p class="message">Đặt món thành công! Cảm ơn quý khách, xin vui lòng chờ phục vụ trong ít phút...</p>
        <a href="/CafeManagement/scanQr?qrCode=${qrCode}">
            <button>Quay lại trang đặt món</button>
        </a>
    </div>
</body>
</html>
