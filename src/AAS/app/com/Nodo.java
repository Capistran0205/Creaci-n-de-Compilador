/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package AAS.app.com;
/**
 *
 * @author capis
 */
import java.util.ArrayList;
public class Nodo {

    private ArrayList<Nodo> hijos;
    private String valor;

    public Nodo(String valor) {
        this.valor = valor;
        this.hijos = new ArrayList<>();
    }

    public void agregarHijo(Nodo hijo) {
        this.hijos.add(hijo);
    }

    public ArrayList<Nodo> getHijos() {
        return hijos;
    }

    public String getValor() {
        return String.valueOf(valor);
    }

    public void setValor(String valor) {
        this.valor = valor;
    }
    // Método para imprimir el árbol de análisis sintáctico
    public void printArbol(Nodo raiz) {
        System.out.println(raiz.getValor());
        for (Nodo hijo : raiz.hijos) {
            printArbol(hijo);
        }        
    }
    // Método para obtener la cantidad de nodos recorriendo la lista (listas de subarboles internos).
    public int contarNodos() {
        int count = 1;
        for (Nodo hijo : hijos) {
            count += hijo.contarNodos();
        }
        return count;
    }
}
