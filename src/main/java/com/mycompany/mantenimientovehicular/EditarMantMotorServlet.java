package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarMantMotorServlet")
public class EditarMantMotorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        // Configurar codificación para recibir caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Obtener parámetros del formulario
        String idMantMotor = request.getParameter("idMantMotor");
        String placa = request.getParameter("placa"); // si se necesita
        String precioStr = request.getParameter("Precio");
        String fechaMotor = request.getParameter("FechaMotor");
        String kilometrajeStr = request.getParameter("Kilometraje");

        double precio = 0, kilometraje = 0;
        try {
            precio = Double.parseDouble(precioStr);
            kilometraje = Double.parseDouble(kilometrajeStr);
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('Error en la conversión de números: " + e.getMessage() + "');</script>");
            return;
        }

        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE MantMotor SET Precio = ?, FechaMotor = ?, Kilometraje = ? WHERE IdMantMotor = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDouble(1, precio);
                ps.setString(2, fechaMotor);
                ps.setDouble(3, kilometraje);
                ps.setString(4, idMantMotor);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("No se pudo actualizar el repostaje.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar mantenimiento de motor: " + e.getMessage() + "');</script>");
        }
    }
}
