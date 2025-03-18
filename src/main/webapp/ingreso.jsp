<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Ingreso</title>
    <style>
        
        body {font-family: 'Arial', sans-serif;margin: 0;  padding: 0;background-color: #969696;color: #333;}
        .header {background-color: #212121; color: white; padding: 35px;text-align: center; font-size: 40px;font-weight: bold;}

        .container {
            width: 350px;
            margin: 100px auto;
            padding: 20px;
            background-color: #212121;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
            border-radius: 8px;
            text-align: center;
        }
        h2 {
            color: #00e5ff;
        }
        label{
            color:white;
            align-content: center;
        }
        input {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #003366;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 18px;
            border-radius: 5px;
            margin-top: 10px;
        }
        button:hover {
            background-color: #01070d;
        }
        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        INICIAR SESIÓN
    </div>
    <div class="container">
        <h2>Ingresar</h2>
        
        

        <form action="IngresoServlet" method="post">
            <label>Usuario o DNI</label>
            <input type="text" name="usuarioODNI" placeholder="Ingrese su usuario o DNI" required>
            
            <label>Contraseña</label>  
            <input type="password" name="password" placeholder="Contraseña" required>

            <button type="submit">Ingresar</button>
            
        </form>
        <% String error = request.getParameter("error"); %>
        <% if ("1".equals(error)) { %>
            <p class="error">⚠ Usuario o contraseña incorrectos.</p>
        <% } else if ("2".equals(error)) { %>
            <p class="error">⚠ Error al conectar con la base de datos.</p>
        <% } %>
    </div>
</body>
</html>
