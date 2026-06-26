package AnalizadorSemantico.app.com;
/* ============================================================
   AnalizadorSemantico.java  -  Fase semantica de Infinix
   ------------------------------------------------------------
   Recorre el arbol (Nodo) que produce el parser y:
     - construye la tabla de simbolos (declaraciones),
     - verifica uso de variables (declaradas / inicializadas),
     - infiere y verifica tipos en asignaciones y expresiones
       con PROMOCION NUMERICA (entero -> decimal).
   Reporta errores (bloqueantes) y avisos (no bloqueantes) con linea.

   Requiere que el arbol provenga de un analisis SIN errores de
   sintaxis (las hojas de operandos/identificadores llevan
   tipoToken y posicion, puestos por Sintactico.cup).
   ============================================================ */
import AAS.app.com.Nodo;
import java.util.ArrayList;
import java.util.List;

public class AnalizadorSemantico {

    private final Nodo raiz;
    private final TablaSimbolos tabla = new TablaSimbolos();
    private final List<String> errores = new ArrayList<>();
    private final List<String> avisos = new ArrayList<>();

    public AnalizadorSemantico(Nodo raiz) {
        this.raiz = raiz;
    }

    // ---- Resultados ----
    public boolean huboErrores()      { return !errores.isEmpty(); }
    public List<String> getErrores()  { return errores; }
    public List<String> getAvisos()   { return avisos; }
    public TablaSimbolos getTabla()   { return tabla; }
    public String getErroresTexto()   { return String.join("\n", errores); }

    // ============================================================
    //  Recorrido principal: una instruccion a la vez
    // ============================================================
    public void analizar() {
        if (raiz == null) {
            return;
        }
        for (Nodo instr : raiz.getHijos()) {
            if (!"instruccion".equals(instr.getValor()) || instr.getHijos().isEmpty()) {
                continue;
            }
            Nodo contenido = instr.getHijos().get(0);
            switch (contenido.getValor()) {
                case "declaracion":         analizarDeclaracion(contenido); break;
                case "asignacion":          analizarAsignacion(contenido);  break;
                case "instruccion_entrada": analizarEntrada(contenido);     break;
                case "instruccion_salida":  analizarSalida(contenido);      break;
                default: /* "<error>" u otros: se ignoran */                break;
            }
        }
    }

    // ---- Declaracion:  tipo_dato  lista_declaraciones ----
    private void analizarDeclaracion(Nodo decl) {
        Nodo tipoDato = decl.getHijos().get(0);
        Tipo tipo = Tipo.desde(tipoDato.getHijos().get(0).getValor());
        Nodo lista = decl.getHijos().get(1);

        for (Nodo ds : hijosConEtiqueta(lista, "declaracion_simple")) {
            Nodo idLeaf = ds.getHijos().get(0);
            String nombre = idLeaf.getValor();
            boolean tieneInit = ds.getHijos().size() >= 3;

            // La expresion se evalua ANTES de declarar, para que un
            // auto-referencia (entero x = x) detecte "no declarada".
            Tipo tExpr = Tipo.ERROR;
            if (tieneInit) {
                tExpr = evaluarTipo(ds.getHijos().get(2));
            }

            Simbolo s = new Simbolo(nombre, tipo, tieneInit, idLeaf.getLinea(), idLeaf.getColumna());
            if (!tabla.declarar(s)) {
                error(idLeaf.getLinea(), "la variable '" + nombre + "' ya fue declarada");
            }
            if (tieneInit) {
                verificarAsignacion(tipo, tExpr, nombre, idLeaf.getLinea());
            }
        }
    }

    // ---- Asignacion:  IDENTIFICADOR = expresion ----
    private void analizarAsignacion(Nodo asig) {
        Nodo idLeaf = asig.getHijos().get(0);
        String nombre = idLeaf.getValor();
        Tipo tExpr = evaluarTipo(asig.getHijos().get(2));

        if (!tabla.existe(nombre)) {
            error(idLeaf.getLinea(), "la variable '" + nombre + "' no ha sido declarada");
            return;
        }
        Simbolo s = tabla.obtener(nombre);
        verificarAsignacion(s.tipo, tExpr, nombre, idLeaf.getLinea());
        s.inicializado = true;
    }

    // ---- Entrada:  inp < IDENTIFICADOR > ----
    private void analizarEntrada(Nodo ent) {
        Nodo idLeaf = ent.getHijos().get(2);
        String nombre = idLeaf.getValor();
        if (!tabla.existe(nombre)) {
            error(idLeaf.getLinea(), "la variable '" + nombre + "' no ha sido declarada (inp)");
            return;
        }
        tabla.obtener(nombre).inicializado = true;
    }

    // ---- Salida:  mt < e1, e2, ... > ----
    private void analizarSalida(Nodo sal) {
        Nodo lista = sal.getHijos().get(2);
        for (Nodo elem : hijosConEtiqueta(lista, "elemento_salida")) {
            evaluarTipo(elem.getHijos().get(0));  // valida usos; los errores se reportan dentro
        }
    }

