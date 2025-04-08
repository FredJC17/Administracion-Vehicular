package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarMantFAceiteServlet")
public class EditarMantFAceiteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Configurar la codificación para caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Recoger parámetros del formulario
        String idMantFAceite = request.getParameter("idMantFAceite");
        String precioStr = request.getParameter("PrecioFAceite");
        String fechaCambioFA = request.getParameter("FechaCambioFA");
        String kmfaStr = request.getParameter("KMFA");

        double precioFAceite = 0;
        double kmFA = 0;
        try {
            precioFAceite = Double.parseDouble(precioStr);
            kmFA = Double.parseDouble(kmfaStr);
        } catch (NumberFormatException nfe) {
            response.getWriter().println("<script>alert('Error en la conversión de números: " + nfe.getMessage() + "');</script>");
            return;
        }

        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE MantFAceite SET PrecioFAceite = ?, FechaCambioFA = ?, KMFA = ? WHERE IdMantFAceite = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDouble(1, precioFAceite);
                ps.setString(2, fechaCambioFA);
                ps.setDouble(3, kmFA);
                ps.setString(4, idMantFAceite);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("No se pudo actualizar el mantenimiento de filtro de aceite.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar mantenimiento de filtro de aceite: " + e.getMessage() + "');</script>");
        }
    }
}
