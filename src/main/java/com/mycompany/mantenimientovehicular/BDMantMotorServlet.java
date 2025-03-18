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

@WebServlet("/BDMantMotor")
public class BDMantMotorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String placa = request.getParameter("placa");
        List<Map<String, Object>> listaMotor = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionDB.getConexion();
            String sql = "SELECT IdMantMotor, Placa, Precio, FechaMotor, Kilometraje " +
                         "FROM MantMotor " +
                         "WHERE Placa = ? " +
                         "ORDER BY IdMantMotor DESC";
            ps = conn.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> registro = new HashMap<>();
                registro.put("IdMantMotor", rs.getInt("IdMantMotor"));
                registro.put("Placa", rs.getString("Placa"));
                registro.put("Precio", rs.getDouble("Precio"));
                registro.put("FechaMotor", rs.getString("FechaMotor"));
                registro.put("Kilometraje", rs.getInt("Kilometraje"));
                listaMotor.add(registro);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception ex){}
            if (ps != null) try { ps.close(); } catch(Exception ex){}
            if (conn != null) try { conn.close(); } catch(Exception ex){}
        }
        String json = new Gson().toJson(listaMotor);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
