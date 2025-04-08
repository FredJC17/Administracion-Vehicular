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

@WebServlet("/EditarSoatServlet")
@MultipartConfig
public class EditarSoatServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Recoger parámetros
        String idSoat = request.getParameter("idSoat");
        String fechaPagoSoatStr = request.getParameter("FechaPagoSOAT");
        String montoPagoSoatStr = request.getParameter("MontoPagoSOAT");
        
        double montoPagoSoat = 0;
        try {
            montoPagoSoat = Double.parseDouble(montoPagoSoatStr);
        } catch (NumberFormatException nfe) {
            response.getWriter().println("<script>alert('Error en la conversión de números: " + nfe.getMessage() + "');</script>");
            return;
        }
        
        // Convertir la fecha de pago y sumar 1 año para obtener la fecha fin
        LocalDate fechaPagoSoat;
        LocalDate fechaFinSoat;
        try {
            fechaPagoSoat = LocalDate.parse(fechaPagoSoatStr);
            fechaFinSoat = fechaPagoSoat.plusYears(1);
        } catch (DateTimeParseException e) {
            response.getWriter().println("<script>alert('Error en el formato de la fecha: " + e.getMessage() + "');</script>");
            return;
        }
        
        // Procesar el archivo subido (ComprobanteSOAT)
        Part filePart = request.getPart("ComprobanteSOAT");
        InputStream fileContent = null;
        boolean hayArchivo = false;
        if (filePart != null && filePart.getSize() > 0) {
            fileContent = filePart.getInputStream();
            hayArchivo = true;
        }
        
        try (Connection con = ConexionDB.getConexion()) {
            String sql;
            if (hayArchivo) {
                sql = "UPDATE SOAT SET FechaPagoSOAT = ?, FechaFinPagoSOAT = ?, MontoPagoSOAT = ?, ComprobanteSOAT = ? WHERE IdSOAT = ?";
            } else {
                sql = "UPDATE SOAT SET FechaPagoSOAT = ?, FechaFinPagoSOAT = ?, MontoPagoSOAT = ? WHERE IdSOAT = ?";
            }
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fechaPagoSoat.toString());
                ps.setString(2, fechaFinSoat.toString());
                ps.setDouble(3, montoPagoSoat);
                if (hayArchivo) {
                    ps.setBinaryStream(4, fileContent, (int) filePart.getSize());
                    ps.setString(5, idSoat);
                } else {
                    ps.setString(4, idSoat);
                }
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("<script>alert('No se pudo actualizar el SOAT.');</script>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Error al actualizar SOAT: " + e.getMessage() + "');</script>");
        }
    }
}
