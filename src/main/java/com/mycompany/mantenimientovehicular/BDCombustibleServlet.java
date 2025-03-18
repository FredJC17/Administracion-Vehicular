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

@WebServlet("/BDCombustible")
public class BDCombustibleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        List<Map<String, Object>> listaCombustible = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT IdCombustible, Placa, Galones, PrecioComb, FechaPagoComb, TipoCombustible, KMComb " +
                         "FROM Combustible " +
                         "WHERE Placa = ? " +
                         "ORDER BY IdCombustible DESC";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> registro = new HashMap<>();
                registro.put("IdCombustible", rs.getInt("IdCombustible"));
                registro.put("Placa", rs.getString("Placa"));
                registro.put("Galones", rs.getDouble("Galones"));
                registro.put("PrecioComb", rs.getDouble("PrecioComb"));
                registro.put("FechaPagoComb", rs.getString("FechaPagoComb"));
                registro.put("TipoCombustible", rs.getString("TipoCombustible"));
                registro.put("KMComb", rs.getInt("KMComb"));
                listaCombustible.add(registro);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ex){}
            if (ps != null) try { ps.close(); } catch(Exception ex){}
            if (conn != null) try { conn.close(); } catch(Exception ex){}
        }
        String json = new Gson().toJson(listaCombustible);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
