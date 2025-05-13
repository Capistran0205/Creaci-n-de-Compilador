/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package AAS.app.com;
import org.jgrapht.graph.DefaultDirectedGraph;
import org.jgrapht.graph.DefaultEdge;
/**
 *
 * @author capis
 */
public class ArbolJGrapht {
    // Atributo:
    // Objeto DefaultDirectedGraph para establecer los nodos del árbol sintáctico
    private DefaultDirectedGraph<Nodo, DefaultEdge> grafo;

    public ArbolJGrapht() {
        grafo = new DefaultDirectedGraph<>(DefaultEdge.class);
    }

    public void construirGrafo(Nodo raiz) {
        if (raiz != null) {
            grafo.addVertex(raiz);
            for (Nodo hijo : raiz.getHijos()) {
                grafo.addVertex(hijo); // Se agrega el nodo
                grafo.addEdge(raiz, hijo); // Conectar nodo padre con hijo
                construirGrafo(hijo); // Recursión para agregar hijos
            }
        }
    }

    public DefaultDirectedGraph<Nodo, DefaultEdge> getGrafo() {
        return grafo;
    }
}
