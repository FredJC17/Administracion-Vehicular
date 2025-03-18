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

@WebServlet("/BDObservacionesServlet")
public class BDObservacionesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        List<Map<String, Object>> listaObs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT id, placa, comentario FROM Observaciones WHERE placa = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> obs = new HashMap<>();
                obs.put("id", rs.getInt("id"));
                obs.put("placa", rs.getString("placa"));
                obs.put("comentario", rs.getString("comentario"));
                listaObs.add(obs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ex){}
            if (ps != null) try { ps.close(); } catch (Exception ex){}
            if (conn != null) try { conn.close(); } catch (Exception ex){}
        }
        String json = new Gson().toJson(listaObs);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
