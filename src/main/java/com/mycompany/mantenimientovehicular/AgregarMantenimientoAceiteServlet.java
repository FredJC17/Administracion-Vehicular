package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarMantenimientoAceiteServlet")
public class AgregarMantenimientoAceiteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String precioStr = request.getParameter("PrecioAceite");
        String cantStr = request.getParameter("CantAceite");
        String fechaStr = request.getParameter("FechaCambioAceite");
        String kmStr = request.getParameter("KMAceite");
        double precioAceite = 0.0;
        double cantAceite = 0.0;
        int kmAceite = 0;
        try {
            if (precioStr != null && !precioStr.isEmpty()) {
                precioAceite = Double.parseDouble(precioStr);
            }
            if (cantStr != null && !cantStr.isEmpty()) {
                cantAceite = Double.parseDouble(cantStr);
            }
            if (kmStr != null && !kmStr.isEmpty()) {
                kmAceite = Integer.parseInt(kmStr);
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros numéricos inválidos");
            return;
        }
        java.sql.Date fechaCambio = null;
        try {
            if (fechaStr != null && !fechaStr.isEmpty()) {
                fechaCambio = java.sql.Date.valueOf(fechaStr); 
            }
        } catch (IllegalArgumentException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fecha inválida");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO MantAceite " +
                         "(Placa, PrecioAceite, CantAceite, FechaCambioAceite, KMAceite) " +
                         "VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setDouble(2, precioAceite);
            ps.setDouble(3, cantAceite);
            ps.setDate(4, fechaCambio);
            ps.setInt(5, kmAceite);
            int rowsInserted = ps.executeUpdate();
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al guardar Mantenimiento de Aceite");
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
    }
}
