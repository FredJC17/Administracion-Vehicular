package com.mycompany.mantenimientovehicular;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditarCombustibleServlet")
public class EditarCombustibleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String idCombustible = request.getParameter("idCombustible");
        String galonesStr = request.getParameter("Galones");
        String precioCombStr = request.getParameter("PrecioComb");
        String fechaPagoComb = request.getParameter("FechaPagoComb");
        String tipoCombustible = request.getParameter("TipoCombustible");
        String kmCombStr = request.getParameter("KMComb");
        double galones = 0, precioComb = 0, kmComb = 0;
        try {
            galones = Double.parseDouble(galonesStr);
            precioComb = Double.parseDouble(precioCombStr);
            kmComb = Double.parseDouble(kmCombStr);
        } catch(NumberFormatException nfe) {
            response.getWriter().println("Error en la conversión de números: " + nfe.getMessage());
            return;
        }
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE Combustible SET Galones = ?, PrecioComb = ?, FechaPagoComb = ?, TipoCombustible = ?, KMComb = ? WHERE IdCombustible = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDouble(1, galones);
                ps.setDouble(2, precioComb);
                ps.setString(3, fechaPagoComb);
                ps.setString(4, tipoCombustible);
                ps.setDouble(5, kmComb);
                ps.setString(6, idCombustible);
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("index.jsp");
                } else {
                    response.getWriter().println("No se pudo actualizar el repostaje.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al actualizar repostaje: " + e.getMessage());
        }
    }
}
