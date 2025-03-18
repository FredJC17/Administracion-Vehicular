package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AgregarObservacionServlet")
public class AgregarObservacionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        String comentario = request.getParameter("comentario");
        if (placa == null || placa.trim().isEmpty() ||
            comentario == null || comentario.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan datos");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "INSERT INTO Observaciones (placa, comentario) VALUES (?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setString(2, comentario);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error al guardar la observación");
            return;
        } finally {
            if (ps != null) try { ps.close(); } catch(SQLException ex){}
            if (conn != null) try { conn.close(); } catch(SQLException ex){}
        }
        response.sendRedirect("index.jsp");
    }
}
