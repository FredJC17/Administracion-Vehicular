<%@page import="java.util.Map"%>
<%@page import="com.mycompany.mantenimientovehicular.ConexionDB"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=UTF-8" %> 
<%@ page session="true" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mantenimiento Preventivo Vehicular</title>
<style>
body {font-family: 'Arial', sans-serif;margin: 0;  padding: 0;background-color: #969696;color: #333;}
.header {display: flex;align-items: center; justify-content: space-between;background-color: #333;color: #fff; padding: 1rem; box-sizing: border-box; width: 100%;}
.header .Agregar a { color: #fff; text-decoration: none;font-size: 2rem;cursor: pointer;margin: 0;padding: 0;}
.header .Agregar e { color: #fff;text-decoration: none;font-size: 2rem;margin: 0;padding: 0;}
.header * { margin: 0;padding: 0;}
.close {position: absolute;top: 20px;right: 20px;color: #00e5ff;float: right; background: transparent;border: none; font-size: 35px; font-weight: bold;cursor: pointer;}
.close:hover,
.close:focus {color: black;text-decoration: none; cursor: pointer;}
.Agregar { padding-right: 10px;}
.Agregar a {text-decoration: none;color: white; font-weight: bold;left:20px;top: 25px;}
.Agregar a:hover {color: #00e5ff;}
#modal-agregar { position: fixed;top: 0;left: 0;width: 100%;height: 100%; background: rgba(0, 0, 0, 0.5);display: none;justify-content: center;align-items: center; z-index: 1;}
.cards-container {display: flex;flex-wrap: wrap; gap: 35px;justify-content: center; margin: 1rem; align-items: flex-start;}
.card_ {display: inline-block;vertical-align: top;width: 250px; height: 320px;background: linear-gradient(163deg, #0ef 0%, #0ef 100%); border-radius: 20px;transition: all 0.3s;cursor: pointer; box-shadow: 0 0 10px rgba(0,0,0,0.2);position: relative;}
.card_2 {width: 250px; height: 320px;background-color: #1a1a1a; border-radius: 20px; transition: all 0.2s; overflow: hidden;display: flex;flex-direction: column;align-items: center;justify-content: center;color: #fff;text-align: center;}
.card_:hover { box-shadow: 0px 0px 30px 1px rgba(0, 255, 117, 0.3);}
.card_2:hover {transform: scale(0.96);border-radius: 20px;}
.card_2 h3 {margin: 0.5rem 0;}
.card_2 p {margin: 0.2rem 0;}
@media screen and (max-width: 600px) {
.card_ {width: 80%;height: auto;}
.card_2 {width: 100%; height: auto;}}
.card {position: relative;background-color: #202020;border: 1px solid #888;border-radius: 8px;box-shadow: 0px 0px 10px rgba(0,0,0,0.2);width: 100%; max-width: 1200px;   min-width: 400px;    margin: 1rem auto;  padding: 2rem 1rem; box-sizing: border-box;text-align: center;max-height: 90vh;   overflow-y: auto;}
.card::-webkit-scrollbar {width: 8px;}
.card::-webkit-scrollbar-track {background: #333;border-radius: 4px;}
.card::-webkit-scrollbar-thumb {background-color: #666;border-radius: 4px;}
.card h2 {color: #fff;margin-bottom: 1rem;text-align: center;}
.form-control {position: relative; margin: 20px 0 40px;width: 100%; }
.form-control input { background-color: transparent; border: 0; border-bottom: 2px #fff solid;display: block; width: 100%;  padding: 15px 0;  font-size: 18px; color: #fff;}
.form-control input:focus,
.form-control input:valid { outline: 0;border-bottom-color: #00e5ff; }
.form-control label {position: absolute;top: 15px;left: 0;pointer-events: none;}
.form-control label span { display: inline-block;font-size: 18px; min-width: 5px;color: #fff;transition: 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);}
.form-control input:focus + label span,
.form-control input:valid + label span {color: #00e5ff;transform: translateY(-30px);}
.form-control textarea:focus + label span,
.form-control textarea:valid + label span {color: #00e5ff;transform: translateY(-30px);}
.enter {padding: 10px 20px;text-transform: uppercase;border-radius: 8px;font-size: 17px;font-weight: 500; color: #ffffff80; background: transparent;cursor: pointer; border: 1px solid #ffffff80;transition: 0.5s ease;user-select: none;}
.enter:hover,
.enter:focus {color: #ffffff;background: #0ef;border: 1px solid #0ef;text-shadow: 0 0 5px #ffffff, 0 0 10px #ffffff, 0 0 20px #ffffff;box-shadow: 0 0 5px #0ef, 0 0 20px #0ef, 0 0 50px #0ef, 0 0 100px #0ef;scale: 1.1;}
.enter:active {transform: scale(0.8);}
#mostrarSidebar {padding: 10px 20px;background-color: #4CAF50; color: white;border: none;cursor: pointer; margin: 20px;}
#mostrarSidebar:hover {background-color: #45a049;}
.modal { display: none;position: fixed;top: 0;left: 0; width: 100%; height: 100%;background-color: rgba(0, 0, 0, 0.5);justify-content: center;align-items: center; z-index: 1000;}
.modal-contenido { background-color: #969696;padding: 20px;border-radius: 10px;width: 80%; max-width: 800px;height: 80%;  max-height: 600px;box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3); position: relative;display: flex;flex-direction: column;}
.contenedor-ventana {display: flex; flex: 1;overflow: hidden;}
.sidebar { width: 200px;background-color: #1a1a1a; padding: 20px;overflow-y: auto; }
.sidebar a {padding: 10px 15px;text-decoration: none;font-size: 16px;color: white;display: block;transition: background-color 0.3s;}
.sidebar a:hover {background-color: #969696;}
.contenido-ventana {flex: 1;padding: 20px;overflow-y: auto;background-color: #969696;border-left: 1px solid #1a1a1a;}
.btn-revision {position: relative;overflow: hidden;height: 3rem;padding: 0 2rem;border-radius: 1.5rem;background: #1a1a1a;background-size: 400%;color: #fff;border: none;cursor: pointer;}
.btn-revision:hover::before {transform: scaleX(1);}
.button-content { position: relative;z-index: 1;}
.btn-revision::before {content: "";position: absolute; top: 0; left: 0;transform: scaleX(0);transform-origin: 0 50%; width: 100%;height: inherit;border-radius: inherit;background: linear-gradient(82.3deg,#0ef 10.8%,rgba(14, 239, 255, 0.7) 94.3% );transition: all 0.475s;}
.modal-advertencia {display: none;  position: fixed; z-index: 100000;top: 50%; left: 50%;transform: translate(-50%, -50%);width: 90%;max-width: 750px;background-color: #222; color: #fff;border-radius: 10px;padding: 20px;text-align: center;transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;opacity: 0;}
.modal-advertencia-content { padding: 15px;font-size: 18px; word-wrap: break-word; overflow-wrap: break-word;max-height: 400px;overflow-y: auto;box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); }
.modal-advertencia .close {position: absolute;top: 15px; right: 20px; font-size: 40px;cursor: pointer; color: #ff5e5e;transition: color 0.3s ease;}
.modal-advertencia .close:hover { color: #ff2a2a;}
.btn-cerrar { background-color: #ff5e5e; border: none;color: white;padding: 10px 20px; margin-top: 10px;font-size: 16px; border-radius: 5px;cursor: pointer;transition: background-color 0.3s ease;}
.btn-cerrar:hover {background-color: #ff2a2a;}
.modal-advertencia.show { opacity: 1;transform: translate(-50%, -50%) scale(1);}
.modal-advertencia.hide {opacity: 0;transform: translate(-50%, -50%) scale(0.8);}
.card-vencida {display: inline-block;vertical-align: top; width: 250px; height: 320px;background: linear-gradient(163deg, #f66 0%, #f33 100%);border-radius: 20px;transition: all 0.3s;cursor: pointer; box-shadow: 0 0 10px rgba(0,0,0,0.2);position: relative;}
.card-vencida .card_2 {width: 250px;height: 320px;background-color: #590c0c;border-radius: 20px;transition: all 0.2s;overflow: hidden;display: flex;flex-direction: column;align-items: center;justify-content: center; color: #fff;text-align: center;}
.card-vencida:hover {box-shadow: 0px 0px 30px 1px rgba(255, 0, 0, 0.3);}
.card-vencida .card_2:hover { transform: scale(0.96);border-radius: 20px;}
@media screen and (max-width: 600px) {.card-vencida {width: 80%; height: auto;}
.card-vencida .card_2 {width: 100%;height: auto;}}
.sign {width: 100%; transition-duration: 0.3s;display: flex;align-items: center;justify-content: center;}
.sign svg { width: 24px;}
.sign svg path {fill: white;}
.text { position: absolute;right: 0%;  width: 0%; opacity: 0; color: white;font-size: 1.2em;font-weight: 600; transition-duration: 0.3s;}
.btn-salir {display: flex;align-items: center;justify-content: center;padding: 10px 20px;background-color: #ff3636;border: none;border-radius: 5px;cursor: pointer;color: white;font-size: 16px;font-weight: 600;transition: background-color 0.3s ease;margin: 0;box-sizing: border-box;}
.btn-salir .icon {display: flex;align-items: center;margin-right: 8px;}
.btn-salir .icon svg {width: 20px;height: 20px;}
.btn-salir:hover {background-color: #cc2a2a;}
.btn-cont {display: flex;justify-content: center;align-items: center;flex-wrap: wrap;gap: 10px;padding: 10px;}
.btn-admin {cursor: pointer;position: relative;padding: 10px 24px;font-size: 18px;color: rgb(255, 65, 65);border: 2px solid rgb(255, 65, 65); border-radius: 34px; background-color: #202020; font-weight: 600;transition: all 0.3s cubic-bezier(0.23, 1, 0.320, 1);overflow: hidden;text-align: center;display: inline-block; white-space: nowrap;min-width: 120px;}
.btn-admin::before {content: ''; position: absolute;inset: 0;margin: auto;width: 50px;height: 50px; border-radius: inherit; scale: 0;z-index: -1;background-color: rgb(255, 65, 65);transition: all 0.6s cubic-bezier(0.23, 1, 0.320, 1);}
.btn-admin:hover::before {scale: 3;}
.btn-admin:hover {color: #212121; scale: 1.1; box-shadow: 0 0px 20px rgba(193, 163, 98,0.4);}
.btn-admin:active {scale: 1;}
.input-admin, .select-admin { font-size: 18px;padding: 10px 20px; border: 2px solid rgb(255,65,65);border-radius: 34px;background-color: #202020;color: rgb(255, 65, 65);font-weight: 600;transition: all 0.3s cubic-bezier(0.23, 1, 0.320, 1); min-width: 120px;outline: none; margin-right: 5px;}
.input-admin::placeholder {color: rgba(255,65,65,0.5);}
.input-admin:focus,
.select-admin:focus { border-color: #fff;}
</style>
</head>
<body>
<%
  String cargo = (String) session.getAttribute("cargo");
  if (cargo == null) {
    response.sendRedirect("ingreso.jsp");
    return;
  }
%>
<script>
  // Variable global para usar en JS
  var usuarioCargo = '<%= cargo %>';
  console.log("Cargo del usuario: " + usuarioCargo);
</script>

    <!-- Modal de Advertencia de "SOAT" y "Rev. Técnica"  -->
    
<div id="modal-advertencia" class="modal-advertencia">
    <div class="modal-advertencia-content">
        <span class="close" onclick="cerrarModal()">&times;</span>
        <h3>Advertencias</h3>
        <div id="contenidoAdvertencias"></div>
        <button class="btn-cerrar" onclick="cerrarModal()">Cerrar</button>
    </div>
</div>
    
    <!-- titulo -->
    
<div class="header">
   <div class="Agregar">
<% if (!cargo.equals("Empleado")) { %>
    <a onclick="AgregarVehiculo()">Mantenimiento Preventivo Vehicular</a>
<% } else { %>
    <e style="font-weight: bold;">Mantenimiento Preventivo Vehicular</e>
<% } %>
</div>

  <button class="btn-salir" onclick="window.location.href='CerrarServlet'">
  <span class="icon">
    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
      <polyline points="16 17 21 12 16 7"></polyline>
      <line x1="21" y1="12" x2="9" y2="12"></line>
    </svg>
  </span>
</button>
</div>

    <div class="btn-cont">
        
  <!-- Grupo Ordenar.. -->
  
  <div>
    <select class="select-admin" id="selectOrdenar">
      <option value="Orden-alfabetico">Ordenar</option>
      <option value="soat-proximo">SOAT proximo</option>
      <option value="soat-lejano">SOAT lejano</option>
      <option value="revision-proxima">Revision proxima</option>
      <option value="revision-lejana">Revision lejana</option>
      <option value="vehiculo-antiguo">Vehiculo antiguo</option>
      <option value="vehiculo-nuevo">Vehiculo nuevo</option>
    </select>
    <button class="btn-admin" onclick="ordenar()">ORDENAR</button>
  </div>
  
<% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
  <button class="btn-admin" onclick="window.location.href='vehiculos.jsp'">VEHICULOS</button>
<% } %>

  <!--  Buscar.. -->
  
  <div>
    <input type="text" class="input-admin" id="inputBuscar" placeholder="Escribe placa...">
    <button class="btn-admin" onclick="buscar()">BUSCAR</button>
  </div>
  
  <!-- boton de usuario...  -->
  
<% if (cargo.equals("Desarrollador")) { %>
  <button class="btn-admin" onclick="window.location.href='usuarios.jsp'">USUARIOS</button>
<% } %>
</div>

<!-- Formularo para Agregar Vehiculos -->
    
    <div id="modal-agregar">
  <form action="AgregarVehiculoServlet" method="post">
    <div class="card">
      <span class="close" onclick="cerrarModalAgregar()">&times;</span>
      <h2>Agregar Vehículo</h2>
      <div class="form-control">
        <input type="text" name="placa" required>
        <label>
          <span style="transition-delay:0ms">P</span>
          <span style="transition-delay:50ms">l</span>
          <span style="transition-delay:100ms">a</span>
          <span style="transition-delay:150ms">c</span>
          <span style="transition-delay:200ms">a</span>
        </label>
      </div>
      <div class="form-control">
        <input type="text" name="marca" required>
        <label>
          <span style="transition-delay:0ms">M</span>
          <span style="transition-delay:50ms">a</span>
          <span style="transition-delay:100ms">r</span>
          <span style="transition-delay:150ms">c</span>
          <span style="transition-delay:200ms">a</span>
        </label>
      </div>
      <div class="form-control">
        <input type="text" name="modelo" required>
        <label>
          <span style="transition-delay:0ms">M</span>
          <span style="transition-delay:50ms">o</span>
          <span style="transition-delay:100ms">d</span>
          <span style="transition-delay:150ms">e</span>
          <span style="transition-delay:200ms">l</span>
          <span style="transition-delay:250ms">o</span>
        </label>
      </div>
      <div class="form-control">
        <input type="text" name="color" required>
        <label>
          <span style="transition-delay:0ms">C</span>
          <span style="transition-delay:50ms">o</span>
          <span style="transition-delay:100ms">l</span>
          <span style="transition-delay:150ms">o</span>
          <span style="transition-delay:200ms">r</span>
        </label>
      </div>
      <div class="form-control">
        <input type="text" name="detalles" required>
        <label>
          <span style="transition-delay:0ms">D</span>
          <span style="transition-delay:50ms">e</span>
          <span style="transition-delay:100ms">t</span>
          <span style="transition-delay:150ms">a</span>
          <span style="transition-delay:200ms">l</span>
          <span style="transition-delay:250ms">l</span>
          <span style="transition-delay:300ms">e</span>
          <span style="transition-delay:350ms">s</span>
        </label>
      </div>
      <div class="form-control">
        <input type="date" name="fechaCompra">
        <label>
          <span style="transition-delay:0ms">F</span>
          <span style="transition-delay:50ms">e</span>
          <span style="transition-delay:100ms">c</span>
          <span style="transition-delay:150ms">h</span>
          <span style="transition-delay:200ms">a</span>
          <span style="transition-delay:250ms"> </span>
          <span style="transition-delay:300ms">d</span>
          <span style="transition-delay:350ms">e</span>
          <span style="transition-delay:400ms"> </span>
          <span style="transition-delay:450ms">C</span>
          <span style="transition-delay:500ms">o</span>
          <span style="transition-delay:550ms">m</span>
          <span style="transition-delay:600ms">p</span>
          <span style="transition-delay:650ms">r</span>
          <span style="transition-delay:700ms">a</span>
        </label>
      </div>
      <button type="submit" class="enter">Guardar</button>
    </div>
  </form>
</div>
    
    <!-- Cards para los carros  -->
    
<div class="cards-container" id="vehiculos-container"></div>

    <!-- Sidebar al presionar los vehiculos  -->
    
<div id="ventanaModal" class="modal" style="display:none;">
  <div class="modal-contenido">
    <span class="close" onclick="cerrarVentana()">&times;</span>
    <div class="contenedor-ventana">
      <div id="Propiedades" class="sidebar">
        <a onclick="mostrarDetalles()">Detalles</a>
        <a onclick="mostrarRevision()">Revisión Técnica</a>
        <a onclick="mostrarSOAT()">SOAT</a>
        <a onclick="mostrarMantenimientoAceite()">Mantenimiento de Aceite</a>
        <a onclick="mostrarMantenimientoFAceite()">Mantenimiento de Filtro de Aceite</a>
        <a onclick="mostrarMantenimientoSuspension()">Mantenimiento de Suspensión</a>
        <a onclick="mostrarMantenimientoMotor()">Mantenimiento de Motor</a>
        <a onclick="mostrarRepostaje()">Repostaje de Combustible</a>
        <a onclick="mostrarObservaciones()">Observaciones</a>
        <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
        <a onclick="mostrarBorrar()">Borrar Vehiculo</a>
        <% } %>
      </div>
      <div id="contenido-ventana" class="contenido-ventana">
        <h1 id="titulo-seccion"></h1>
        
        <!-- Seccion de los detalles del vehiculo, no modifica los datos -->
        
<div id="seccion-detalles" class="seccion" action ="BDServlet">
            <h1>Detalles</h1>
            
            <div class ="form-control">
            <input type="text" name="placa" id="detallesPlaca" >
            <label>
            <span>Placa</span>
            </label>
            </div>
            
            <div class="form-control">
            <input type="text" name="marca" id="detallesMarca">
            <label>
            <span>Marca</span>
            </label>
            </div>
            
            <div class="form-control">
            <input type="text" name="modelo" id="detallesModelo">
            <label>
            <span>Modelo</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="text" name="color" id="detallesColor" >
            <label>
            <span>Color</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="text" name="detalles" id="detallesInfo" >
            <label>
            <span>Detalles</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaCompra" id="detallesfechaCompra" >
            <label>
            <span>Fecha de Compra</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaFinPago" id="detallesfechaFinPago" >
            <label>
            <span>Fecha Fin de Pago SOAT</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="number" step="any" name="montoPagoSOAT" id="detallesmontoPagoSOAT" >
            <label>
            <span>Monto Pago SOAT</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaRevFin" id="detallesfechaRevFin" >
            <label>
            <span>Última Fecha Revisión</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaPagoComb" id="detallesfechaPagoComb" >
            <label>
            <span>Última Fecha de Pago Combustible</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaCambioSus" id="detallesfechaCambioSus" >
            <label>
            <span>Último Cambio Suspensión</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaMotor" id="detallesfechaMotor" >
            <label>
            <span>Fecha Motor</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaCambioFA" id="detallesfechaCambioFA" >
            <label>
            <span>Último Cambio Filtro de Aceite</span>
            </label>
            </div>
    
            <div class="form-control">
            <input type="date" name="fechaCambioAceite" id="detallesfechaCambioAceite" >
            <label>
            <span>Último Cambio Aceite</span>
            </label>
            </div>
            </div>
        
        <!-- Seccion de revision para los vehiculos -->
        
<div id="seccion-revision" class="seccion" style="display:none;">
  <h1>Revisiones</h1>
  <div id="contenedorRevisiones"></div>
  <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
  <button onclick="agregarRevision()" type="button" class="enter">AGREGAR</button>
<% } %>
  <div id="modalAgregarRevision" class="modal" style="display:none;">
    <form id="formAgregarRevision" action="AgregarRevisionServlet"
          method="post" enctype="multipart/form-data">
      <div class="modal-contenido">
        <span class="close" onclick="cerrarModalAgregarRevision()">&times;</span>
        <input type="hidden" id="placaRevision" name="placa" value="">
        <div class="form-control">
          <input type="date" name="fechaRev">
          <label><span>Fecha de Revisión</span></label>
        </div>
        <div class="form-control">
          <input type="file" name="comprobanteRT" accept=".pdf,image/*">
          <label><span>Comprobante de Revisión Técnica</span></label>
        </div>
        <button type="submit" class="enter">Agregar Revisión</button>
      </div>
    </form>
  </div>
</div>
        <div id="modalEditarRevision" class="modal" style="display:none;">
  <div class="modal-contenido">
    <span class="close" onclick="cerrarModalEditarRevision()">&times;</span>
    <form action="EditarRevisionServlet" method="post" enctype="multipart/form-data">
      <!-- Campo oculto para el ID de la revisión -->
      <input type="hidden" name="idRevision" id="idRevisionEditar">
      <div class="form-control">
         <input type="date" name="FechaRev" id="fechaRevEditar" required>
         <label><span>Fecha de Revisión</span></label>
      </div>
      <div class="form-control">
         <input type="file" name="comprobanteRT" id="comprobanteRTEditar" accept=".pdf,image/*">
         <label><span>Comprobante de Revisión Técnica</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Revisión</button>
    </form>
  </div>
</div>

        <!-- seccion-SOAT administracion del "SOAT" del vehiculo seleccionado -->

<div id="seccion-SOAT" class="seccion" style="display:none;">
          <h1>SOAT</h1>
          <div id="contenedorSOAT"></div>
          <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
          <button type="button" class="enter" onclick="agregarSOAT()">AGREGAR</button>
          <% } %>
          <div id="modalAgregarSOAT" class="modal" style="display:none">
          <form id="formAgregarSOAT" action="AgregarSoatServlet" 
                 method="post" enctype="multipart/form-data">
        <div class="modal-contenido">
          <span class="close" onclick="cerrarModalAgregarSOAT()">&times;</span>
          <input type="hidden" name="placa" value="" id="placaSoat">
        <div class="form-control">
            <input type="date" name="FechaPagoSOAT" >
            <label>
            <span>Fecha de Inicio</span>
            </label>
        </div>
        <div class="form-control">
            <input type="number" name="MontoPagoSOAT" step="any" accept=".pdf,image/*">
            <label>
            <span>Monto de Pago</span>
            </label>
        </div>
        <div class="form-control">
            <input type="file" name="ComprobanteSOAT" accept=".pdf,image/*">
            <label>
            <span>Comprobante SOAT</span>
            </label>
        </div>
           <button type="submit" class="enter">Agregar SOAT</button>
             </div>
            </form>  
           </div>
          </div>
          <div id="modalEditarSoat" class="modal" style="display:none;">
  <div class="modal-contenido"> 
    <span class="close" onclick="cerrarModalEditarSoat()">&times;</span>
    <form action="EditarSoatServlet" method="post" enctype="multipart/form-data">
      <input type="hidden" name="idSoat" id="idSoatEditar">
      <div class="form-control">
         <input type="date" name="FechaPagoSOAT" id="fechaSoatEditar" required>
         <label><span>Fecha de Pago SOAT</span></label>
      </div>
      <div class="form-control">
         <input type="file" name="ComprobanteSOAT" id="comprobanteSoatEditar" accept=".pdf,image/*">
         <label><span>Comprobante SOAT</span></label>
      </div>
      <div class="form-control">
         <input type="number" step="any" name="MontoPagoSOAT" id="montoSoatEditar" required>
         <label><span>Monto Pago SOAT</span></label>
      </div>
      <button type="submit" class="enter">Actualizar SOAT</button>
    </form>
  </div>
</div>

        <!-- Seccion-Aceite para administrar los aceites -->
        
<div id="seccion-aceite" class="seccion" style="display:none;">
            <h1>Mantenimiento de Aceite</h1>
         <div id="contenedorAceite"></div>
         <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
          <button type="button" class="enter" onclick="agregarMantenimientoAceite()">AGREGAR</button>
          <% } %>
         <div id="modalAgregarMantenimientoAceite" class="modal" style="display:none;">
           <form action="AgregarMantenimientoAceiteServlet" method="post">
         <div class="modal-contenido">
           <span class="close" onclick="cerrarModalAgregarMantenimientoAceite()">&times;</span>
         <input type="hidden" name="placa" id="placaMantenimientoAceite">
        <div class="form-control">
           <input type="number" step="any" name="PrecioAceite" required>
           <label><span>Precio Aceite</span></label>
        </div>
        <div class="form-control">
          <input type="number" step="any" name="CantAceite" required>
          <label><span>Cantidad de Aceite</span></label>
        </div>
        <div class="form-control">
          <input type="date" name="FechaCambioAceite" >
          <label><span>Fecha Cambio Aceite</span></label>
        </div>
        <div class="form-control">
          <input type="number" name="KMAceite" required>
          <label><span>KM Aceite</span></label>
        </div>
           <button type="submit" class="enter">Agregar Mantenimiento</button>
             </div>
           </form>
         </div>
      </div>
         <div id="modalEditarAceite" class="modal" style="display:none;">
  <div class="modal-contenido">
    <span class="close" onclick="cerrarModalEditarAceite()">&times;</span>
    <form action="EditarMantAceiteServlet" method="post">
      <input type="hidden" name="idMantAceite" id="idMantAceiteEditar">
      <div class="form-control">
         <input type="number" step="any" name="PrecioAceite" id="precioAceiteEditar" required>
         <label><span>Precio Aceite</span></label>
      </div>
      <div class="form-control">
         <input type="number" step="any" name="CantAceite" id="cantAceiteEditar" required>
         <label><span>Cantidad de Aceite</span></label>
      </div>
      <div class="form-control">
         <input type="date" name="FechaCambioAceite" id="fechaCambioAceiteEditar" required>
         <label><span>Fecha Cambio Aceite</span></label>
      </div>
      <div class="form-control">
         <input type="number" name="KMAceite" id="kmAceiteEditar" required>
         <label><span>KM Aceite</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Mantenimiento Aceite</button>
    </form>
  </div>
</div>

        <!-- seccion-filtro administra el filtro de aceite del vehiculo seelcionado -->
        
<div id="seccion-filtro" class="seccion" style="display:none;">
           <h1>Mantenimiento de Filtro de Aceite</h1>
          <div id="contenedorFiltro"></div>
          <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
           <button type="button" class="enter" onclick="agregarMantenimientoFiltro()">AGREGAR</button>
          <% } %>
          </div>
          <div id="modalAgregarMantenimientoFAceite" class="modal" style="display:none;">
              <form action="AgregarMantFAceiteServlet" method="post">
          <div class="modal-contenido">
            <span class="close" onclick="cerrarModalAgregarMantenimientoFAceite()">&times;</span>
            <input type="hidden" name="placa" id="placaMantenimientoFAceite">
          <div class="form-control">
            <input type="number" step="any" name="PrecioFAceite" required>
            <label><span>Precio Filtro Aceite</span></label>
          </div>
          <div class="form-control">
            <input type="date" name="FechaCambioFA" >
            <label><span>Fecha Cambio Filtro Aceite</span></label>
          </div>
          <div class="form-control">
            <input type="number" name="KMFA" required>
            <label><span>KM Filtro Aceite</span></label>
          </div>
            <button type="submit" class="enter">Agregar Mantenimiento Filtro</button>
              </div>
            </form>
          </div>
          <div id="modalEditarFAceite" class="modal" style="display:none;">
  <div class="modal-contenido">
    <span class="close" onclick="cerrarModalEditarFAceite()">&times;</span>
    <form action="EditarMantFAceiteServlet" method="post">
      <input type="hidden" name="idMantFAceite" id="idMantFAceiteEditar">
      <div class="form-control">
         <input type="number" step="any" name="PrecioFAceite" id="precioFAceiteEditar" required>
         <label><span>Precio Filtro Aceite</span></label>
      </div>
      <div class="form-control">
         <input type="date" name="FechaCambioFA" id="fechaCambioFAEditar">
         <label><span>Fecha Cambio Filtro Aceite</span></label>
      </div>
      <div class="form-control">
         <input type="number" name="KMFA" id="kmFAEditar" required>
         <label><span>KM Filtro Aceite</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Mantenimiento Filtro Aceite</button>
    </form>
  </div>
</div>
    
        <!--  seccion-suspension esta administra la suspension del vehiculo -->
         
<div id="seccion-suspension" class="seccion" style="display:none;">
          <h1>Mantenimiento de Suspensión</h1>
         <div id="contenedorSuspension"></div>
         <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
           <button type="button" class="enter" onclick="agregarMantenimientoSuspension()">AGREGAR</button>
          <% } %>
         </div>
         <div id="modalAgregarMantenimientoSuspension" class="modal" style="display:none;">
            <form action="AgregarMantSuspensionServlet" method="post">
            <div class="modal-contenido">
            <span class="close" onclick="cerrarModalAgregarMantenimientoSuspension()">&times;</span>
            <input type="hidden" name="placa" id="placaMantenimientoSuspension">
        <div class="form-control">
           <input type="number" step="any" name="Precio" required>
           <label><span>Precio</span></label>
         </div>
         <div class="form-control">
          <input type="date" name="FechaCambioSus" >
          <label><span>Fecha Cambio Suspensión</span></label>
        </div>
       <div class="form-control">
        <input type="number" name="KMSus" required>
        <label><span>KM Suspensión</span></label>
       </div>
              <button type="submit" class="enter">Agregar Mantenimiento Suspensión</button>
           </div>
         </form>
      </div>
          <div id="modalEditarSuspension" class="modal" style="display:none;">
       <form action="EditarMantSuspensionServlet" method="post">
         <div class="modal-contenido">
             <span class="close" onclick="cerrarModalEditarSuspension()">&times;</span>
        <input type="hidden" name="idMantSuspension" id="idMantSuspensionEditar">
        <input type="hidden" name="placa" id="placaSuspensionEditar">
      <div class="form-control">
         <input type="number" step="any" name="Precio" id="precioSuspensionEditar" required>
         <label><span>Precio</span></label>
      </div>
      <div class="form-control">
         <input type="date" name="FechaCambioSus" id="fechaSuspensionEditar" required>
         <label><span>Fecha Cambio Suspensión</span></label>
      </div>
      <div class="form-control">
         <input type="number" name="KMSus" id="kmSuspensionEditar" required>
         <label><span>KM Suspensión</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Mantenimiento Suspensión</button>
    </div>
  </form>
</div>
        
        <!-- seccion-motor administra el mantenimiento del motor -->
        
<div id="seccion-motor" class="seccion" style="display:none;">
           <h1>Mantenimiento de Motor</h1>
           <div id="contenedorMotor"></div>
           <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
           <button type="button" class="enter" onclick="agregarMantenimientoMotor()">AGREGAR</button>
          <% } %>
           </div>
           <div id="modalAgregarMantenimientoMotor" class="modal" style="display:none;">
           <form action="AgregarMantMotorServlet" method="post">
        <div class="modal-contenido">
           <span class="close" onclick="cerrarModalAgregarMantenimientoMotor()">&times;</span>
           <input type="hidden" name="placa" id="placaMantenimientoMotor">
        <div class="form-control">
           <input type="number" step="any" name="Precio" required>
           <label><span>Precio</span></label>
       </div>
       <div class="form-control">
           <input type="date" name="FechaMotor" >
           <label><span>Fecha Motor</span></label>
       </div>
       <div class="form-control">
           <input type="number" name="Kilometraje" required>
           <label><span>Kilometraje</span></label>
       </div>
       <button type="submit" class="enter">Agregar Mantenimiento Motor</button>
                </div>
             </form>
          </div>
                   
       <div id="modalEditarMantenimientoMotor" class="modal" style="display:none;">
  <form action="EditarMantMotorServlet" method="post">
    <div class="modal-contenido">
      <span class="close" onclick="cerrarModalEditarMantenimientoMotor()">&times;</span>
      <input type="hidden" name="idMantMotor" id="idMantMotorEditar">
      <input type="hidden" name="placa" id="placaMantenimientoMotorEditar">
      <div class="form-control">
         <input type="number" step="any" name="Precio" id="precioMantenimientoMotorEditar" required>
         <label><span>Precio</span></label>
      </div>
      <div class="form-control">
         <input type="date" name="FechaMotor" id="fechaMantenimientoMotorEditar">
         <label><span>Fecha Motor</span></label>
      </div>
      <div class="form-control">
         <input type="number" name="Kilometraje" id="kilometrajeMantenimientoMotorEditar" required>
         <label><span>Kilometraje</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Mantenimiento Motor</button>
    </div>
  </form>
</div>

        <!-- seccion-repostaje administra el repostaje al vehiculo -->

<div id="seccion-repostaje" class="seccion" style="display:none;">
          <h1>Repostaje de Combustible</h1>
          <div id="contenedorRepostaje"></div>
          <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
          <button type="button" class="enter" onclick="agregarCombustible()">AGREGAR</button>
          <% } %>
          </div>
        <div id="modalAgregarCombustible" class="modal" style="display:none;">
        <div class="modal-contenido">
           <span class="close" onclick="cerrarModalAgregarCombustible()">&times;</span>
           <form action="AgregarCombustibleServlet" method="post">
           <input type="hidden" name="placa" id="placaCombustible">
        <div class="form-control">
           <input type="number" step="any" name="Galones" required>
           <label><span>Galones</span></label>
      </div>
      <div class="form-control">
           <input type="number" step="any" name="PrecioComb" required>
           <label><span>Precio Combustible</span></label>
      </div>
      <div class="form-control">
           <input type="date" name="FechaPagoComb" >
           <label><span>Fecha Pago Combustible</span></label>
      </div>
      <div class="form-control">
          <select name="TipoCombustible" required>
            <option value="">-- Seleccionar Tipo de Combustible --</option>
            <option value="Diesel">Diesel</option>
            <option value="Gas Licuado de Petroleo">Gas Licuado de Petroleo</option>
            <option value="Gasolina">Gasolina</option>
          </select>
         <label><span>Tipo de Combustible</span></label>
       </div>
       <div class="form-control">
          <input type="number" name="KMComb" required>
          <label><span>KM Comb</span></label>
       </div>
          <button type="submit" class="enter">Agregar Repostaje</button>
              </form>
            </div>
        </div>
        <div id="modalEditarCombustible" class="modal" style="display:none;">
         <div class="modal-contenido">
         <span class="close" onclick="cerrarModalEditarCombustible()">&times;</span>
         <form action="EditarCombustibleServlet" method="post">
        <input type="hidden" name="idCombustible" id="idCombustibleEditar">
        <div class="form-control">
         <input type="number" step="any" name="Galones" id="galonesEditar" required>
         <label><span>Galones</span></label>
       </div>
       <div class="form-control">
         <input type="number" step="any" name="PrecioComb" id="precioCombEditar" required>
         <label><span>Precio Combustible</span></label>
       </div>
       <div class="form-control">
         <input type="date" name="FechaPagoComb" id="fechaPagoCombEditar">
         <label><span>Fecha Pago Combustible</span></label>
        </div>
        <div class="form-control">
         <select name="TipoCombustible" id="tipoCombustibleEditar" required>
            <option value="">-- Seleccionar Tipo de Combustible --</option>
            <option value="Diesel">Diesel</option>
            <option value="Gas Licuado de Petroleo">Gas Licuado de Petroleo</option>
            <option value="Gasolina">Gasolina</option>
         </select>
         <label><span>Tipo de Combustible</span></label>
        </div>
        <div class="form-control">
         <input type="number" name="KMComb" id="kmCombEditar" required>
         <label><span>KM Comb</span></label>
      </div>
      <button type="submit" class="enter">Actualizar Repostaje</button>
    </form>
  </div>
</div>

        <!-- seccion-observaciones aqui se pueden adjuntar observaciones del vehiculo -->
    
<div id="seccion-observaciones" class="seccion" style="display:none;">
          <h1>Observaciones</h1>
         <div id="contenedorObservaciones"></div>
         <% if (cargo.equals("Administrador") || cargo.equals("Desarrollador")) { %>
          <button type="button" class="enter" onclick="agregarObservacion()">AGREGAR</button>
          <% } %>
         <div id="modalAgregarObservacion" class="modal" style="display:none;">
           <form id="formAgregarObservacion" action="AgregarObservacionServlet" method="post">
         <div class="modal-contenido">
            <span class="close" onclick="cerrarModalAgregarObservacion()">&times;</span>
            <input type="hidden" name="placa" id="placaObservacion">
         <div>
            <label >Comentario: </label>
            <textarea name="comentario" id="comentario"></textarea>
         </div>
                <button type="submit" class="enter">Agregar Observación</button>
         </div>
                  </form>
                </div>
             </div>
                  </div>
              </div>
           </div>
       </div>
         <div id="modalEditarObservacion" class="modal" style="display:none;">
  <div class="modal-contenido">
    <span class="close" onclick="cerrarModalEditarObservacion()">&times;</span>
    <h2>Editar Observación</h2>
    <form action="EditarObservacionServlet" method="post">
      <!-- Campo oculto para el ID de la observación -->
      <input type="hidden" name="idObservacion" id="idObservacionEditar">
      
      <div class="form-control">
         <textarea name="comentario" id="comentarioEditar" required></textarea>
         <label><span>Comentario</span></label>
      </div>
      
      <button type="submit" class="enter">Actualizar Observación</button>
    </form>
  </div>
</div>
<div id="modalConfirmarBorrar" class="modal" style="display:none;">
  <div class="modal-contenido" style="max-width: 400px;">
    <span class="close" onclick="cerrarModalConfirmarBorrar()">&times;</span>
    <h2>¿Seguro que deseas borrar este vehículo?</h2>
    <div style="margin-top: 1rem;">
      <button class="btn-admin" onclick="borrarVehiculo()">Sí, borrar</button>
      <button class="btn-admin" onclick="cerrarModalConfirmarBorrar()">Cancelar</button>
    </div>
  </div>
</div>
<script>
  let placaActual = "";
  let vehiculoData = null;
  
function mostrarAdvertencias() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "AdvertenciasMantenimientoServlet", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var advertencias = xhr.responseText.trim(); 
            if (advertencias) {
                document.getElementById('contenidoAdvertencias').innerHTML = "<pre>" + advertencias + "</pre>";
                let modal = document.getElementById('modal-advertencia');
                modal.style.display = 'block';
                setTimeout(() => {
                    modal.classList.add('show');
                    modal.classList.remove('hide');
                }, 10);
            } else {
                alert("No hay advertencias de mantenimiento.");
            }
        }
    };
    xhr.send();
}
function cerrarModal() {
    let modal = document.getElementById("modal-advertencia");
    modal.classList.add("hide");
    modal.classList.remove("show");
    setTimeout(() => {
        modal.style.display = "none";
    }, 500);
}
window.onload = mostrarAdvertencias;
document.addEventListener("DOMContentLoaded", function() {
    fetch("VehiculosServlet")
        .then(response => response.text())
        .then(data => {
            document.getElementById("vehiculos-container").innerHTML = data;
        })
        .catch(error => console.error("Error al cargar los vehículos:", error));
});
function ordenar() {
  const criterio = document.getElementById("selectOrdenar").value;
  fetch("OrdenarServlet?criterio=" + encodeURIComponent(criterio))
    .then(resp => resp.text())
    .then(html => {
      document.getElementById("vehiculos-container").innerHTML = html;
    })
    .catch(err => console.error("Error al ordenar:", err));
}
function buscar() {
  const placa = document.getElementById("inputBuscar").value.trim();
  fetch("BuscarServlet?placa=" + encodeURIComponent(placa))
    .then(resp => resp.text())
    .then(html => {
      document.getElementById("vehiculos-container").innerHTML = html;
    })
    .catch(err => console.error("Error al buscar:", err));
}
function ocultarSecciones() {
    const secciones = document.getElementsByClassName("seccion");
    for (let i = 0; i < secciones.length; i++) {
      secciones[i].style.display = "none";
   }
 }
function mostrarVentana(placa) {
    placaActual = placa;
    document.getElementById("ventanaModal").style.display = "flex";
    mostrarDetalles();
    if (!placaActual) {
      console.error("La placa global no está definida.");
      return;
    }
    ocultarSecciones();
    document.getElementById("seccion-detalles").style.display = "block";
    if (vehiculoData && vehiculoData.Placa === placaActual) {
      actualizarFormularioVentana(vehiculoData);
    } else {
    fetch('BDServlet?accion=obtenerDatosDeVehiculos&placa=' + encodeURIComponent(placaActual))
      .then(response => {
        if (!response.ok) {
          throw new Error('Error en la respuesta del servidor');
        }
        return response.json();
      })
    .then(data => {
    vehiculoData = data;
    actualizarFormularioVentana(data);
    })
    .catch(error => {
    console.error('Error al obtener los detalles del vehículo:', error);
    });
   }
  }
function actualizarFormularioVentana(data){
    document.getElementById('ventanaPlaca').value = data.Placa || "";
  }
function mostrarDetalles() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-detalles").style.display = "block";
    fetch('BDServlet?accion=obtenerDatosDeVehiculos&placa=' + encodeURIComponent(placaActual))
    .then(response => {
     if (!response.ok) {
      throw new Error('Error en la respuesta del servidor');
    }
      return response.json();
    })
    .then(data => {
    if (data.error) {
      console.error(data.error);
      return;
    }
    document.getElementById('detallesPlaca').value = data.Placa || "";
    document.getElementById('detallesMarca').value = data.Marca || "";
    document.getElementById('detallesModelo').value = data.Modelo || "";
    document.getElementById('detallesColor').value = data.Color || "";
    document.getElementById('detallesInfo').value = data.Detalles || "";
    document.getElementById('detallesfechaCompra').value = data.FechaCompra || "";
    document.getElementById('detallesfechaFinPago').value = data.FechaFinPagoSOAT || "";
    document.getElementById('detallesmontoPagoSOAT').value = data.MontoPagoSOAT || "";
    document.getElementById('detallesfechaRevFin').value = data.FechaRevFin || "";
    document.getElementById('detallesfechaPagoComb').value = data.FechaPagoComb || "";
    document.getElementById('detallesfechaCambioSus').value = data.FechaCambioSus || "";
    document.getElementById('detallesfechaMotor').value = data.FechaMotor || "";
    document.getElementById('detallesfechaCambioFA').value = data.FechaCambioFA || "";
    document.getElementById('detallesfechaCambioAceite').value = data.FechaCambioAceite || "";
    })
    .catch(error => {
      console.error('Error al obtener detalles del vehículo:', error);
    });
}
function cerrarVentana() {
    document.getElementById("ventanaModal").style.display = "none";
  }
function mostrarRevision() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-revision").style.display = "block";
    fetch('BDRevisionServlet?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioRevision(data);
      document.getElementById("seccion-revision").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener las revisiones:', error);
    });
}
function actualizarFormularioRevision(listaRevisiones) {
  const contenedor = document.getElementById("contenedorRevisiones");
  contenedor.innerHTML = "";
  listaRevisiones.forEach(revision => {
    const divRevision = document.createElement("div");
    divRevision.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idRev = (revision.IdRevision !== undefined) ? revision.IdRevision : "N/A";
    btnContent.textContent = "Revisión " + idRev;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divRevision.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pFechaRev = document.createElement("p");
    pFechaRev.textContent = "Fecha de Revisión: " + (revision.FechaRev !== undefined ? revision.FechaRev : "N/A");
    divContenido.appendChild(pFechaRev);
    const pFechaRevFin = document.createElement("p");
    pFechaRevFin.textContent = "Fecha Revisión Fin: " + (revision.FechaRevFin !== undefined ? revision.FechaRevFin : "N/A");
    divContenido.appendChild(pFechaRevFin);
    const pComprobante = document.createElement("p");
    if (idRev !== "N/A") {
      pComprobante.innerHTML = "Comprobante: <a href='DownloadComprobanteServlet?id=" 
                                + idRev + "' target='_blank'>Descargar</a>";
    } else {
      pComprobante.textContent = "Comprobante: N/A";
    }
    divContenido.appendChild(pComprobante);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
      const btnEditar = document.createElement("button");
      btnEditar.textContent = "Editar Revisión";
      btnEditar.className = "btn-revision";
      btnEditar.style.marginTop = "0.5rem";
      btnEditar.onclick = function() {
        editarRevision(revision);
      };
      divContenido.appendChild(btnEditar);
    }
    divRevision.appendChild(divContenido);
    contenedor.appendChild(divRevision);
  });
}
function editarRevision(revision) {
  document.getElementById("idRevisionEditar").value = revision.IdRevision || "";
  document.getElementById("fechaRevEditar").value = revision.FechaRev || "";
  document.getElementById("modalEditarRevision").style.display = "flex";
}
function cerrarModalEditarRevision() {
  document.getElementById("modalEditarRevision").style.display = "none";
}
function agregarRevision() {
    document.getElementById("placaRevision").value = placaActual;
    document.getElementById('modalAgregarRevision').style.display = "flex";
}
function  cerrarModalAgregarRevision(){
    document.getElementById('modalAgregarRevision').style.display="none";
  }
function mostrarSOAT() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
}
    ocultarSecciones();
    document.getElementById("seccion-SOAT").style.display = "block";
    fetch('BDSoatServlet?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioSOAT(data);
      document.getElementById("seccion-SOAT").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener los SOAT:', error);
    });
}
function actualizarFormularioSOAT(listaSoat) {
  const contenedor = document.getElementById("contenedorSOAT");
  contenedor.innerHTML = "";
  listaSoat.forEach(soat => {
    const divSoat = document.createElement("div");
    divSoat.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idSoat = (soat.IdSOAT !== undefined) ? soat.IdSOAT : "N/A";
    btnContent.textContent = "SOAT " + idSoat;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divSoat.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pFechaPago = document.createElement("p");
    pFechaPago.textContent = "Fecha Pago SOAT: " + (soat.FechaPagoSOAT !== undefined ? soat.FechaPagoSOAT : "N/A");
    divContenido.appendChild(pFechaPago);
    const pFechaFin = document.createElement("p");
    pFechaFin.textContent = "Fecha Fin Pago SOAT: " + (soat.FechaFinPagoSOAT !== undefined ? soat.FechaFinPagoSOAT : "N/A");
    divContenido.appendChild(pFechaFin);
    const pMonto = document.createElement("p");
    pMonto.textContent = "Monto Pago SOAT: " + (soat.MontoPagoSOAT !== undefined ? soat.MontoPagoSOAT : "N/A");
    divContenido.appendChild(pMonto);
    const pComprobante = document.createElement("p");
    if (idSoat !== "N/A") {
      pComprobante.innerHTML = "Comprobante: <a href='DownloadSoatServlet?id=" + idSoat + "' target='_blank'>Descargar</a>";
    } else {
      pComprobante.textContent = "Comprobante: N/A";
    }
    divContenido.appendChild(pComprobante);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar SOAT";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarSoat(soat);
    };
    divContenido.appendChild(btnEditar);
  }
    divSoat.appendChild(divContenido);
    contenedor.appendChild(divSoat);
  });
}
function editarSoat(soat) {
  document.getElementById("idSoatEditar").value = soat.IdSOAT || "";
  document.getElementById("fechaSoatEditar").value = soat.FechaPagoSOAT || "";
  document.getElementById("montoSoatEditar").value = soat.MontoPagoSOAT || "";
  document.getElementById("modalEditarSoat").style.display = "flex";
}
function cerrarModalEditarSoat() {
  document.getElementById("modalEditarSoat").style.display = "none";
}
function agregarSOAT() {
  document.getElementById("placaSoat").value = placaActual;
  document.getElementById("modalAgregarSOAT").style.display = "flex";
}
function cerrarModalAgregarSOAT() {
    document.getElementById("modalAgregarSOAT").style.display = "none";
}
function mostrarMantenimientos() {
    ocultarSecciones();
    document.getElementById("seccion-mantenimientos").style.display = "block";
}
function mostrarComprobantes() {
    ocultarSecciones();
    document.getElementById("seccion-comprobantes").style.display = "block";
}
function mostrarEstadisticas() {
    ocultarSecciones();
    document.getElementById("seccion-estadisticas").style.display = "block";
}
function mostrarObservaciones() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-observaciones").style.display = "block";
    fetch('BDObservacionesServlet?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioObservaciones(data);
      document.getElementById("seccion-observaciones").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener las observaciones:', error);
    });
}
function actualizarFormularioObservaciones(listaObs) {
  const contenedor = document.getElementById("contenedorObservaciones");
  contenedor.innerHTML = "";
  listaObs.forEach(obs => {
    const divObs = document.createElement("div");
    divObs.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idObs = (obs.id !== undefined) ? obs.id : "N/A";
    btnContent.textContent = "Observación " + idObs;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divObs.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pComentario = document.createElement("p");
    pComentario.textContent = "Comentario: " + (obs.comentario !== undefined ? obs.comentario : "N/A");
    divContenido.appendChild(pComentario);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Observación";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarObservacion(obs);
    };
    divContenido.appendChild(btnEditar);
    }
    divObs.appendChild(divContenido);
    contenedor.appendChild(divObs);
  });
}
function editarObservacion(obs) {
  document.getElementById("idObservacionEditar").value = obs.id || "";
  document.getElementById("comentarioEditar").value = obs.comentario || "";
  document.getElementById("modalEditarObservacion").style.display = "flex";
}

function cerrarModalEditarObservacion() {
  document.getElementById("modalEditarObservacion").style.display = "none";
}
function agregarObservacion() {
    document.getElementById("placaObservacion").value = placaActual;
    document.getElementById("modalAgregarObservacion").style.display = "flex";
}
function cerrarModalAgregarObservacion() {
    document.getElementById("modalAgregarObservacion").style.display = "none";
}
function mostrarMantenimientoAceite() {
    if (!placaActual) {
    console.error("La placa no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-aceite").style.display = "block";
    fetch('BDMantAceite?placa=' + encodeURIComponent(placaActual))
    .then(response => response.json())
    .then(data => {
      actualizarFormularioMantenimientoAceite(data);
    })
    .catch(error => {
      console.error('Error al obtener Mantenimientos de Aceite:', error);
    });
}
function actualizarFormularioMantenimientoAceite(listaAceite) {
  const contenedor = document.getElementById("contenedorAceite");
  contenedor.innerHTML = "";
  listaAceite.forEach(mant => {
    const divAceite = document.createElement("div");
    divAceite.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idAceite = (mant.IdMantAceite !== undefined) ? mant.IdMantAceite : "N/A";
    btnContent.textContent = "Mantenimiento Aceite " + idAceite;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divAceite.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pPrecio = document.createElement("p");
    pPrecio.textContent = "Precio Aceite: " + (mant.PrecioAceite !== undefined ? mant.PrecioAceite : "N/A");
    divContenido.appendChild(pPrecio);
    const pCant = document.createElement("p");
    pCant.textContent = "Cantidad Aceite: " + (mant.CantAceite !== undefined ? mant.CantAceite : "N/A");
    divContenido.appendChild(pCant);
    const pFecha = document.createElement("p");
    pFecha.textContent = "Fecha Cambio Aceite: " + (mant.FechaCambioAceite !== undefined ? mant.FechaCambioAceite : "N/A");
    divContenido.appendChild(pFecha);
   const pKM = document.createElement("p");
    pKM.textContent = "KM Aceite: " + (mant.KMAceite !== undefined ? mant.KMAceite : "N/A");
    divContenido.appendChild(pKM);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Mantenimiento Aceite";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarMantenimientoAceite(mant);
    };
    divContenido.appendChild(btnEditar);
    }
    divAceite.appendChild(divContenido);
    contenedor.appendChild(divAceite);
  });
}
function editarMantenimientoAceite(mant) {
  document.getElementById("idMantAceiteEditar").value = mant.IdMantAceite || "";
  document.getElementById("precioAceiteEditar").value = mant.PrecioAceite || "";
  document.getElementById("cantAceiteEditar").value = mant.CantAceite || "";
  document.getElementById("fechaCambioAceiteEditar").value = mant.FechaCambioAceite || "";
  document.getElementById("kmAceiteEditar").value = mant.KMAceite || "";
  document.getElementById("modalEditarAceite").style.display = "flex";
}
function cerrarModalEditarAceite() {
  document.getElementById("modalEditarAceite").style.display = "none";
}
function agregarMantenimientoAceite() {
    document.getElementById("placaMantenimientoAceite").value = placaActual;
    document.getElementById("modalAgregarMantenimientoAceite").style.display = "flex";
}
function cerrarModalAgregarMantenimientoAceite() {
    document.getElementById("modalAgregarMantenimientoAceite").style.display = "none";
}
function mostrarMantenimientoFAceite() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-filtro").style.display = "block";
    fetch('BDMantFAceite?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioMantenimientoFAceite(data);
      document.getElementById("seccion-filtro").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener el mantenimiento de filtro de aceite:', error);
    });
}
function actualizarFormularioMantenimientoFAceite(listaFA) {
  const contenedor = document.getElementById("contenedorFiltro");
  contenedor.innerHTML = "";
  listaFA.forEach(mant => {
    const divFA = document.createElement("div");
    divFA.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idFA = (mant.IdMantFAceite !== undefined) ? mant.IdMantFAceite : "N/A";
    btnContent.textContent = "Mantenimiento Filtro Aceite " + idFA;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function () {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divFA.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pPrecio = document.createElement("p");
    pPrecio.textContent = "Precio Filtro Aceite: " + (mant.PrecioFAceite || "N/A");
    divContenido.appendChild(pPrecio);
    const pFecha = document.createElement("p");
    pFecha.textContent = "Fecha Cambio FA: " + (mant.FechaCambioFA || "N/A");
    divContenido.appendChild(pFecha);
    const pKM = document.createElement("p");
    pKM.textContent = "KM FA: " + (mant.KMFA || "N/A");
    divContenido.appendChild(pKM);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Mantenimiento Filtro Aceite";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function () {
      editarMantenimientoFAceite(mant);
    };
    divContenido.appendChild(btnEditar);
    }
    divFA.appendChild(divContenido);
    contenedor.appendChild(divFA);
  });
}
function editarMantenimientoFAceite(mant) {
  document.getElementById("idMantFAceiteEditar").value = mant.IdMantFAceite || "";
  document.getElementById("precioFAceiteEditar").value = mant.PrecioFAceite || "";
  document.getElementById("fechaCambioFAEditar").value = mant.FechaCambioFA || "";
  document.getElementById("kmFAEditar").value = mant.KMFA || "";
  document.getElementById("modalEditarFAceite").style.display = "flex";
}
function cerrarModalEditarFAceite() {
  document.getElementById("modalEditarFAceite").style.display = "none";
}
function agregarMantenimientoFiltro() {
    document.getElementById("placaMantenimientoFAceite").value = placaActual;
    document.getElementById("modalAgregarMantenimientoFAceite").style.display = "flex";
}
function cerrarModalAgregarMantenimientoFAceite() {
    document.getElementById("modalAgregarMantenimientoFAceite").style.display = "none";
}
function mostrarMantenimientoSuspension() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-suspension").style.display = "block";
    fetch('BDMantSuspension?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioMantenimientoSuspension(data);
      document.getElementById("seccion-suspension").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener el mantenimiento de suspensión:', error);
    });
}
function actualizarFormularioMantenimientoSuspension(listaSus) {
  const contenedor = document.getElementById("contenedorSuspension");
  contenedor.innerHTML = "";
  listaSus.forEach(mant => {
    const divSus = document.createElement("div");
    divSus.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idSus = (mant.IdMantSuspension !== undefined) ? mant.IdMantSuspension : "N/A";
    btnContent.textContent = "Mantenimiento Suspensión " + idSus;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divSus.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pPrecio = document.createElement("p");
    pPrecio.textContent = "Precio: " + (mant.Precio || "N/A");
    divContenido.appendChild(pPrecio);
    const pFecha = document.createElement("p");
    pFecha.textContent = "Fecha Cambio Suspensión: " + (mant.FechaCambioSus || "N/A");
    divContenido.appendChild(pFecha);
    const pKM = document.createElement("p");
    pKM.textContent = "KM Suspensión: " + (mant.KMSus || "N/A");
    divContenido.appendChild(pKM);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Mantenimiento Suspensión";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarMantenimientoSuspension(mant);
    };
    divContenido.appendChild(btnEditar);
    }
    divSus.appendChild(divContenido);
    contenedor.appendChild(divSus);
  });
}
function editarMantenimientoSuspension(mant) {
  document.getElementById("idMantSuspensionEditar").value = mant.IdMantSuspension || "";
  document.getElementById("placaSuspensionEditar").value = mant.Placa || "";
  document.getElementById("precioSuspensionEditar").value = mant.Precio || "";
  document.getElementById("fechaSuspensionEditar").value = mant.FechaCambioSus || "";
  document.getElementById("kmSuspensionEditar").value = mant.KMSus || "";
  document.getElementById("modalEditarSuspension").style.display = "flex";
}
function cerrarModalEditarSuspension() {
  document.getElementById("modalEditarSuspension").style.display = "none";
}
function agregarMantenimientoSuspension() {
    document.getElementById("placaMantenimientoSuspension").value = placaActual;
    document.getElementById("modalAgregarMantenimientoSuspension").style.display = "flex";
}
function cerrarModalAgregarMantenimientoSuspension() {
    document.getElementById("modalAgregarMantenimientoSuspension").style.display = "none";
}
function mostrarMantenimientoMotor() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-motor").style.display = "block";
    fetch('BDMantMotor?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioMantenimientoMotor(data);
      document.getElementById("seccion-motor").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener el mantenimiento de motor:', error);
    });
}
function actualizarFormularioMantenimientoMotor(listaMotor) {
  const contenedor = document.getElementById("contenedorMotor");
  contenedor.innerHTML = "";
  listaMotor.forEach(mant => {
    const divMotor = document.createElement("div");
    divMotor.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idMotor = (mant.IdMantMotor !== undefined) ? mant.IdMantMotor : "N/A";
    btnContent.textContent = "Mantenimiento Motor " + idMotor;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divMotor.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pPrecio = document.createElement("p");
    pPrecio.textContent = "Precio: " + (mant.Precio || "N/A");
    divContenido.appendChild(pPrecio);
    const pFecha = document.createElement("p");
    pFecha.textContent = "Fecha Motor: " + (mant.FechaMotor || "N/A");
    divContenido.appendChild(pFecha);
    const pKM = document.createElement("p");
    pKM.textContent = "Kilometraje: " + (mant.Kilometraje || "N/A");
    divContenido.appendChild(pKM);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Mantenimiento Motor";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarMantenimientoMotor(mant);
    };
    divContenido.appendChild(btnEditar);
    }
    divMotor.appendChild(divContenido);
    contenedor.appendChild(divMotor);
  });
}
 function editarMantenimientoMotor(mant) {
      document.getElementById("idMantMotorEditar").value = mant.IdMantMotor || "";
      document.getElementById("placaMantenimientoMotorEditar").value = mant.Placa || "";
      document.getElementById("precioMantenimientoMotorEditar").value = mant.Precio || "";
      document.getElementById("fechaMantenimientoMotorEditar").value = mant.FechaMotor || "";
      document.getElementById("kilometrajeMantenimientoMotorEditar").value = mant.Kilometraje || "";
      document.getElementById("modalEditarMantenimientoMotor").style.display = "flex";
}
function cerrarModalEditarMantenimientoMotor() {
      document.getElementById("modalEditarMantenimientoMotor").style.display = "none";
}
function agregarMantenimientoMotor() {
    document.getElementById("placaMantenimientoMotor").value = placaActual;
    document.getElementById("modalAgregarMantenimientoMotor").style.display = "flex";
}
function cerrarModalAgregarMantenimientoMotor() {
    document.getElementById("modalAgregarMantenimientoMotor").style.display = "none";
}
function mostrarRepostaje() {
    if (!placaActual) {
    console.error("La placa global no está definida.");
    return;
    }
    ocultarSecciones();
    document.getElementById("seccion-repostaje").style.display = "block";
    fetch('BDCombustible?placa=' + encodeURIComponent(placaActual))
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la respuesta del servidor');
      }
      return response.json();
    })
    .then(data => {
      actualizarFormularioCombustible(data);
      document.getElementById("seccion-repostaje").style.display = "block";
    })
    .catch(error => {
      console.error('Error al obtener Repostaje de Combustible:', error);
    });
}
function actualizarFormularioCombustible(listaComb) {
  const contenedor = document.getElementById("contenedorRepostaje");
  contenedor.innerHTML = "";
  listaComb.forEach(item => {
    const divComb = document.createElement("div");
    divComb.style.marginBottom = "1rem";
    const btnToggle = document.createElement("button");
    btnToggle.className = "btn-revision";
    const btnContent = document.createElement("span");
    btnContent.className = "button-content";
    const idComb = (item.IdCombustible !== undefined) ? item.IdCombustible : "N/A";
    btnContent.textContent = "Repostaje " + idComb;
    btnToggle.appendChild(btnContent);
    btnToggle.onclick = function() {
      const contenido = this.nextElementSibling;
      contenido.style.display = (contenido.style.display === "block") ? "none" : "block";
    };
    divComb.appendChild(btnToggle);
    const divContenido = document.createElement("div");
    divContenido.style.display = "none";
    divContenido.style.border = "1px solid #ccc";
    divContenido.style.padding = "0.5rem";
    divContenido.style.borderRadius = "0.5rem";
    divContenido.style.marginTop = "0.5rem";
    const pGalones = document.createElement("p");
    pGalones.textContent = "Galones: " + ((item.Galones !== undefined) ? item.Galones + " gal." : "N/A");
    divContenido.appendChild(pGalones);
    const pPrecio = document.createElement("p");
    pPrecio.textContent = "PrecioComb: " + ((item.PrecioComb !== undefined) ? item.PrecioComb + " S/." : "N/A");
    divContenido.appendChild(pPrecio);
    const pFecha = document.createElement("p");
    pFecha.textContent = "FechaPagoComb: " + (item.FechaPagoComb || "N/A");
    divContenido.appendChild(pFecha);
    const pTipo = document.createElement("p");
    pTipo.textContent = "TipoCombustible: " + (item.TipoCombustible || "N/A");
    divContenido.appendChild(pTipo);
    const pKM = document.createElement("p");
    pKM.textContent = "KMComb: " + ((item.KMComb !== undefined) ? item.KMComb + " Km." : "N/A");
    divContenido.appendChild(pKM);
    if (usuarioCargo === "Administrador" || usuarioCargo === "Desarrollador") {
    const btnEditar = document.createElement("button");
    btnEditar.textContent = "Editar Repostaje";
    btnEditar.className = "btn-revision";
    btnEditar.style.marginTop = "0.5rem";
    btnEditar.onclick = function() {
      editarRepostaje(item);
    };
    divContenido.appendChild(btnEditar);
    }
    divComb.appendChild(divContenido);
    contenedor.appendChild(divComb);
  });
}
function cerrarModalEditarCombustible() {
    document.getElementById("modalEditarCombustible").style.display = "none";
  }
  function editarRepostaje(item) {
    document.getElementById("idCombustibleEditar").value = item.IdCombustible || "";
    document.getElementById("galonesEditar").value = item.Galones || "";
    document.getElementById("precioCombEditar").value = item.PrecioComb || "";
    document.getElementById("fechaPagoCombEditar").value = item.FechaPagoComb || "";
    document.getElementById("tipoCombustibleEditar").value = item.TipoCombustible || "";
    document.getElementById("kmCombEditar").value = item.KMComb || "";
    document.getElementById("modalEditarCombustible").style.display = "flex";
  }
function agregarCombustible() {
  document.getElementById("placaCombustible").value = placaActual;
  document.getElementById("modalAgregarCombustible").style.display = "flex";
}
function cerrarModalAgregarCombustible() {
  document.getElementById("modalAgregarCombustible").style.display = "none";
}
function AgregarVehiculo() {
    document.getElementById("modal-agregar").style.display = "flex";
}
function cerrarModalAgregar() {
    document.getElementById("modal-agregar").style.display = "none";
}
function mostrarBorrar() {
  if (!placaActual) {
    console.error("No hay placa seleccionada.");
    return;
  }
  document.getElementById("modalConfirmarBorrar").style.display = "flex";
}
function cerrarModalConfirmarBorrar() {
  document.getElementById("modalConfirmarBorrar").style.display = "none";
}
function borrarVehiculo() {
  fetch("BorrarVehiculoServlet?placa=" + encodeURIComponent(placaActual))
    .then(resp => resp.text())
    .then(msg => {
      alert(msg);
      cerrarModalConfirmarBorrar();
      cerrarVentana();
    })
    .catch(err => console.error("Error al borrar vehículo:", err));
}
</script>
</body>
</html>