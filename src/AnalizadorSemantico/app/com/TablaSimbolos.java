package AnalizadorSemantico.app.com;
/* ============================================================
   TablaSimbolos.java  -  Tabla de simbolos (ambito unico global)
   ------------------------------------------------------------
   Infinix no tiene bloques ni funciones, asi que basta un solo
   ambito plano. LinkedHashMap conserva el orden de declaracion.
   ============================================================ */
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class TablaSimbolos {

    private final Map<String, Simbolo> tabla = new LinkedHashMap<>();

    /** Declara un simbolo; devuelve false si el nombre ya existia (redeclaracion). */
    public boolean declarar(Simbolo s) {
        if (tabla.containsKey(s.nombre)) {
            return false;
        }
        tabla.put(s.nombre, s);
        return true;
    }

    public boolean existe(String nombre) {
        return tabla.containsKey(nombre);
    }

    public Simbolo obtener(String nombre) {
        return tabla.get(nombre);
    }

    /** Todos los simbolos en orden de declaracion (para mostrar la tabla). */
    public Collection<Simbolo> valores() {
        return tabla.values();
    }
}
