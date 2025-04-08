package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarMantAceiteServlet")
public class EditarMantAceiteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Recoger parámetros del formulario
        String idMantAceite = request.getParameter("idMantAceite");
        String precioStr = request.getParameter("PrecioAceite");
        String cantStr = request.getParameter("CantAceite");
        String fechaCambioAceite = request.getParameter("FechaCambioAceite");
        String kmStr = request.getParameter("KMAceite");

        double precio = 0;
        double cantidad = 0;
        double kmAceite = 0;
        
        try {
            precio = Double.parseDouble(precioStr);
            cantidad = Double.parseDouble(cantStr);
            kmAceite = Double.parseDouble(kmStr);
        } catch (NumberFormatException nfe) {
            response.getWriter().println("<script>alert('Error en la conversión de datos: " + nfe.getMessage() + "');</script>");
            return;
        }

        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE MantAceite SET PrecioAceite = ?, CantAceite = ?, FechaCambioAceite = ?, KMAceite = ? WHERE IdMantAceite = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDouble(1, precio);
                ps.setDouble(2, cantidad);
                ps.setString(3, fechaCambioAceite);
                ps.setDouble(4, kmAceite);
                ps.setString(5, idMantAceite);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("<script>alert('No se pudo actualizar el mantenimiento de aceite');</script>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar mantenimiento de aceite: " + e.getMessage() + "');</script>");
        }
    }
}
