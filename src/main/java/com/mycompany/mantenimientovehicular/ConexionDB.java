package com.mycompany.mantenimientovehicular;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConexionDB {

    public static Connection getConexion() throws SQLException {
        String url = "jdbc:sqlserver://10.0.1.2:1433;databaseName=ManPreVehi;encrypt=true;trustServerCertificate=true";
        String username = "pc1";
        String password = "0969";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se pudo cargar el driver JDBC.", e);
        }
    }
}