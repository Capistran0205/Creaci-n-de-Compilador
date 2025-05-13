/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package AAS.app.com;

import java.util.ArrayList;

/**
 *
 * @author capis
 */
public class Nodo {

    private ArrayList<Nodo> hijos;
    private String etiqueta;

    public Nodo(String etiqueta) {
        this.etiqueta = etiqueta;
        this.hijos = new ArrayList<>();
    }

    public void agregarHijo(Nodo hijo) {
        this.hijos.add(hijo);
    }

    public ArrayList<Nodo> getHijos() {
        return hijos;
    }

    public String getEtiqueta() {
        return String.valueOf(etiqueta);
    }

    public void setEtiqueta(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public void printArbol(Nodo raiz) {
        System.out.println(raiz.getEtiqueta());
        for (Nodo hijo : raiz.hijos) {
            printArbol(hijo);
        }        
    }
}
