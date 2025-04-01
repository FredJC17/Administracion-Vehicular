package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/EstadisticaServlet")
public class EstadisticaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) {
            response.getWriter().write("[]");
            return;
        }
        switch (accion) {
            case "soat":
                datosSoat(response);
                break;
            case "revision":
                datosRevision(response);
                break;
            default:
                response.getWriter().write("[]");
        }
    }

    private void datosSoat(HttpServletResponse response) throws IOException {
        List<Map<String,Object>> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion()) {
            String sql = 
              "SELECT FechaPagoSOAT, FechaFinPagoSOAT, MontoPagoSOAT, "
            + "       DATEDIFF(DAY, FechaPagoSOAT, FechaFinPagoSOAT) AS diasEntre "
            + "FROM SOAT "
            + "ORDER BY IdSOAT";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("fechaPago", rs.getString("FechaPagoSOAT"));
                row.put("fechaFin", rs.getString("FechaFinPagoSOAT"));
                row.put("monto", rs.getDouble("MontoPagoSOAT"));
                row.put("diasEntre", rs.getInt("diasEntre"));
                lista.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        String json = new Gson().toJson(lista);
        response.getWriter().write(json);
    }

    private void datosRevision(HttpServletResponse response) throws IOException {
        List<Map<String,Object>> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion()) {
            String sql = 
              "SELECT FechaRev, FechaRevFin, CostoRevision, "
            + "       DATEDIFF(DAY, FechaRev, FechaRevFin) AS diasEntre "
            + "FROM RevisionTecnica "
            + "ORDER BY IdRevision";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("fechaRev", rs.getString("FechaRev"));
                row.put("fechaRevFin", rs.getString("FechaRevFin"));
                row.put("costo", rs.getDouble("CostoRevision"));
                row.put("diasEntre", rs.getInt("diasEntre"));
                lista.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        String json = new Gson().toJson(lista);
        response.getWriter().write(json);
    }
}

