package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarRevisionServlet")
@MultipartConfig
public class AgregarRevisionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String fechaRevStr = request.getParameter("fechaRev");
        if (placa == null || placa.trim().isEmpty() || 
            fechaRevStr == null || fechaRevStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan campos requeridos");
            return;
        }
        LocalDate fechaRev;
        LocalDate fechaRevFin;
        try {
            fechaRev = LocalDate.parse(fechaRevStr);
            fechaRevFin = fechaRev.plus(1, ChronoUnit.YEARS);
        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "FechaRev inválida");
            return;
        }
        Part filePart = request.getPart("comprobanteRT");
        byte[] comprobanteBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream is = filePart.getInputStream()) {
                comprobanteBytes = is.readAllBytes();
            }
        }
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConexionDB.getConexion();
            String sql = "INSERT INTO RevisionTecnica (placa, FechaRev, FechaRevFin, ComprobanteRT) " +
                         "VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setString(2, fechaRev.toString());
            ps.setString(3, fechaRevFin.toString());
            if (comprobanteBytes != null) {
                ps.setBytes(4, comprobanteBytes);
            } else {
                ps.setNull(4, Types.VARBINARY);
            }
            ps.executeUpdate();
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al guardar la revisión");
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ex){}
            if (con != null) try { con.close(); } catch (SQLException ex){}
        }
    }
}
