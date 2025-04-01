package com.mycompany.mantenimientovehicular;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/UsuariosServlet")
public class UsuariosServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect("usuarios.jsp");
            return;
        }
        switch (accion) {
            case "listar":
                listarUsuarios(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            default:
                response.sendRedirect("usuarios.jsp");
        }
    }
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("application/json;charset=UTF-8");
    List<Map<String, String>> lista = new ArrayList<>();
    try (Connection con = ConexionDB.getConexion()) {
        String sql = "SELECT DNI, NombreUsuario, Cargo, CorreoElectronico, Contraseña FROM Usuarios";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int contador = 0;
            while (rs.next()) {
                contador++;
                Map<String, String> user = new HashMap<>();
                user.put("dni", rs.getString("DNI"));
                user.put("nombre", rs.getString("NombreUsuario"));
                user.put("cargo", rs.getString("Cargo"));
                user.put("correo", rs.getString("CorreoElectronico"));
                user.put("contrasena", rs.getString("Contraseña"));
                lista.add(user);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener usuarios");
        return;
    }
    String json = new Gson().toJson(lista);
    response.getWriter().write(json);
}
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}