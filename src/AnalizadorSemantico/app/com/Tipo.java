package AnalizadorSemantico.app.com;
/* ============================================================
   Tipo.java  -  Tipos semanticos del lenguaje Infinix
   ------------------------------------------------------------
   ERROR es un tipo "sumidero": se devuelve cuando ya se reporto
   un error, para no encadenar mensajes derivados.
   ============================================================ */
public enum Tipo {

    ENTERO  ("entero"),
    DECIMAL ("decimal"),
    CARACTER("caracter"),
    CADENA  ("cadena"),
    BOOLEANO("booleano"),
    ERROR   ("error");

    /** Nombre en minusculas para los mensajes (igual a la palabra reservada). */
    public final String etiqueta;

    Tipo(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    /** entero/decimal son los unicos sobre los que opera la aritmetica. */
    public boolean esNumerico() {
        return this == ENTERO || this == DECIMAL;
    }

    /** Mapea la palabra reservada de un tipo_dato a su Tipo. */
    public static Tipo desde(String palabra) {
        switch (palabra) {
            case "entero":   return ENTERO;
            case "decimal":  return DECIMAL;
            case "caracter": return CARACTER;
            case "cadena":   return CADENA;
            case "booleano": return BOOLEANO;
            default:         return ERROR;
        }
    }
}
