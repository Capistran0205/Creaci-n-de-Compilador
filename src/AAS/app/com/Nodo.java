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

    // ---- Información para la fase semántica (la llena el parser / analizador) ----
    private int linea = -1;        // línea del lexema (1-based); -1 si no aplica
    private int columna = -1;      // columna del lexema (1-based); -1 si no aplica
    private String tipoToken = null; // clase léxica de la hoja: IDENTIFICADOR, NUMERO,
                                     // CADENA_LITERAL, CARACTER_LITERAL, VERDADERO, FALSO
                                     // (null en nodos internos)
    private String tipo = null;    // tipo semántico inferido (lo asigna el analizador)

    public Nodo(String valor) {
        this.valor = valor;
        this.hijos = new ArrayList<>();
    }

    /** Hoja con información léxica: lexema, clase de token y posición (1-based). */
    public Nodo(String valor, String tipoToken, int linea, int columna) {
        this(valor);
        this.tipoToken = tipoToken;
        this.linea = linea;
        this.columna = columna;
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

    // ---- Acceso a la información léxica/semántica ----
    public int getLinea() {
        return linea;
    }

    public int getColumna() {
        return columna;
    }

    public String getTipoToken() {
        return tipoToken;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
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
