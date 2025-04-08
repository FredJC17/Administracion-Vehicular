<%@page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.*" %>
<%
    String mensaje = "";
    String filtro = request.getParameter("filtro");
    if(filtro == null || filtro.trim().isEmpty()){
        filtro = "0";
    }
    String accionForm = request.getParameter("accion");
    if(accionForm != null) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://10.0.1.2:1433;databaseName=ManPreVehi;encrypt=true;trustServerCertificate=true";
            Connection conProc = DriverManager.getConnection(url, "pc1", "0969");

            if("agregarVehiculo".equals(accionForm)) {
                String placa = request.getParameter("placa");
                String marca = request.getParameter("marca");
                String modelo = request.getParameter("modelo");
                String color = request.getParameter("color");
                String detalles = request.getParameter("detalles");
                String fechaCompra = request.getParameter("fechaCompra");
                // Nuevo vehículo: Borrado=0
                String sqlAdd = "INSERT INTO Vehiculos (Placa, Marca, Modelo, Color, Detalles, FechaCompra, Borrado) VALUES (?, ?, ?, ?, ?, ?, 0)";
                PreparedStatement psAdd = conProc.prepareStatement(sqlAdd);
                psAdd.setString(1, placa);
                psAdd.setString(2, marca);
                psAdd.setString(3, modelo);
                psAdd.setString(4, color);
                psAdd.setString(5, detalles);
                psAdd.setString(6, fechaCompra);
                int filas = psAdd.executeUpdate();
                if(filas > 0) {
                    mensaje = "Vehículo agregado correctamente.";
                } else {
                    mensaje = "Error al agregar vehículo.";
                }
                psAdd.close();
            } else if("editarVehiculo".equals(accionForm)) {
                String placa = request.getParameter("placa");
                String marca = request.getParameter("marca");
                String modelo = request.getParameter("modelo");
                String color = request.getParameter("color");
                String detalles = request.getParameter("detalles");
                String fechaCompra = request.getParameter("fechaCompra");
                String sqlEdit = "UPDATE Vehiculos SET Marca=?, Modelo=?, Color=?, Detalles=?, FechaCompra=? WHERE Placa=? AND Borrado=0";
                PreparedStatement psEdit = conProc.prepareStatement(sqlEdit);
                psEdit.setString(1, marca);
                psEdit.setString(2, modelo);
                psEdit.setString(3, color);
                psEdit.setString(4, detalles);
                psEdit.setString(5, fechaCompra);
                psEdit.setString(6, placa);
                int filas = psEdit.executeUpdate();
                if(filas > 0) {
                    mensaje = "Vehículo actualizado correctamente.";
                } else {
                    mensaje = "Error al actualizar vehículo.";
                }
                psEdit.close();
            } else if("eliminarVehiculo".equals(accionForm)) {
                String placa = request.getParameter("placa");
                // Si el vehículo está activo (Borrado=0), lo marcamos como eliminado (Borrado=1)
                String sqlCheck = "SELECT Borrado FROM Vehiculos WHERE Placa = ?";
                PreparedStatement psCheck = conProc.prepareStatement(sqlCheck);
                psCheck.setString(1, placa);
                ResultSet rsCheck = psCheck.executeQuery();
                if(rsCheck.next()){
                    int borrado = rsCheck.getInt("Borrado");
                    rsCheck.close();
                    psCheck.close();
                    if(borrado == 0) {
                        String sqlMark = "UPDATE Vehiculos SET Borrado=1 WHERE Placa = ?";
                        PreparedStatement psMark = conProc.prepareStatement(sqlMark);
                        psMark.setString(1, placa);
                        int filasMark = psMark.executeUpdate();
                        psMark.close();
                        mensaje = (filasMark > 0) ? "Vehículo marcado como eliminado (Borrado=1)." : "Error al marcar vehículo como eliminado.";
                    } else {
                        String[] tablasRelacionadas = {"SOAT", "RevisionTecnica", "Combustible", "MantSuspension", "MantFAceite", "MantAceite", "MantMotor"};
                        for(String tabla : tablasRelacionadas) {
                            String sqlDeleteRel = "DELETE FROM " + tabla + " WHERE Placa = ?";
                            PreparedStatement psRel = conProc.prepareStatement(sqlDeleteRel);
                            psRel.setString(1, placa);
                            psRel.executeUpdate();
                            psRel.close();
                        }
                        String sqlDeleteVeh = "DELETE FROM Vehiculos WHERE Placa = ?";
                        PreparedStatement psDeleteVeh = conProc.prepareStatement(sqlDeleteVeh);
                        psDeleteVeh.setString(1, placa);
                        int filasVeh = psDeleteVeh.executeUpdate();
                        psDeleteVeh.close();
                        mensaje = (filasVeh > 0) ? "Vehículo eliminado permanentemente." : "Error al eliminar permanentemente el vehículo.";
                    }
                } else {
                    mensaje = "Vehículo no encontrado.";
                }
            } else if("redimirVehiculo".equals(accionForm)) {
                String placa = request.getParameter("placa");
                String sqlRedimir = "UPDATE Vehiculos SET Borrado=0 WHERE Placa = ?";
                PreparedStatement psRedimir = conProc.prepareStatement(sqlRedimir);
                psRedimir.setString(1, placa);
                int filasRedimir = psRedimir.executeUpdate();
                psRedimir.close();
                mensaje = (filasRedimir > 0) ? "Vehículo redimido correctamente." : "Error al redimir vehículo.";
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
    <title>CRUD de Vehículos</title>
    <style>
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
        top: 0;
        left: 0;
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
      input[type="date"] {
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
      select#filtro {
        width: 100%;
        padding: 10px;
        border: 1px solid #444;
        border-radius: 4px;
        background: #111;
        color: #fff;
        font-size: 16px;
        transition: border-color 0.3s;
      }
      select#filtro:focus {
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
    
    <!-- Sidebar   -->
    
    <div class="sidebar">
        <a onclick="mostrarSeccion('seccion-listar')">Listar Vehículos</a>
        <a onclick="mostrarSeccion('seccion-agregar')">Agregar Vehículo</a>
        <a onclick="mostrarSeccion('seccion-editar')">Editar Vehículo</a>
        <a onclick="window.location.href='index.jsp'">Volver a la Página Principal</a>
    </div>
    
    <!-- Cont principal -->
    
    <div class="content">
        <h1>Administración de Vehículos</h1>
        <% if(!mensaje.isEmpty()) { %>
          <p style="color:yellow; text-align:center;"><%= mensaje %></p>
        <% } %>
        
        <!-- Sección Listar Vehículos -->
        
        <div id="seccion-listar" class="seccion active">
            <h2>Listado de Vehículos</h2>
            <!-- Formulario para filtrar por Borrado -->
            <form method="get" action="vehiculos.jsp" style="text-align:center; margin-bottom:1rem;">
              <label for="filtro">Filtrar Vehículos (Borrado): </label>
              <select name="filtro" id="filtro" onchange="this.form.submit()">
                <option value="0" <%= ("0".equals(filtro)) ? "selected" : "" %>>Activos (0)</option>
                <option value="1" <%= ("1".equals(filtro)) ? "selected" : "" %>>Eliminados (1)</option>
              </select>
            </form>
            <table>
                <thead>
                    <tr>
                        <th>Placa</th>
                        <th>Marca</th>
                        <th>Modelo</th>
                        <th>Color</th>
                        <th>Detalles</th>
                        <th>Fecha de Compra</th>
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
                        String sqlList = "SELECT Placa, Marca, Modelo, Color, Detalles, FechaCompra FROM Vehiculos WHERE Borrado=?";
                        psList = conList.prepareStatement(sqlList);
                        psList.setString(1, filtro);
                        rsList = psList.executeQuery();
                        boolean hayDatos = false;
                        while (rsList.next()) {
                            hayDatos = true;
                            String placaDB = rsList.getString("Placa");
                            String marcaDB = rsList.getString("Marca");
                            String modeloDB = rsList.getString("Modelo");
                            String colorDB = rsList.getString("Color");
                            String detallesDB = rsList.getString("Detalles");
                            String fechaCompraDB = rsList.getString("FechaCompra");
                    %>
                    <tr>
                        <td><%= placaDB %></td>
                        <td><%= marcaDB %></td>
                        <td><%= modeloDB %></td>
                        <td><%= colorDB %></td>
                        <td><%= detallesDB %></td>
                        <td><%= fechaCompraDB %></td>
                        <td>
                            <% if("0".equals(filtro)) { %>
                                <a class="button-link" href="javascript:cargarEditarVehiculo('<%= placaDB %>', '<%= marcaDB %>', '<%= modeloDB %>', '<%= colorDB %>', '<%= detallesDB %>', '<%= fechaCompraDB %>')">Editar</a>
                                <a class="button-link" href="vehiculos.jsp?accion=eliminarVehiculo&placa=<%= placaDB %>" onclick="return confirm('¿Está seguro de eliminar este vehículo?');">Eliminar</a>
                            <% } else { %>
                                <a class="button-link" href="vehiculos.jsp?accion=redimirVehiculo&placa=<%= placaDB %>" onclick="return confirm('¿Deseas recuperar este vehículo?');">Recuperar</a>
                                <a class="button-link" href="vehiculos.jsp?accion=eliminarVehiculo&placa=<%= placaDB %>" onclick="return confirm('¿Está seguro de eliminar permanentemente este vehículo?');">Eliminar</a>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hayDatos) {
                    %>
                    <tr>
                        <td colspan="7">No hay vehículos registrados.</td>
                    </tr>
                    <%
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
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
        
        <!-- Sección Agregar Vehículo -->
        <div id="seccion-agregar" class="seccion">
            <h2>Agregar Vehículo</h2>
            <form id="formAgregarVehiculo" action="vehiculos.jsp" method="post">
                <input type="hidden" name="accion" value="agregarVehiculo"/>
                
                <label>Placa:</label>
                <input type="text" name="placa" required/>
                
                <label>Marca:</label>
                <input type="text" name="marca" required/>
                
                <label>Modelo:</label>
                <input type="text" name="modelo" required/>
                
                <label>Color:</label>
                <input type="text" name="color" required/>
                
                <label>Detalles:</label>
                <input type="text" name="detalles"/>
                
                <label>Fecha de Compra:</label>
                <input type="date" name="fechaCompra"/>
                
                <button type="submit">Guardar Vehículo</button>
            </form>
            <script>
              <% if("Vehículo agregado correctamente.".equals(mensaje)) { %>
                  document.getElementById("formAgregarVehiculo").reset();
              <% } %>
            </script>
        </div>
        
        <!-- Sección Editar Vehículo -->
        <div id="seccion-editar" class="seccion">
            <h2>Editar Vehículo</h2>
            <form action="vehiculos.jsp" method="post">
                <input type="hidden" name="accion" value="editarVehiculo"/>
                
                <label>Placa (No editable):</label>
                <input type="text" name="placa" id="placaEditar" readonly/>
                
                <label>Marca:</label>
                <input type="text" name="marca" id="marcaEditar" required/>
                
                <label>Modelo:</label>
                <input type="text" name="modelo" id="modeloEditar" required/>
                
                <label>Color:</label>
                <input type="text" name="color" id="colorEditar" required/>
                
                <label>Detalles:</label>
                <input type="text" name="detalles" id="detallesEditar"/>
                
                <label>Fecha de Compra:</label>
                <input type="date" name="fechaCompra" id="fechaCompraEditar"/>
                
                <button type="submit">Actualizar Vehículo</button>
            </form>
        </div>
    </div>

    <script>
      function cargarEditarVehiculo(placa, marca, modelo, color, detalles, fechaCompra) {
          document.getElementById('placaEditar').value = placa;
          document.getElementById('marcaEditar').value = marca;
          document.getElementById('modeloEditar').value = modelo;
          document.getElementById('colorEditar').value = color;
          document.getElementById('detallesEditar').value = detalles;
          document.getElementById('fechaCompraEditar').value = fechaCompra;
          mostrarSeccion('seccion-editar');
      }
    </script>
</body>
</html>
