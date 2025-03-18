package com.mycompany.mantenimientovehicular;
import java.util.Date;

public class Vehiculo {
    private String placa;
    private String marca;
    private String modelo;
    private String color;
    private String detalles;
    private Date fechaRevFin;
    private Date fechaFinSOAT;
    
    
    
    
    public Vehiculo(String placa, String marca, String modelo,
                    String color, String detalles,
                    Date fechaRevFin, Date fechaFinSOAT) {
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.detalles = detalles;
        this.fechaRevFin = fechaRevFin;
        this.fechaFinSOAT = fechaFinSOAT;
    }
    
    public String getPlaca() { return placa; }
    public String getMarca() { return marca; }
    public String getModelo() { return modelo; }
    public String getColor() { return color; }
    public String getDetalles() { return detalles; }
    public Date getFechaRevFin() { return fechaRevFin; }
    public Date getFechaFinSOAT() { return fechaFinSOAT; }
}
