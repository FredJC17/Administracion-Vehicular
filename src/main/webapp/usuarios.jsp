<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CRUD de Usuarios</title>
    <style>
      body {
        margin: 0; padding: 0;
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
      }
      th {
        background: #444;
      }
      button {
        cursor: pointer;
        background: #f7e479;
        border: none;
        padding: 6px 10px;
        margin: 0 3px;
        border-radius: 4px;
      }
      button:hover {
        background: #f2cd49;
      }
      a.button-link {
        display: inline-block;
        background: #f7e479;
        padding: 6px 10px;
        color: #000;
        text-decoration: none;
        border-radius: 4px;
      }
      a.button-link:hover {
        background: #f2cd49;
      }
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
      input[type="password"] {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #444;
        border-radius: 4px;
        background: #111;
        color: #fff;
      }
      input[type="text"]:focus,
      input[type="email"]:focus,
      input[type="password"]:focus {
        outline: none;
        border-color: #f7e479;
      }
      button[type="submit"] {
        margin-top: 10px;
        width: 100%;
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
    </style>
</head>
<body>

      <!-- Sidebar -->

<div class="sidebar">
  <a onclick="mostrarSeccion('seccion-listar')">Listar Usuarios</a>
  <a onclick="mostrarSeccion('seccion-agregar')">Agregar Usuario</a>
  <a onclick="mostrarSeccion('seccion-editar')">Editar Usuario</a>
  <a onclick="window.location.href='index.jsp'">Volver a Vehiculos</a>
</div>

      <!-- Contenido principal -->

<div class="content">
  <h1>Administración de Usuarios</h1>

      <!-- Sección Listar -->
  
  <div id="seccion-listar" class="seccion">
    <h2>Listado de Usuarios</h2>
    <table>
      <thead>
        <tr>
          <th>DNI</th>
          <th>Nombre</th>
          <th>Cargo</th>
          <th>Correo</th>
          <th>Contraseña</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody id="tablaUsuariosBody">
      </tbody>
    </table>
  </div>

  <!-- Sección Agregar -->
  
  <div id="seccion-agregar" class="seccion">
    <h2>Agregar Usuario</h2>
    <form action="UsuariosServlet" method="post" onsubmit="return validarAgregar()">
      <input type="hidden" name="accion" value="agregar"/>

      <label>DNI:</label>
      <input type="text" name="dni" id="dniAgregar" required/>

      <label>Nombre de Usuario:</label>
      <input type="text" name="nombreUsuario" id="nombreAgregar" required/>

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
      <input type="email" name="correoElectronico" id="correoAgregar" required/>

      <label>Contraseña:</label>
      <input type="password" name="contraseña" id="passAgregar" required/>

      <button type="submit">Guardar</button>
    </form>
  </div>

  <!-- Sección Editar -->
  
  <div id="seccion-editar" class="seccion">
    <h2>Editar Usuario</h2>
    <form action="UsuariosServlet" method="post" onsubmit="return validarEditar()">
      <input type="hidden" name="accion" value="editar"/>

      <label>DNI (No editable):</label>
      <input type="text" name="dni" id="dniEditar" readonly/>

      <label>Nombre de Usuario:</label>
      <input type="text" name="nombreUsuario" id="nombreEditar" required/>

      <label>Cargo:</label>
      <div class="radio-container">
        <input type="radio" name="cargo" id="cargoEdit1" value="Empleado">
        <label for="cargoEdit1">Empleado</label>

        <input type="radio" name="cargo" id="cargoEdit2" value="Administrador">
        <label for="cargoEdit2">Administrador</label>

        <input type="radio" name="cargo" id="cargoEdit3" value="Desarrollador">
        <label for="cargoEdit3">Desarrollador</label>

        <div class="glider-container">
          <div class="glider"></div>
        </div>
      </div>

      <label>Correo Electrónico:</label>
      <input type="email" name="correoElectronico" id="correoEditar" required/>

      <label>Contraseña:</label>
      <input type="password" name="contraseña" id="passEditar" required/>

      <button type="submit">Actualizar</button>
    </form>
  </div>

</div>

<script>
function mostrarSeccion(id) {
  document.querySelectorAll('.seccion').forEach(sec => sec.classList.remove('active'));
  document.getElementById(id).classList.add('active');

  if (id === 'seccion-listar') {
    listarUsuarios();
  }
}
function listarUsuarios() {
  fetch('UsuariosServlet?accion=listar')
    .then(resp => resp.json())
    .then(data => {
      const tbody = document.getElementById('tablaUsuariosBody');
      tbody.innerHTML = '';

      data.forEach(usuario => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${usuario.DNI}</td>
          <td>${usuario.NombreUsuario}</td>
          <td>${usuario.Cargo}</td>
          <td>${usuario.CorreoElectronico}</td>
          <td>${usuario.Contraseña}</td>
          <td>
            <button onclick="eliminarUsuario('${usuario.DNI}')">Eliminar</button>
            <button onclick="cargarEditar('${usuario.DNI}', '${usuario.NombreUsuario}', 
               '${usuario.Cargo}', '${usuario.CorreoElectronico}', '${usuario.Contraseña}')">
               Editar
            </button>
          </td>
        `;
        tbody.appendChild(tr);
      });
    })
    .catch(err => console.error(err));
}
function eliminarUsuario(dni) {
  if (!confirm('¿Seguro que deseas eliminar este usuario?')) return;
  window.location.href = 'UsuariosServlet?accion=eliminar&DNI=' + dni;
}
function cargarEditar(dni, nombre, cargo, correo, pass) {
  document.getElementById('dniEditar').value = dni;
  document.getElementById('nombreEditar').value = nombre;
  document.getElementById('correoEditar').value = correo;
  document.getElementById('passEditar').value = pass;
  if (cargo === 'Empleado') {
    document.getElementById('cargoEdit1').checked = true;
  } else if (cargo === 'Administrador') {
    document.getElementById('cargoEdit2').checked = true;
  } else if (cargo === 'Desarrollador') {
    document.getElementById('cargoEdit3').checked = true;
  }
  mostrarSeccion('seccion-editar');
}
function validarAgregar() {
  return true;
}
function validarEditar() {
  return true;
}
document.addEventListener('DOMContentLoaded', () => {
  mostrarSeccion('seccion-listar');
});
</script>
</body>
</html>
