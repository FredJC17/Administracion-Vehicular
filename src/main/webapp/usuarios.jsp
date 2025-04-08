<%@page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.*" %>
<%
    String mensaje = "";
    String accionForm = request.getParameter("accion");
    if(accionForm != null) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://10.0.1.2:1433;databaseName=ManPreVehi;encrypt=true;trustServerCertificate=true";
            Connection conProc = DriverManager.getConnection(url, "pc1", "0969");
            
            if("agregarUsuario".equals(accionForm)) {
                String dni = request.getParameter("dni");
                String nombre = request.getParameter("nombreUsuario");
                String cargo = request.getParameter("cargo");
                String correo = request.getParameter("correoElectronico");
                String pass = request.getParameter("contraseña");
                String sqlAdd = "INSERT INTO Usuarios (DNI, NombreUsuario, Cargo, CorreoElectronico, Contraseña) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement psAdd = conProc.prepareStatement(sqlAdd);
                psAdd.setString(1, dni);
                psAdd.setString(2, nombre);
                psAdd.setString(3, cargo);
                psAdd.setString(4, correo);
                psAdd.setString(5, pass);
                int filas = psAdd.executeUpdate();
                if(filas > 0) {
                    mensaje = "Usuario agregado correctamente.";
                } else {
                    mensaje = "Error al agregar usuario.";
                }
                psAdd.close();
            } else if("editarUsuario".equals(accionForm)) {
                String dni = request.getParameter("dni");
                String nombre = request.getParameter("nombreUsuario");
                String cargo = request.getParameter("cargo");
                String correo = request.getParameter("correoElectronico");
                String pass = request.getParameter("contraseña");
                String sqlEdit = "UPDATE Usuarios SET NombreUsuario=?, Cargo=?, CorreoElectronico=?, Contraseña=? WHERE DNI=?";
                PreparedStatement psEdit = conProc.prepareStatement(sqlEdit);
                psEdit.setString(1, nombre);
                psEdit.setString(2, cargo);
                psEdit.setString(3, correo);
                psEdit.setString(4, pass);
                psEdit.setString(5, dni);
                int filas = psEdit.executeUpdate();
                if(filas > 0) {
                    mensaje = "Usuario actualizado correctamente.";
                } else {
                    mensaje = "Error al actualizar usuario.";
                }
                psEdit.close();
            } else if("eliminarUsuario".equals(accionForm)) {
                // Procesar la eliminación del usuario
                String dni = request.getParameter("dni");
                String sqlDel = "DELETE FROM Usuarios WHERE DNI = ?";
                PreparedStatement psDel = conProc.prepareStatement(sqlDel);
                psDel.setString(1, dni);
                int filas = psDel.executeUpdate();
                if(filas > 0) {
                    mensaje = "Usuario eliminado correctamente.";
                } else {
                    mensaje = "Error al eliminar usuario.";
                }
                psDel.close();
            }
            conProc.close();
        } catch(Exception e) {
            mensaje = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRUD de Usuarios</title>
    <style>
      /* Estilos generales */
      body {
        margin: 0; 
        padding: 0;
        font-family: Arial, sans-serif;
        background: #1f1f1f;
        color: #fff;
      }
      .sidebar {
        width: 220px;
        background: #333;
        height: 100vh;
        position: fixed;
        top: 0; left: 0;
        display: flex;
        flex-direction: column;
        padding-top: 1rem;
      }
      .sidebar a {
        color: #fff;
        text-decoration: none;
        padding: 12px 16px;
        transition: background 0.3s;
        cursor: pointer;
      }
      .sidebar a:hover {
        background: #444;
      }
      .content {
        margin-left: 220px;
        padding: 1rem;
      }
      h1, h2 {
        text-align: center;
        margin-bottom: 1rem;
      }
      .seccion { display: none; }
      .seccion.active { display: block; }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1rem;
      }
      th, td {
        border: 1px solid #555;
        padding: 8px;
        text-align: center;
      }
      th { background: #444; }
      button {
        cursor: pointer;
        background: #f7e479;
        border: none;
        padding: 6px 10px;
        margin: 0 3px;
        border-radius: 4px;
      }
      button:hover { background: #f2cd49; }
      a.button-link {
        display: inline-block;
        background: #f7e479;
        padding: 6px 10px;
        color: #000;
        text-decoration: none;
        border-radius: 4px;
      }
      a.button-link:hover { background: #f2cd49; }
      form {
        max-width: 400px;
        margin: 1rem auto;
        background: #2a2a2a;
        padding: 1rem;
        border-radius: 8px;
      }
      label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
      }
      input[type="text"],
      input[type="email"],
      input[type="password"],
      input[type="date"],
      input[type="number"] {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #444;
        border-radius: 4px;
        background: #111;
        color: #fff;
      }
      input:focus { outline: none; border-color: #f7e479; }
      button[type="submit"] { margin-top: 10px; width: 100%; }
      /* Estilo para el select de la sección editar */
      label[for="cargoEditar"] {
        display: block;
        margin-bottom: 5px;
        font-size: 1.2em;
        font-weight: bold;
        color: #f7e479;
      }
      .radio-container {
        --main-color: #f7e479;
        --main-color-opacity: #f7e4791c;
        --total-radio: 3;
        display: flex;
        flex-direction: column;
        position: relative;
        padding-left: 0.5rem;
        margin-top: 5px;
      }
      .radio-container input {
        cursor: pointer;
        appearance: none;
      }
      .radio-container .glider-container {
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        background: linear-gradient(
          0deg,
          rgba(0, 0, 0, 0) 0%,
          rgba(27, 27, 27, 1) 50%,
          rgba(0, 0, 0, 0) 100%
        );
        width: 1px;
      }
      .radio-container .glider-container .glider {
        position: relative;
        height: calc(100% / var(--total-radio));
        width: 100%;
        background: linear-gradient(
          0deg,
          rgba(0, 0, 0, 0) 0%,
          var(--main-color) 50%,
          rgba(0, 0, 0, 0) 100%
        );
        transition: transform 0.5s cubic-bezier(0.37, 1.95, 0.66, 0.56);
      }
      .radio-container .glider-container .glider::before {
        content: "";
        position: absolute;
        height: 60%;
        width: 300%;
        top: 50%;
        transform: translateY(-50%);
        background: var(--main-color);
        filter: blur(10px);
      }
      .radio-container .glider-container .glider::after {
        content: "";
        position: absolute;
        left: 0;
        height: 100%;
        width: 150px;
        background: linear-gradient(
          90deg,
          var(--main-color-opacity) 0%,
          rgba(0, 0, 0, 0) 100%
        );
      }
      .radio-container label {
        cursor: pointer;
        padding: 1rem;
        position: relative;
        color: #999;
        transition: all 0.3s ease-in-out;
      }
      .radio-container input:checked + label {
        color: var(--main-color);
      }
      .radio-container input:nth-of-type(1):checked ~ .glider-container .glider {
        transform: translateY(0);
      }
      .radio-container input:nth-of-type(2):checked ~ .glider-container .glider {
        transform: translateY(100%);
      }
      .radio-container input:nth-of-type(3):checked ~ .glider-container .glider {
        transform: translateY(200%);
      }
      label[for="cargoEditar"] {
    display: block;
    margin-bottom: 5px;
    font-size: 1.2em;
    font-weight: bold;
    color: #f7e479;
}

      select#cargoEditar {
        width: 100%;
        padding: 10px;
        border: 1px solid #444;
        border-radius: 4px;
        background: #111;
        color: #fff;
        font-size: 16px;
        transition: border-color 0.3s;
      }
      select#cargoEditar:focus {
        outline: none;
        border-color: #f7e479;
      }
    </style>
    <script>
      function mostrarSeccion(id) {
          document.querySelectorAll('.seccion').forEach(sec => sec.classList.remove('active'));
          document.getElementById(id).classList.add('active');
      }
      document.addEventListener('DOMContentLoaded', function() {
          mostrarSeccion('seccion-listar');
      });
    </script>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <a onclick="mostrarSeccion('seccion-listar')">Listar Usuarios</a>
        <a onclick="mostrarSeccion('seccion-agregar')">Agregar Usuario</a>
        <a onclick="mostrarSeccion('seccion-editar')">Editar Usuario</a>
        <a onclick="window.location.href='index.jsp'">Volver a Vehículos</a>
    </div>

    <!-- Contenido principal -->
    <div class="content">
        <h1>Administración de Usuarios</h1>
        <% if(!mensaje.isEmpty()) { %>
          <p style="color:yellow; text-align:center;"><%= mensaje %></p>
        <% } %>
        
        <!-- Sección Listar Usuarios -->
        <div id="seccion-listar" class="seccion active">
            <h2>Listado de Usuarios</h2>
            <table class="tabla-usuarios">
                <thead>
                    <tr>
                        <th>DNI</th>
                        <th>Nombre de Usuario</th>
                        <th>Cargo</th>
                        <th>Correo Electrónico</th>
                        <th>Contraseña</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Connection conList = null;
                    PreparedStatement psList = null;
                    ResultSet rsList = null;
                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        String url = "jdbc:sqlserver://10.0.1.2:1433;databaseName=ManPreVehi;encrypt=true;trustServerCertificate=true";
                        conList = DriverManager.getConnection(url, "pc1", "0969");
                        String sqlList = "SELECT DNI, NombreUsuario, Cargo, CorreoElectronico, Contraseña FROM Usuarios";
                        psList = conList.prepareStatement(sqlList);
                        rsList = psList.executeQuery();
                        boolean hayDatos = false;
                        while (rsList.next()) {
                            hayDatos = true;
                            String dni = rsList.getString("DNI");
                            String nombre = rsList.getString("NombreUsuario");
                            String cargo = rsList.getString("Cargo");
                            String correo = rsList.getString("CorreoElectronico");
                            String contrasena = rsList.getString("Contraseña");
                    %>
                    <tr>
                        <td><%= dni %></td>
                        <td><%= nombre %></td>
                        <td><%= cargo %></td>
                        <td><%= correo %></td>
                        <td>******</td>
                        <td>
                            <a class="button-link" href="javascript:cargarEditarUsuario('<%= dni %>', '<%= nombre %>', '<%= cargo %>', '<%= correo %>', '<%= contrasena %>')">Editar</a>
                            <a class="button-link" href="usuarios.jsp?accion=eliminarUsuario&dni=<%= dni %>" onclick="return confirm('¿Está seguro de eliminar este usuario?');">Eliminar</a>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hayDatos) {
                    %>
                    <tr>
                        <td colspan="6">No hay usuarios registrados.</td>
                    </tr>
                    <%
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        if (rsList != null) try { rsList.close(); } catch(Exception e){}
                        if (psList != null) try { psList.close(); } catch(Exception e){}
                        if (conList != null) try { conList.close(); } catch(Exception e){}
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <!-- Sección Agregar Usuario -->

        <div id="seccion-agregar" class="seccion">
            <h2>Agregar Usuario</h2>
            <form id="formAgregarUsuario" action="usuarios.jsp" method="post">
                <input type="hidden" name="accion" value="agregarUsuario"/>
                <label>DNI:</label>
                <input type="text" name="dni" required/>
                <label>Nombre de Usuario:</label>
                <input type="text" name="nombreUsuario" required/>
                <label>Cargo:</label>
                <div class="radio-container">
                    <input type="radio" name="cargo" id="cargo1" value="Empleado" checked>
                    <label for="cargo1">Empleado</label>
                    <input type="radio" name="cargo" id="cargo2" value="Administrador">
                    <label for="cargo2">Administrador</label>
                    <input type="radio" name="cargo" id="cargo3" value="Desarrollador">
                    <label for="cargo3">Desarrollador</label>
                    <div class="glider-container">
                        <div class="glider"></div>
                    </div>
                </div>
                <label>Correo Electrónico:</label>
                <input type="email" name="correoElectronico" required/>
                <label>Contraseña:</label>
                <input type="password" name="contraseña" required/>
                <button type="submit">Guardar</button>
            </form>
            <script>
              <% if("Usuario agregado correctamente.".equals(mensaje)) { %>
                  document.getElementById("formAgregarUsuario").reset();
              <% } %>
            </script>
        </div>
        
        <!-- Sección Editar Usuario -->
        <div id="seccion-editar" class="seccion">
            <h2>Editar Usuario</h2>
            <form action="usuarios.jsp" method="post">
                <input type="hidden" name="accion" value="editarUsuario"/>
                <label>DNI (No editable):</label>
                <input type="text" name="dni" id="dniEditar" readonly/>
                <label>Nombre de Usuario:</label>
                <input type="text" name="nombreUsuario" id="nombreEditar" required/>
                <label>Cargo:</label>
                <select name="cargo" id="cargoEditar">
                    <option value="Empleado">Empleado</option>
                    <option value="Administrador">Administrador</option>
                    <option value="Desarrollador">Desarrollador</option>
                </select>
                <label>Correo Electrónico:</label>
                <input type="email" name="correoElectronico" id="correoEditar" required/>
                <label>Contraseña:</label>
                <input type="password" name="contraseña" id="passEditar" required/>
                <button type="submit">Actualizar</button>
            </form>
        </div>
    </div>

    <script>
      function cargarEditarUsuario(dni, nombre, cargo, correo, pass) {
          document.getElementById('dniEditar').value = dni;
          document.getElementById('nombreEditar').value = nombre;
          document.getElementById('cargoEditar').value = cargo;
          document.getElementById('correoEditar').value = correo;
          document.getElementById('passEditar').value = pass;
          mostrarSeccion('seccion-editar');
      }
    </script>
</body>
</html>