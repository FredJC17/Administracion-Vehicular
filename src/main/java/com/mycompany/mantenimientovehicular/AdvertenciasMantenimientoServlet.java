package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.PrintWriter;
import java.sql.Date;

@WebServlet("/AdvertenciasMantenimientoServlet")
public class AdvertenciasMantenimientoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        String advertencias = obtenerAdvertenciasMantenimiento();
        if (!advertencias.isEmpty()) {
            out.print(advertencias);
        } else {
            out.print("");
        }
        out.close();
    }

    
    
    
    private String obtenerAdvertenciasMantenimiento() {
        String mensajeAlerta = "";
       
        try (Connection conn = ConexionDB.getConexion()) {
            String sql =
    "SELECT 'SOAT' AS tipo, v.Placa, v.Marca, v.Modelo, s.FechaFinPagoSOAT AS FechaFin, "
  + "DATEDIFF(DAY, GETDATE(), s.FechaFinPagoSOAT) AS DiasRestantes "
  + "FROM Vehiculos v "
  + "JOIN ( "
  + "    SELECT placa, MAX(IdSOAT) AS maxIdSoat "
  + "    FROM SOAT "
  + "    GROUP BY placa "
  + ") subSoat ON v.Placa = subSoat.Placa "
  + "JOIN SOAT s ON s.IdSOAT = subSoat.maxIdSoat "
  + "WHERE DATEDIFF(DAY, GETDATE(), s.FechaFinPagoSOAT) IN (1,2,3,4,5,6,7,15,30,60) "
  + "   OR DATEDIFF(DAY, GETDATE(), s.FechaFinPagoSOAT) <= 0 "

  + "UNION ALL "

  + "SELECT 'REVISION' AS tipo, v.Placa, v.Marca, v.Modelo, r.FechaRevFin AS FechaFin, "
  + "DATEDIFF(DAY, GETDATE(), r.FechaRevFin) AS DiasRestantes "
  + "FROM Vehiculos v "
  + "JOIN ( "
  + "    SELECT placa, MAX(IdRevision) AS maxIdRevision "
  + "    FROM RevisionTecnica "
  + "    GROUP BY placa "
  + ") subRev ON v.Placa = subRev.Placa "
  + "JOIN RevisionTecnica r ON r.IdRevision = subRev.maxIdRevision "
  + "WHERE DATEDIFF(DAY, GETDATE(), r.FechaRevFin) IN (1,2,3,4,5,6,7,15,30,60) "
  + "   OR DATEDIFF(DAY, GETDATE(), r.FechaRevFin) <= 0 "

  + "ORDER BY DiasRestantes ASC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String tipo = rs.getString("tipo");
                String placa = rs.getString("Placa");
                String marca = rs.getString("Marca");
                String modelo = rs.getString("Modelo");
                Date fechaFin = rs.getDate("FechaFin");
                int diasRestantes = rs.getInt("DiasRestantes");
                String estado = (diasRestantes < 0) ? "⚠️ VENCIDO" : "🔔 Próximo a vencer";
                mensajeAlerta += estado + " (" + tipo + "):\n"
                        + "Placa : " + placa + "\n"
                        + "Marca : " + marca + "\n"
                        + "Modelo : " + modelo + "\n"
                        + "Días Restantes : " + diasRestantes + " días\n"
                        + "Fecha Final : " + fechaFin + "\n\n";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error al obtener advertencias: " + e.getMessage();
        }
        return mensajeAlerta.trim();
    }
}
