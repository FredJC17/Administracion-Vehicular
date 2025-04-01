package com.mycompany.mantenimientovehicular;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class DatosServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Map<String, Object>> datos = new HashMap<>();

        datos.put("revision", crearDatosSeccion(new double[]{100, 150, 200}, new int[]{0, 30, 60}));
        datos.put("soat", crearDatosSeccion(new double[]{200, 250, 300}, new int[]{0, 365, 730}));
        datos.put("mantenimientoAceite", crearDatosSeccion(new double[]{50, 60, 70}, new int[]{0, 90, 180}));
        datos.put("mantenimientoFAceite", crearDatosSeccion(new double[]{30, 40, 50}, new int[]{0, 180, 360}));
        datos.put("mantenimientoSuspension", crearDatosSeccion(new double[]{80, 90, 100}, new int[]{0, 365, 730}));
        datos.put("mantenimientoMotor", crearDatosSeccion(new double[]{200, 250, 300}, new int[]{0, 365, 730}));
        datos.put("repostaje", crearDatosSeccion(new double[]{40, 50, 60}, new int[]{0, 7, 14}));

        String json = new Gson().toJson(datos);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    private Map<String, Object> crearDatosSeccion(double[] precios, int[] diasEntreFechas) {
        Map<String, Object> datosSeccion = new HashMap<>();
        datosSeccion.put("precios", precios);
        datosSeccion.put("diasEntreFechas", diasEntreFechas);
        return datosSeccion;
    }
}