package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BDMantFAceite")
public class BDMantFAceiteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        List<Map<String, Object>> listaFA = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT IdMantFAceite, Placa, PrecioFAceite, FechaCambioFA, KMFA " +
                         "FROM MantFAceite " +
                         "WHERE Placa = ? " +
                         "ORDER BY IdMantFAceite DESC";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> registro = new HashMap<>();
                registro.put("IdMantFAceite", rs.getInt("IdMantFAceite"));
                registro.put("Placa", rs.getString("Placa"));
                registro.put("PrecioFAceite", rs.getDouble("PrecioFAceite"));
                registro.put("FechaCambioFA", rs.getString("FechaCambioFA"));
                registro.put("KMFA", rs.getInt("KMFA"));
                listaFA.add(registro);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ex){}
            if (ps != null) try { ps.close(); } catch(Exception ex){}
            if (conn != null) try { conn.close(); } catch(Exception ex){}
        }
        String json = new Gson().toJson(listaFA);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
