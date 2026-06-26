package AnalizadorSemantico.app.com;
/* ============================================================
   Simbolo.java  -  Entrada de la tabla de simbolos
   ------------------------------------------------------------
   Guarda el nombre de la variable, su tipo, si ya recibio valor
   y donde fue declarada.
   ============================================================ */
public class Simbolo {

    public final String nombre;
    public final Tipo tipo;
    public boolean inicializado;   // true si ya recibio un valor (init, asignacion o inp)
    public final int linea;
    public final int columna;

    public Simbolo(String nombre, Tipo tipo, boolean inicializado, int linea, int columna) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.inicializado = inicializado;
        this.linea = linea;
        this.columna = columna;
    }

    @Override
    public String toString() {
        return nombre + " : " + tipo.etiqueta
             + (inicializado ? " (inicializada)" : " (sin inicializar)");
    }
}
