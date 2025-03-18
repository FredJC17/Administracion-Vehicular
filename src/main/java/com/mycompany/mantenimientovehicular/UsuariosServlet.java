package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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
                listarUsuarios(response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            default:
                response.sendRedirect("usuarios.jsp");
        }
    }

    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect("usuarios.jsp");
            return;
        }
        switch (accion) {
            case "agregar":
                agregarUsuario(request, response);
                break;
            case "editar":
                editarUsuario(request, response);
                break;
            default:
                response.sendRedirect("usuarios.jsp");
        }
    }
    private void listarUsuarios(HttpServletResponse response) throws IOException {
    response.setContentType("application/json;charset=UTF-8");
    List<Map<String, String>> lista = new ArrayList<>();
    try (Connection con = ConexionDB.getConexion()) {
        String sql = "SELECT DNI, NombreUsuario, Cargo, CorreoElectronico, Contrasenia FROM Usuarios";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("DNI", rs.getString("DNI"));
            user.put("NombreUsuario", rs.getString("NombreUsuario"));
            user.put("Cargo", rs.getString("Cargo"));
            user.put("CorreoElectronico", rs.getString("CorreoElectronico"));
            user.put("Contrasenia", rs.getString("Contrasenia"));
            lista.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    String json = new Gson().toJson(lista);
    PrintWriter out = response.getWriter();
    out.write(json);
}

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String dni = request.getParameter("DNI");
        if (dni == null || dni.trim().isEmpty()) {
            response.sendRedirect("usuarios.jsp");
            return;
        }
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "DELETE FROM Usuarios WHERE DNI = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("usuarios.jsp");
    }

    private void agregarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String dni = request.getParameter("dni");
        String nombre = request.getParameter("nombreUsuario");
        String cargo = request.getParameter("cargo"); // <--- Recibimos cargo de radio
        String correo = request.getParameter("correoElectronico");
        String pass = request.getParameter("contraseña");
        if (dni == null || dni.isEmpty()) {
            response.sendRedirect("usuarios.jsp");
            return;
        }
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "INSERT INTO Usuarios (DNI, NombreUsuario, Cargo, CorreoElectronico, Contraseña) "
                       + "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            ps.setString(2, nombre);
            ps.setString(3, cargo);
            ps.setString(4, correo);
            ps.setString(5, pass);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("usuarios.jsp");
    }

    
    private void editarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String dni = request.getParameter("dni");
        String nombre = request.getParameter("nombreUsuario");
        String cargo = request.getParameter("cargo");
        String correo = request.getParameter("correoElectronico");
        String pass = request.getParameter("contraseña");
        if (dni == null || dni.isEmpty()) {
            response.sendRedirect("usuarios.jsp");
            return;
        }
        try (Connection con = ConexionDB.getConexion()) {
            String sql = "UPDATE Usuarios SET NombreUsuario=?, Cargo=?, CorreoElectronico=?, Contraseña=? "
                       + "WHERE DNI = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, cargo);
            ps.setString(3, correo);
            ps.setString(4, pass);
            ps.setString(5, dni);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("usuarios.jsp");
    }
}
