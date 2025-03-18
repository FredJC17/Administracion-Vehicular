package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BDRevisionServlet")
public class BDRevisionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        if (placa == null || placa.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el parámetro placa");
            return;
        }
        List<Map<String, Object>> listaRevisiones = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConexionDB.getConexion();
            String sql = "SELECT IdRevision, FechaRev, FechaRevFin, ComprobanteRT " +
                         "FROM RevisionTecnica " +
                         "WHERE placa = ? " +
                         "ORDER BY IdRevision DESC";
            ps = con.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> rev = new HashMap<>();
                rev.put("IdRevision", rs.getInt("IdRevision"));
                rev.put("FechaRev",   rs.getString("FechaRev"));
                rev.put("FechaRevFin", rs.getString("FechaRevFin"));
                rev.put("ComprobanteRT", rs.getBytes("ComprobanteRT") != null 
                                         ? "EXISTE" : null);
                listaRevisiones.add(rev);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener revisiones");
            return;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ex){}
            if (ps != null) try { ps.close(); } catch (SQLException ex){}
            if (con != null) try { con.close(); } catch (SQLException ex){}
        }
        String json = new Gson().toJson(listaRevisiones);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
