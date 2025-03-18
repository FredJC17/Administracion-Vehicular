package com.mycompany.mantenimientovehicular;

public class Revision {
    private int idRevision;
    private String fechaRev;
    private String fechaRevFin;
    private String comprobanteRT;
    public Revision() {
    }
    public int getIdRevision() {
        return idRevision;
    }
    public void setIdRevision(int idRevision) {
        this.idRevision = idRevision;
    }
    public String getFechaRev() {
        return fechaRev;
    }
    public void setFechaRev(String fechaRev) {
        this.fechaRev = fechaRev;
    }
    public String getFechaRevFin() {
        return fechaRevFin;
    }
    public void setFechaRevFin(String fechaRevFin) {
        this.fechaRevFin = fechaRevFin;
    }
    public String getComprobanteRT() {
        return comprobanteRT;
    }
    public void setComprobanteRT(String comprobanteRT) {
        this.comprobanteRT = comprobanteRT;
    }
}

