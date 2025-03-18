package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/IngresoServlet")
public class IngresoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usuarioODNI = request.getParameter("usuarioODNI");
        String password = request.getParameter("password");
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT NombreUsuario, DNI, Cargo FROM Usuarios WHERE (NombreUsuario = ? OR DNI = ?) AND Contraseña = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuarioODNI);
            stmt.setString(2, usuarioODNI);
            stmt.setString(3, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String nombre = rs.getString("NombreUsuario");
                String dni = rs.getString("DNI");
                String cargo = rs.getString("Cargo");
                HttpSession session = request.getSession();
                session.setAttribute("nombreusuario", nombre);
                session.setAttribute("dni", dni);
                session.setAttribute("cargo", cargo);
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("ingreso.jsp?error=1");
            }
            conn.close();
        } catch (Exception e) {
            response.sendRedirect("ingreso.jsp?error=2");
        }
    }
}





