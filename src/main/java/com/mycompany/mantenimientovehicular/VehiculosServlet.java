package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/VehiculosServlet")
public class VehiculosServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder html = new StringBuilder();
        html.append("<div class='cards-container'>");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConexionDB.getConexion();

            String sql =
    "SELECT v.placa, v.marca, v.modelo, v.color, v.detalles, "
  + "       s.FechaFinPagoSOAT, r.FechaRevFin, "
  + "       c.FechaPagoComb, c.Galones, c.KMComb, c.PrecioComb, "
  + "       ms.FechaCambioSus, ms.Precio AS PrecioSus, ms.KMSus, "
  + "       mf.FechaCambioFA, mf.PrecioFAceite, mf.KMFA, "
  + "       ma.FechaCambioAceite, ma.PrecioAceite, ma.KMAceite, "
  + "       mm.FechaMotor, mm.Precio AS PrecioMotor, mm.Kilometraje "
  + "FROM Vehiculos v "

  // subconsultas
  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdSOAT) AS maxIdSoat "
  + "    FROM SOAT "
  + "    GROUP BY placa "
  + ") subSoat ON v.placa = subSoat.placa "
  + "LEFT JOIN SOAT s ON s.IdSOAT = subSoat.maxIdSoat "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdRevision) AS maxIdRevision "
  + "    FROM RevisionTecnica "
  + "    GROUP BY placa "
  + ") subRev ON v.placa = subRev.placa "
  + "LEFT JOIN RevisionTecnica r ON r.IdRevision = subRev.maxIdRevision "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdCombustible) AS maxIdComb "
  + "    FROM Combustible "
  + "    GROUP BY placa "
  + ") subComb ON v.placa = subComb.placa "
  + "LEFT JOIN Combustible c ON c.IdCombustible = subComb.maxIdComb "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdMantSuspension) AS maxIdSus "
  + "    FROM MantSuspension "
  + "    GROUP BY placa "
  + ") subSus ON v.placa = subSus.placa "
  + "LEFT JOIN MantSuspension ms ON ms.IdMantSuspension = subSus.maxIdSus "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdMantFAceite) AS maxIdFA "
  + "    FROM MantFAceite "
  + "    GROUP BY placa "
  + ") subFA ON v.placa = subFA.placa "
  + "LEFT JOIN MantFAceite mf ON mf.IdMantFAceite = subFA.maxIdFA "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdMantAceite) AS maxIdAce "
  + "    FROM MantAceite "
  + "    GROUP BY placa "
  + ") subAce ON v.placa = subAce.placa "
  + "LEFT JOIN MantAceite ma ON ma.IdMantAceite = subAce.maxIdAce "

  + "LEFT JOIN ( "
  + "    SELECT placa, MAX(IdMantMotor) AS maxIdMotor "
  + "    FROM MantMotor "
  + "    GROUP BY placa "
  + ") subMotor ON v.placa = subMotor.placa "
  + "LEFT JOIN MantMotor mm ON mm.IdMantMotor = subMotor.maxIdMotor "

  + "WHERE v.Borrado = 0";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            Date hoy = new Date();
            while (rs.next()) {
                String placa    = rs.getString("placa");
                String marca    = rs.getString("marca");
                String modelo   = rs.getString("modelo");
                String color    = rs.getString("color");
                String detalles = rs.getString("detalles");
                Date fechaFinSOAT = rs.getDate("FechaFinPagoSOAT");
                Date fechaRevFin  = rs.getDate("FechaRevFin");

                boolean soatVencido = (fechaFinSOAT != null && fechaFinSOAT.before(hoy));
                boolean revVencido  = (fechaRevFin  != null && fechaRevFin.before(hoy));
                String cardClass = (soatVencido || revVencido) ? "card-vencida" : "card_";

                html.append("<div class='").append(cardClass).append("' ")
                    .append("onclick=\"mostrarVentana('").append(placa != null ? placa : "").append("')\">")
                    .append("<div class='card_2'>")
                    .append("<h1>").append(placa != null ? placa : "").append("</h1>")
                    .append("<h2>").append(marca != null ? marca : "").append(" (")
                                  .append(modelo != null ? modelo : "").append(")</h2>")
                    .append("<p>Color: ").append(color != null ? color : "").append("</p>")
                    .append("<p>Detalles: ").append(detalles != null ? detalles : "").append("</p>")
                    .append("<p>Rev. Técnica: ")
                    .append(fechaRevFin != null ? fechaRevFin.toString() : "N/A")
                    .append("</p>")
                    .append("<p>SOAT: ")
                    .append(fechaFinSOAT != null ? fechaFinSOAT.toString() : "N/A")
                    .append("</p>")
                    .append("</div></div>");
            }
        } catch (Exception e) {
            html.append("<p>Error: ").append(e.getMessage()).append("</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ex) {}
            if (ps != null) try { ps.close(); } catch (Exception ex) {}
            if (con != null) try { con.close(); } catch (Exception ex) {}
        }
        html.append("</div>");
        out.write(html.toString());
    }
}
