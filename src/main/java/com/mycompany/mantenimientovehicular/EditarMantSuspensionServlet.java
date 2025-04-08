package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarMantSuspensionServlet")
public class EditarMantSuspensionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        // Configurar la codificación para caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Recoger parámetros del formulario
        String idMantSuspension = request.getParameter("idMantSuspension");
        String precioStr = request.getParameter("Precio");
        String fechaCambioSus = request.getParameter("FechaCambioSus");
        String kmsusStr = request.getParameter("KMSus");
        
        double precio = 0;
        double kmsus = 0;
        try {
            precio = Double.parseDouble(precioStr);
            kmsus = Double.parseDouble(kmsusStr);
        } catch (NumberFormatException nfe) {
            response.getWriter().println("<script>alert('Error en la conversión de números: " + nfe.getMessage() + "');</script>");
            return;
        }
        
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE MantSuspension SET Precio = ?, FechaCambioSus = ?, KMSus = ? WHERE IdMantSuspension = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDouble(1, precio);
                ps.setString(2, fechaCambioSus);
                ps.setDouble(3, kmsus);
                ps.setString(4, idMantSuspension);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("No se pudo actualizar el repostaje.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar mantenimiento de suspensión: " + e.getMessage() + "');</script>");
        }
    }
}
