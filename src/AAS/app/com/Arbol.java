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
public class Arbol {
    private ArrayList<Arbol> arbolSintactico;
    private String etiqueta;
    
    public Arbol(String etiqueta){
        this.etiqueta = etiqueta;
        this.arbolSintactico = new ArrayList();
    }
    
    public void agregarElemento(Arbol elemento){
        this.arbolSintactico.add(elemento);
    }
    
    public void mostrarArbol(Arbol raiz){
        for(Arbol elemento : raiz.arbolSintactico){
            mostrarArbol(elemento);
        }
        System.out.println(raiz.etiqueta);
    }
}
