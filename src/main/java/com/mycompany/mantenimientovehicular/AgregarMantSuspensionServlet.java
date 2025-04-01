package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarMantSuspensionServlet")
public class AgregarMantSuspensionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String precioStr = request.getParameter("Precio");
        String fechaStr = request.getParameter("FechaCambioSus");
        String kmStr = request.getParameter("KMSus");
        double precio = 0.0;
        int kmSus = 0;
        try {
            if (precioStr != null && !precioStr.isEmpty()) {
                precio = Double.parseDouble(precioStr);
            }
            if (kmStr != null && !kmStr.isEmpty()) {
                kmSus = Integer.parseInt(kmStr);
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros numéricos inválidos");
            return;
        }
        java.sql.Date fechaCambioSus = null;
        try {
            if (fechaStr != null && !fechaStr.isEmpty()) {
                fechaCambioSus = java.sql.Date.valueOf(fechaStr); 
            }
        } catch (IllegalArgumentException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fecha inválida");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO MantSuspension " +
                         "(Placa, Precio, FechaCambioSus, KMSus) " +
                         "VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setDouble(2, precio);
            ps.setDate(3, fechaCambioSus);
            ps.setInt(4, kmSus);
            int rowsInserted = ps.executeUpdate();
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error al guardar Mantenimiento de Suspensión");
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
    }
}
