package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

@WebServlet("/OrdenarServlet")
public class OrdenarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {

        // Indicamos que devolveremos JSON (UTF-8)
        response.setContentType("application/json;charset=UTF-8");

        // Obtenemos el criterio del parámetro
        String criterio = request.getParameter("criterio");
        if (criterio == null || criterio.trim().isEmpty()) {
            // Si no hay criterio, devolvemos lista vacía
            response.getWriter().write("[]");
            return;
        }

        // Según el criterio, definimos un ORDER BY distinto
        String orderBy = determinarOrderBy(criterio);

        // Consulta base
        List<Map<String, String>> listaVehiculos = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion()) {
            // Ajusta las columnas según tu tabla (ej. FechaCompra si la tienes)
            String sql = "SELECT Placa, Marca, Modelo, FechaFinPagoSOAT, FechaRevFin, FechaCompra "
                       + "FROM Vehiculos "
                       + orderBy;  // Agregamos el ORDER BY

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> veh = new HashMap<>();
                veh.put("Placa", rs.getString("Placa"));
                veh.put("Marca", rs.getString("Marca"));
                veh.put("Modelo", rs.getString("Modelo"));

                // Ajusta los nombres si tus columnas se llaman distinto
                veh.put("FechaFinPagoSOAT", rs.getString("FechaFinPagoSOAT"));
                veh.put("FechaRevFin", rs.getString("FechaRevFin"));
                veh.put("FechaCompra", rs.getString("FechaCompra"));

                listaVehiculos.add(veh);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Convertir a JSON
        String json = new Gson().toJson(listaVehiculos);
        PrintWriter out = response.getWriter();
        out.write(json);
    }

    // Método auxiliar para definir el ORDER BY según el criterio
    private String determinarOrderBy(String criterio) {
        // Nota: Ajusta las columnas (Marca, FechaFinPagoSOAT, etc.) 
        //       para que coincidan con tu base de datos
        switch (criterio) {
            case "Orden-alfabetico":
                // Ordena por Marca (y tal vez Modelo) alfabéticamente
                return "ORDER BY Marca ASC, Modelo ASC";

            case "soat-proximo":
                // FechaFinPagoSOAT de más cercano a más lejano
                return "ORDER BY FechaFinPagoSOAT ASC";

            case "soat-lejano":
                return "ORDER BY FechaFinPagoSOAT DESC";

            case "revision-proxima":
                return "ORDER BY FechaRevFin ASC";

            case "revision-lejana":
                return "ORDER BY FechaRevFin DESC";

            case "vehiculo-antiguo":
                // FechaCompra de más antiguo a más nuevo
                return "ORDER BY FechaCompra ASC";

            case "vehiculo-nuevo":
                return "ORDER BY FechaCompra DESC";

            default:
                // Si el criterio no coincide, ordenamos por placa
                return "ORDER BY Placa ASC";
        }
    }
}
