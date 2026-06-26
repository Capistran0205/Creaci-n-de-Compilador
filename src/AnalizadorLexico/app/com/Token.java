package AnalizadorLexico.app.com;
/* ============================================================
   Token.java  -  Representacion de un token reconocido
   ------------------------------------------------------------
   Solo guarda datos: que tipo es, su lexema y donde aparecio.
   No sabe nada de como se escaneo (eso es del .flex).
   ============================================================ */

public enum Token {
 
    // ---- Palabras reservadas: tipos de dato ----
    ENTERO  (Categoria.RESERVADA),
    DECIMAL (Categoria.RESERVADA),
    CARACTER(Categoria.RESERVADA),
    CADENA  (Categoria.RESERVADA),
    BOOLEANO(Categoria.RESERVADA),
 
    // ---- Palabras reservadas: entrada / salida ----
    MT (Categoria.RESERVADA),
    INP(Categoria.RESERVADA),
 
    // ---- Valores booleanos ----
    VERDADERO (Categoria.LITERAL),
    FALSO (Categoria.LITERAL),
 
    // ---- Identificadores ----
    IDENTIFICADOR(Categoria.IDENTIFICADOR),
 
    // ---- Literales ----
    NUMERO          (Categoria.LITERAL),
    CADENA_LITERAL  (Categoria.LITERAL),
    CARACTER_LITERAL(Categoria.LITERAL),
 
    // ---- Operadores aritmeticos ----
    SUMA (Categoria.OPERADOR),  // +
    RESTA(Categoria.OPERADOR),  // -
    MULT (Categoria.OPERADOR),  // *
    DIV  (Categoria.OPERADOR),  // /
    POT (Categoria.OPERADOR), // ^
 
    // ---- Simbolos / delimitadores ----
    ASIGNACION(Categoria.SIMBOLO),  // =
    COMA      (Categoria.SIMBOLO),  // ,
    COMILLA   (Categoria.SIMBOLO), // '
    MENOR     (Categoria.SIMBOLO),  // <
    MAYOR     (Categoria.SIMBOLO),  // >
    PAR_IZQ   (Categoria.SIMBOLO),  // (
    PAR_DER   (Categoria.SIMBOLO),  // )
    FIN_LINEA (Categoria.SIMBOLO),  // :_:
 
    // ---- Tokens de control / error ----
    LINEA(Categoria.CONTROL),       // salto de linea (nombrado asi para tu switch)
    ERROR(Categoria.ERROR);         // simbolo no reconocido
 
    public final Categoria categoria;
 
    Token(Categoria categoria) {
        this.categoria = categoria;
    }
}