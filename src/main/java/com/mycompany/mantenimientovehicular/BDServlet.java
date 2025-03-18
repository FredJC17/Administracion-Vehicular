package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

@WebServlet("/BDServlet")
public class BDServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String placa = request.getParameter("placa");
        if ("obtenerDatosDeVehiculos".equals(accion) && placa != null) {
            obtenerDatosDeVehiculo(placa, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros inválidos");
        }
    }
    
    
    
    private void obtenerDatosDeVehiculo(String placa, HttpServletResponse response)
            throws IOException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> data = new HashMap<>();
        try {
            con = ConexionDB.getConexion();
            String sql = 
    "SELECT v.placa, v.marca, v.modelo, v.color, v.detalles, v.FechaCompra, " +
    "       s.FechaFinPagoSOAT, s.MontoPagoSOAT, s.FechaPagoSOAT, " +
    "       r.FechaRevFin, r.FechaRev, " +
    "       c.FechaPagoComb, c.Galones, c.KMComb, c.PrecioComb, " +
    "       mp.IdTipoMotor, mp.IdTipoAceite, mp.CantAceite, " +
    "       ms.FechaCambioSus, ms.Precio, ms.KMSus, " +
    "       mm.FechaMotor, mm.Precio, mm.Kilometraje, " +
    "       mf.FechaCambioFA, mf.PrecioFAceite, mf.KMFA, " +
    "       ma.FechaCambioAceite, ma.PrecioAceite, ma.KMAceite " +
    "FROM Vehiculos v " +

    // soat elegir id mayor
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdSOAT) AS maxIdSoat " +
    "    FROM SOAT " +
    "    GROUP BY placa " +
    ") subSoat ON v.placa = subSoat.placa " +
    "LEFT JOIN SOAT s ON s.IdSOAT = subSoat.maxIdSoat " +
    
    // recision elegir el id mayor
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdRevision) AS maxIdRevision " +
    "    FROM RevisionTecnica " +
    "    GROUP BY placa " +
    ") subRev ON v.placa = subRev.placa " +
    "LEFT JOIN RevisionTecnica r ON r.IdRevision = subRev.maxIdRevision " +
    
    // combustible ...
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdCombustible) AS maxIdComb " +
    "    FROM Combustible " +
    "    GROUP BY placa " +
    ") subComb ON v.placa = subComb.placa " +
    "LEFT JOIN Combustible c ON c.IdCombustible = subComb.maxIdComb " +
    
    //motor prop...
    "LEFT JOIN MotorPropiedades mp ON v.placa = mp.placa " +
    
    // suspendion...
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdMantSuspension) AS maxIdSus " +
    "    FROM MantSuspension " +
    "    GROUP BY placa " +
    ") subSus ON v.placa = subSus.placa " +
    "LEFT JOIN MantSuspension ms ON ms.IdMantSuspension = subSus.maxIdSus " +
    
    // motor...
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdMantMotor) AS maxIdMotor " +
    "    FROM MantMotor " +
    "    GROUP BY placa " +
    ") subMotor ON v.placa = subMotor.placa " +
    "LEFT JOIN MantMotor mm ON mm.IdMantMotor = subMotor.maxIdMotor " +
    
    // filtro de aceite...
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdMantFAceite) AS maxIdFA " +
    "    FROM MantFAceite " +
    "    GROUP BY placa " +
    ") subFA ON v.placa = subFA.placa " +
    "LEFT JOIN MantFAceite mf ON mf.IdMantFAceite = subFA.maxIdFA " +
    
    // aceite...
    "LEFT JOIN ( " +
    "    SELECT placa, MAX(IdMantAceite) AS maxIdAce " +
    "    FROM MantAceite " +
    "    GROUP BY placa " +
    ") subAce ON v.placa = subAce.placa " +
    "LEFT JOIN MantAceite ma ON ma.IdMantAceite = subAce.maxIdAce " +

    // buscar por la placa 
    "WHERE v.placa = ?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, placa);
            rs = ps.executeQuery();
            if (rs.next()) {
                data.put("Placa", rs.getString("placa"));
                data.put("Marca", rs.getString("marca"));
                data.put("Modelo", rs.getString("modelo"));
                data.put("Color", rs.getString("color"));
                data.put("Detalles", rs.getString("detalles"));
                data.put("FechaCompra", rs.getString("FechaCompra"));
                
                // SOAT
                data.put("FechaFinPagoSOAT", rs.getString("FechaFinPagoSOAT"));
                data.put("MontoPagoSOAT", rs.getDouble("MontoPagoSOAT"));
                data.put("FechaPagoSOAT", rs.getString("FechaPagoSOAT"));
                
                // Reevisión
                data.put("FechaRevFin", rs.getString("FechaRevFin"));
                
                //Combustible
                data.put("FechaPagoComb", rs.getString("FechaPagoComb"));
                data.put("Galones", rs.getDouble("Galones"));
                data.put("KMComb", rs.getInt("KMComb"));
                data.put("PrecioComb", rs.getDouble("PrecioComb"));
                
                // Motorpropiedades
                data.put("IdTipoMotor", rs.getString("IdTipoMotor"));
                data.put("IdTipoAceite", rs.getString("IdTipoAceite"));
                data.put("CantAceite", rs.getDouble("CantAceite"));
                
                // MantSuspension
                data.put("FechaCambioSus", rs.getString("FechaCambioSus"));
                data.put("KMSus", rs.getInt("KMSus"));
                data.put("PrecioSus", rs.getDouble("Precio")); 
                
                // MantMotor
                data.put("FechaMotor", rs.getString("FechaMotor"));
                data.put("Kilometraje", rs.getInt("Kilometraje"));
                data.put("PrecioMotor", rs.getDouble("Precio"));
                
                // MantfAceite
                data.put("FechaCambioFA", rs.getString("FechaCambioFA"));
                data.put("KMFA", rs.getInt("KMFA"));
                data.put("PrecioFAceite", rs.getDouble("PrecioFAceite"));
                
                // MantAceite
                data.put("FechaCambioAceite", rs.getString("FechaCambioAceite"));
                data.put("KMAceite", rs.getInt("KMAceite"));
                data.put("PrecioAceite", rs.getDouble("PrecioAceite"));
            } else {
                data.put("error", "No se encontró el vehículo con placa: " + placa);
            }
        } catch (Exception e) {
            e.printStackTrace();
            data.put("error", e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ex){}
            if (ps != null) try { ps.close(); } catch (SQLException ex){}
            if (con != null) try { con.close(); } catch (SQLException ex){}
        }
        String json = new Gson().toJson(data);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