    // ============================================================
    //  Inferencia de tipos sobre expresion / termino / factor
    // ============================================================
    private Tipo evaluarTipo(Nodo n) {
        if (!"expresion".equals(n.getValor())) {
            return tipoDeHoja(n);                          // hoja suelta (defensivo)
        }
        List<Nodo> h = n.getHijos();
        switch (h.size()) {
            case 1:                                        // atomo: una hoja
                return tipoDeHoja(h.get(0));
            case 2:                                        // menos unario:  "-" expresion
                return aplicarUnario(h.get(0).getValor(), evaluarTipo(h.get(1)), lineaDe(n));
            case 3:
                if ("(".equals(h.get(0).getValor())) {     // ( expresion )
                    return evaluarTipo(h.get(1));
                }
                Tipo izq = evaluarTipo(h.get(0));          // expresion op expresion
                String op = h.get(1).getValor();
                Tipo der = evaluarTipo(h.get(2));
                return aplicarAritmetico(izq, der, op, lineaDe(n));
            default:
                return Tipo.ERROR;
        }
    }

    /** Tipo de una hoja operando, segun su clase de token. */
    private Tipo tipoDeHoja(Nodo hoja) {
        String tk = hoja.getTipoToken();
        if (tk == null) {
            return Tipo.ERROR;
        }
        switch (tk) {
            case "NUMERO":
                return hoja.getValor().contains(".") ? Tipo.DECIMAL : Tipo.ENTERO;
            case "CADENA_LITERAL":   return Tipo.CADENA;
            case "CARACTER_LITERAL": return Tipo.CARACTER;
            case "VERDADERO":
            case "FALSO":            return Tipo.BOOLEANO;
            case "IDENTIFICADOR":
                if (!tabla.existe(hoja.getValor())) {
                    error(hoja.getLinea(), "la variable '" + hoja.getValor() + "' no ha sido declarada");
                    return Tipo.ERROR;
                }
                Simbolo s = tabla.obtener(hoja.getValor());
                if (!s.inicializado) {
                    aviso(hoja.getLinea(), "la variable '" + hoja.getValor() + "' se usa sin haber sido inicializada");
                }
                return s.tipo;
            default:
                return Tipo.ERROR;
        }
    }

    /** Regla aritmetica: ambos numericos -> decimal si alguno es decimal, si no entero. */
    private Tipo aplicarAritmetico(Tipo a, Tipo b, String op, int linea) {
        if (a == Tipo.ERROR || b == Tipo.ERROR) {
            return Tipo.ERROR;                       // ya reportado
        }
        if (a.esNumerico() && b.esNumerico()) {
            return (a == Tipo.DECIMAL || b == Tipo.DECIMAL) ? Tipo.DECIMAL : Tipo.ENTERO;
        }
        error(linea, "el operador '" + op + "' no es aplicable entre '"
                   + a.etiqueta + "' y '" + b.etiqueta + "'");
        return Tipo.ERROR;
    }

    /** Menos unario: el operando debe ser numerico; conserva su tipo. */
    private Tipo aplicarUnario(String op, Tipo t, int linea) {
        if (t == Tipo.ERROR) {
            return Tipo.ERROR;                       // ya reportado
        }
        if (t.esNumerico()) {
            return t;
        }
        error(linea, "el operador unario '" + op + "' no es aplicable a '" + t.etiqueta + "'");
        return Tipo.ERROR;
    }

    /** Compatibilidad de asignacion con promocion numerica. */
    private void verificarAsignacion(Tipo destino, Tipo origen, String nombre, int linea) {
        if (origen == Tipo.ERROR || destino == Tipo.ERROR) {
            return;                                  // ya reportado
        }
        if (destino == origen) {
            return;
        }
        if (destino == Tipo.DECIMAL && origen == Tipo.ENTERO) {
            return;                                  // promocion permitida
        }
        if (destino == Tipo.ENTERO && origen == Tipo.DECIMAL) {
            error(linea, "no se puede asignar 'decimal' a la variable '" + nombre
                       + "' de tipo 'entero' (posible perdida de precision)");
            return;
        }
        error(linea, "tipos incompatibles: no se puede asignar '" + origen.etiqueta
                   + "' a la variable '" + nombre + "' de tipo '" + destino.etiqueta + "'");
    }

    // ============================================================
    //  Utilidades
    // ============================================================
    private List<Nodo> hijosConEtiqueta(Nodo padre, String etiqueta) {
        List<Nodo> r = new ArrayList<>();
        for (Nodo h : padre.getHijos()) {
            if (etiqueta.equals(h.getValor())) {
                r.add(h);
            }
        }
        return r;
    }

    /** Linea representativa de un subarbol: la primera hoja con posicion. */
    private int lineaDe(Nodo n) {
        if (n == null) {
            return -1;
        }
        if (n.getLinea() >= 0) {
            return n.getLinea();
        }
        for (Nodo h : n.getHijos()) {
            int l = lineaDe(h);
            if (l >= 0) {
                return l;
            }
        }
        return -1;
    }

    private void error(int linea, String msg) {
        errores.add(linea >= 0 ? ("Linea " + linea + ": " + msg) : msg);
    }

    private void aviso(int linea, String msg) {
        avisos.add(linea >= 0 ? ("Linea " + linea + ": " + msg) : msg);
    }
}
