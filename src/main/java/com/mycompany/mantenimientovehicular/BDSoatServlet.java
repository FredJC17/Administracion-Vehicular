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

@WebServlet("/BDSoatServlet")
public class BDSoatServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        List<Map<String, Object>> listaSoat = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT IdSOAT, FechaPagoSOAT, FechaFinPagoSOAT, MontoPagoSOAT " +
                         "FROM SOAT " +
                         "WHERE Placa = ? " +
                         "ORDER BY IdSOAT DESC";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> soatData = new HashMap<>();
                soatData.put("IdSOAT", rs.getInt("IdSOAT"));
                soatData.put("FechaPagoSOAT", rs.getString("FechaPagoSOAT"));
                soatData.put("FechaFinPagoSOAT", rs.getString("FechaFinPagoSOAT"));
                soatData.put("MontoPagoSOAT", rs.getDouble("MontoPagoSOAT"));
                listaSoat.add(soatData);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ex) {}
            if (ps != null) try { ps.close(); } catch (Exception ex) {}
            if (conn != null) try { conn.close(); } catch (Exception ex) {}
        }
        String json = new Gson().toJson(listaSoat);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
