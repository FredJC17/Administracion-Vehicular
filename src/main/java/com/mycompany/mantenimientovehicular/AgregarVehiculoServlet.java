package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/AgregarVehiculoServlet")
public class AgregarVehiculoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String color = request.getParameter("color");
        String detalles = request.getParameter("detalles");
        String fechaCompraStr = request.getParameter("fechaCompra");
        java.sql.Date fechaCompra = null;
        if (fechaCompraStr != null && !fechaCompraStr.isEmpty()) {
            LocalDate localDate = LocalDate.parse(fechaCompraStr, DateTimeFormatter.ISO_LOCAL_DATE);
            fechaCompra = Date.valueOf(localDate);
        }
        try (Connection conn = ConexionDB.getConexion()) {
            String sql = "INSERT INTO Vehiculos (Placa, Marca, Modelo, Color, Detalles, FechaCompra) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, placa);
                stmt.setString(2, marca);
                stmt.setString(3, modelo);
                stmt.setString(4, color);
                stmt.setString(5, detalles);
                stmt.setDate(6, fechaCompra);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("index.jsp");
    }
}