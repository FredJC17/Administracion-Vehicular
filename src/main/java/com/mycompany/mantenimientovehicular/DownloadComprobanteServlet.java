package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DownloadComprobanteServlet")
public class DownloadComprobanteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRevStr = request.getParameter("id");
        if (idRevStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta parámetro id");
            return;
        }
        int idRevision;
        try {
            idRevision = Integer.parseInt(idRevStr);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "id inválido");
            return;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT ComprobanteRT FROM RevisionTecnica WHERE IdRevision = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idRevision);
            rs = ps.executeQuery();
            if (rs.next()) {
                byte[] fileBytes = rs.getBytes("ComprobanteRT");
                if (fileBytes == null || fileBytes.length == 0) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No existe comprobante para esta revisión");
                    return;
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=\"Comprobante_" + idRevision + ".pdf\"");
                OutputStream out = response.getOutputStream();
                out.write(fileBytes);
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró la revisión con id=" + idRevision);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al descargar");
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ex){}
            if (ps != null) try { ps.close(); } catch(Exception ex){}
            if (conn != null) try { conn.close(); } catch(Exception ex){}
        }
    }
}
