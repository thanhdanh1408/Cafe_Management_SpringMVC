package com.example.cafemanhdu.servlet;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/generateQr")
public class QrCodeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String qrCode = request.getParameter("qrCode");
        if (qrCode == null || qrCode.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "QR Code parameter is missing");
            return;
        }

        String qrCodeText = " https://8723-2405-4802-717c-4360-d823-4dc4-964c-8b3e.ngrok-free.app/CafeManagement/scanQr?qrCode=" + qrCode;
        int size = 150; // Kích thước
        response.setContentType("image/png");
        OutputStream outputStream = response.getOutputStream();

        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(qrCodeText, BarcodeFormat.QR_CODE, size, size);
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);
        } catch (WriterException e) {
            throw new ServletException("Error generating QR code", e);
        } finally {
            outputStream.close();
        }
    }
}