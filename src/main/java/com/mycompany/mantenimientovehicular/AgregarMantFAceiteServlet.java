package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarMantFAceiteServlet")
public class AgregarMantFAceiteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String precioStr = request.getParameter("PrecioFAceite");
        String fechaStr = request.getParameter("FechaCambioFA");
        String kmStr = request.getParameter("KMFA");


        double precioFAceite = 0.0;
        int kmFA = 0;
        try {
            if (precioStr != null && !precioStr.isEmpty()) {
                precioFAceite = Double.parseDouble(precioStr);
            }
            if (kmStr != null && !kmStr.isEmpty()) {
                kmFA = Integer.parseInt(kmStr);
            }
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros numéricos inválidos");
            return;
        }
        java.sql.Date fechaCambioFA = null;
        try {
            if (fechaStr != null && !fechaStr.isEmpty()) {
                fechaCambioFA = java.sql.Date.valueOf(fechaStr); 
            }
        } catch (IllegalArgumentException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fecha inválida");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO MantFAceite " +
                         "(Placa, PrecioFAceite, FechaCambioFA, KMFA) " +
                         "VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setDouble(2, precioFAceite);
            ps.setDate(3, fechaCambioFA);
            ps.setInt(4, kmFA);

            int rowsInserted = ps.executeUpdate();
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error al guardar Mantenimiento de Filtro de Aceite");
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
    }
}
