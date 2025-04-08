package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/EditarRevisionServlet")
@MultipartConfig
public class EditarRevisionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Recoger parámetros del formulario
        String idRevision = request.getParameter("idRevision");
        String fechaRevStr = request.getParameter("FechaRev");
        
        // Convertir la fecha de revisión y sumar 1 año para la fecha final
        LocalDate fechaRev;
        LocalDate fechaRevFin;
        try {
            fechaRev = LocalDate.parse(fechaRevStr);
            fechaRevFin = fechaRev.plusYears(1);
        } catch (DateTimeParseException e) {
            response.getWriter().println("<script>alert('Error en el formato de la fecha: " + e.getMessage() + "');</script>");
            return;
        }
        
        // Procesar el archivo subido para comprobanteRT
        Part filePart = request.getPart("comprobanteRT");
        InputStream fileContent = null;
        boolean hayArchivo = false;
        if (filePart != null && filePart.getSize() > 0) {
            fileContent = filePart.getInputStream();
            hayArchivo = true;
        }
        
        try (Connection con = ConexionDB.getConexion()) {
            String sql;
            if (hayArchivo) {
                sql = "UPDATE RevisionTecnica SET FechaRev = ?, FechaRevFin = ?, ComprobanteRT = ? WHERE IdRevision = ?";
            } else {
                sql = "UPDATE RevisionTecnica SET FechaRev = ?, FechaRevFin = ? WHERE IdRevision = ?";
            }
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fechaRev.toString());
                ps.setString(2, fechaRevFin.toString());
                if (hayArchivo) {
                    ps.setBinaryStream(3, fileContent, (int) filePart.getSize());
                    ps.setString(4, idRevision);
                } else {
                    ps.setString(3, idRevision);
                }
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    // Cerrar el modal mediante JavaScript
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("<script>alert('No se pudo actualizar la revisión.');</script>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar revisión: " + e.getMessage() + "');</script>");
        }
    }
}
