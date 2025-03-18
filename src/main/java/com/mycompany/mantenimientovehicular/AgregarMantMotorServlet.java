package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AgregarMantMotorServlet")
public class AgregarMantMotorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String precioStr = request.getParameter("Precio");
        String fechaStr = request.getParameter("FechaMotor");
        String kmStr = request.getParameter("Kilometraje");

        System.out.println("Servlet MantMotor - placa: " + placa + 
                           ", Precio: " + precioStr + 
                           ", FechaMotor: " + fechaStr +
                           ", Kilometraje: " + kmStr);
        double precio = 0.0;
        int kilometraje = 0;
        try {
            if (precioStr != null && !precioStr.isEmpty()) {
                precio = Double.parseDouble(precioStr);
            }
            if (kmStr != null && !kmStr.isEmpty()) {
                kilometraje = Integer.parseInt(kmStr);
            }
        } catch (NumberFormatException ex) {
            System.out.println("Error parseando números: " + ex.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros numéricos inválidos");
            return;
        }
        java.sql.Date fechaMotor = null;
        try {
            if (fechaStr != null && !fechaStr.isEmpty()) {
                fechaMotor = java.sql.Date.valueOf(fechaStr);
            }
        } catch (IllegalArgumentException ex) {
            System.out.println("Error parseando fecha: " + ex.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fecha inválida");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO MantMotor " +
                         "(Placa, Precio, FechaMotor, Kilometraje) " +
                         "VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setDouble(2, precio);
            ps.setDate(3, fechaMotor);
            ps.setInt(4, kilometraje);
            int rowsInserted = ps.executeUpdate();
            System.out.println("Filas insertadas en MantMotor: " + rowsInserted);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error al guardar Mantenimiento de Motor");
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
    }
}
