package AAS.app.com;
import com.mxgraph.layout.hierarchical.mxHierarchicalLayout;
import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.view.mxGraph;
import javax.swing.*;
import java.util.Map;
import java.util.HashMap;
import org.jgrapht.graph.DefaultDirectedGraph;
import org.jgrapht.graph.DefaultEdge;

public class VisualizadorArbol {
    private mxGraph graph;
    private Map<Nodo, Object> nodoMap;

    public VisualizadorArbol(DefaultDirectedGraph<Nodo, DefaultEdge> grafo) {
        graph = new mxGraph();
        nodoMap = new HashMap<>();
        Object parent = graph.getDefaultParent();

        for (Nodo nodo : grafo.vertexSet()) {
            Object graphNodo = graph.insertVertex(parent, null, nodo.getEtiqueta(), 0, 0, 110, 35);
            nodoMap.put(nodo, graphNodo);
        }

        for (DefaultEdge edge : grafo.edgeSet()) {
            Nodo source = grafo.getEdgeSource(edge);
            Nodo target = grafo.getEdgeTarget(edge);
            graph.insertEdge(parent, null, "", nodoMap.get(source), nodoMap.get(target));
        }
        graph.getModel().beginUpdate();
        try {
            for (Object vertex : nodoMap.values()) {
                graph.getModel().setStyle(vertex, "shape=ellipse;fillColor=red;fontSize=10;fontFamily=Consolas;fontStyle=1;fontColor=black;");
                
            }
        } finally {
            graph.getModel().endUpdate();
        }
    }

    public void mostrar() {
        aplicarTema("Nimbus");
        // Este componente permite mostrar el grafo en un JFrame, incluyendo zoom, desplazamiento y edición interactiva
        mxGraphComponent graphComponent = new mxGraphComponent(graph);
        // Organiza los nodos en un diseño jerárquico, útil para estructuras como árboles sintácticos
        mxHierarchicalLayout layout = new mxHierarchicalLayout(graph);
        layout.execute(graph.getDefaultParent());

        JFrame frame = new JFrame("Árbol Sintáctico");
        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        frame.setSize(800, 600);
        frame.add(graphComponent);
        frame.setVisible(true);
    }
    
        private void aplicarTema(String tema){
        try {
            for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
                if (info.getName().equals(tema)) {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (Exception e) {
            System.err.println("No se pudo aplicar el tema: " + e.getMessage());
        }

    }

}