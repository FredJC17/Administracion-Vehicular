package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarObservacionServlet")
public class EditarObservacionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Recoger parámetros del formulario
        String idObservacion = request.getParameter("idObservacion");
        String comentario = request.getParameter("comentario");
        
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE Observaciones SET comentario = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, comentario);
                ps.setString(2, idObservacion);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("<script>alert('No se pudo actualizar la observación.');</script>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar observación: " + e.getMessage() + "');</script>");
        }
    }
}
