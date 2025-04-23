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
    private Object etiqueta;

    public Nodo(Object etiqueta) {
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

    public void mostrarArbol(String prefijo) {
        System.out.println(prefijo + etiqueta);
        for (Nodo hijo : hijos) {
            hijo.mostrarArbol(prefijo + "  ");
        }
    }

//    public void mostrarArbol(Nodo raiz) {
//        for (Nodo elemento : raiz.hijos) {
//            mostrarArbol(elemento);
//        }
//        System.out.println(raiz.etiqueta);
//    }
//    public void mostrarArbol(Nodo raiz, String indent) {
//        System.out.println(indent + raiz.getEtiqueta());
//        for (Nodo hijo : raiz.getHijos()) {
//            hijo.mostrarArbol(hijo, indent + "  ");
//        }
//    }
}
