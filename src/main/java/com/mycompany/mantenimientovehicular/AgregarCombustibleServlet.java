package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarCombustibleServlet")
public class AgregarCombustibleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String galonesStr = request.getParameter("Galones");
        String precioStr = request.getParameter("PrecioComb");
        String fechaStr = request.getParameter("FechaPagoComb");
        String tipoComb = request.getParameter("TipoCombustible");
        String kmStr = request.getParameter("KMComb");

        System.out.println("Servlet Combustible - placa: " + placa + 
                           ", Galones: " + galonesStr + 
                           ", PrecioComb: " + precioStr +
                           ", FechaPagoComb: " + fechaStr +
                           ", TipoCombustible: " + tipoComb +
                           ", KMComb: " + kmStr);

        double galones = 0.0;
        double precio = 0.0;
        int kmComb = 0;
        try {
            if (galonesStr != null && !galonesStr.isEmpty()) {
                galones = Double.parseDouble(galonesStr);
            }
            if (precioStr != null && !precioStr.isEmpty()) {
                precio = Double.parseDouble(precioStr);
            }
            if (kmStr != null && !kmStr.isEmpty()) {
                kmComb = Integer.parseInt(kmStr);
            }
        } catch (NumberFormatException ex) {
            System.out.println("Error parseando números: " + ex.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros numéricos inválidos");
            return;
        }
        
        java.sql.Date fechaPago = null;
        try {
            if (fechaStr != null && !fechaStr.isEmpty()) {
                fechaPago = java.sql.Date.valueOf(fechaStr);
            }
        } catch (IllegalArgumentException ex) {
            System.out.println("Error parseando fecha: " + ex.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fecha inválida");
            return;
        }
        
        if (!("Diesel".equals(tipoComb) || "Gas Licuado de Petroleo".equals(tipoComb) || "Gasolina".equals(tipoComb))) {
            System.out.println("TipoCombustible inválido: " + tipoComb);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "TipoCombustible inválido");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO Combustible " +
                         "(Placa, Galones, PrecioComb, FechaPagoComb, TipoCombustible, KMComb) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setDouble(2, galones);
            ps.setDouble(3, precio);
            ps.setDate(4, fechaPago);
            ps.setString(5, tipoComb);
            ps.setInt(6, kmComb);
            int rowsInserted = ps.executeUpdate();
            System.out.println("Filas insertadas en Combustible: " + rowsInserted);
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error al guardar Repostaje de Combustible");
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
    }
}
