package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DownloadSoatServlet")
public class DownloadSoatServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el parámetro id");
            return;
        }
        int idSoat;
        try {
            idSoat = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "id inválido");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT ComprobanteSOAT FROM SOAT WHERE IdSOAT = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idSoat);
            rs = ps.executeQuery();
            if (rs.next()) {
                byte[] fileBytes = rs.getBytes("ComprobanteSOAT");
                if (fileBytes == null || fileBytes.length == 0) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No existe comprobante para este SOAT");
                    return;
                }
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", 
                                   "attachment; filename=\"Soat_" + idSoat + ".pdf\"");
                OutputStream out = response.getOutputStream();
                out.write(fileBytes);
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, 
                                   "No se encontró el SOAT con id=" + idSoat);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error interno al descargar el comprobante");
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ex){}
            if (ps != null) try { ps.close(); } catch(Exception ex){}
            if (conn != null) try { conn.close(); } catch(Exception ex){}
        }
    }
}

