package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BorrarVehiculoServlet")
public class BorrarVehiculoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String placa = request.getParameter("placa");
        if (placa == null || placa.trim().isEmpty()) {
            out.write("Placa no especificada.");
            return;
        }

        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE Vehiculos SET Borrado = 1 WHERE Placa = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, placa);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                out.write("El vehículo con placa " + placa + " se marcó como borrado.");
            } else {
                out.write("No se encontró el vehículo con placa " + placa + ".");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("Error al borrar el vehículo: " + e.getMessage());
        }
    }
}
