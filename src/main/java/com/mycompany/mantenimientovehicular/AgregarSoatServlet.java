package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@MultipartConfig
@WebServlet("/AgregarSoatServlet")
public class AgregarSoatServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String fechaPagoStr = request.getParameter("FechaPagoSOAT");
        String montoPagoStr = request.getParameter("MontoPagoSOAT");
        if (placa == null || placa.trim().isEmpty() ||
            fechaPagoStr == null || fechaPagoStr.trim().isEmpty() ||
            montoPagoStr == null || montoPagoStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan datos requeridos");
            return;
        }
        LocalDate fechaPago;
        LocalDate fechaFin;
        try {
            fechaPago = LocalDate.parse(fechaPagoStr);
            fechaFin = fechaPago.plusYears(1);
        } catch (DateTimeParseException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "FechaPagoSOAT inválida");
            return;
        }
        String fechaFinStr = fechaFin.toString();
        double montoPago;
        try {
            montoPago = Double.parseDouble(montoPagoStr);
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "MontoPagoSOAT inválido");
            return;
        }
        Part filePart = request.getPart("ComprobanteSOAT");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ComprobanteSOAT");
            return;
        }
        String fileName = filePart.getSubmittedFileName();
        String contentType = filePart.getContentType();
        long fileSize = filePart.getSize();
        if (!("application/pdf".equals(contentType) || contentType.startsWith("image/"))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo de archivo no permitido");
            return;
        }
        byte[] fileBytes = filePart.getInputStream().readAllBytes();
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO SOAT (Placa, FechaPagoSOAT, FechaFinPagoSOAT, MontoPagoSOAT, ComprobanteSOAT) "
                       + "VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setString(2, fechaPago.toString());
            ps.setString(3, fechaFinStr);
            ps.setDouble(4, montoPago);
            try (ByteArrayInputStream bais = new ByteArrayInputStream(fileBytes)) {
                ps.setBinaryStream(5, bais, fileBytes.length);
                int rowsInserted = ps.executeUpdate();
            }
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al guardar SOAT");
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ex) {}
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }
}
