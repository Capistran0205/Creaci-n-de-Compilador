package AnalizadorLexico.app.com;
/* ============================================================
   Categoria.java  -  Clasificacion general de los tokens
   ------------------------------------------------------------
   Agrupa los tipos de token por su "rol" en el lenguaje.
   Sirve para que las fases siguientes (sintactico/semantico)
   pregunten cosas como "esto es una palabra reservada?" sin
   tener que enumerar token por token.
   ============================================================ */
public enum Categoria {
    RESERVADA,      // palabras clave (entero, mt, inp, ...)
    LITERAL,        // valores (numeros, cadenas, caracteres, booleanos)
    IDENTIFICADOR,  // nombres definidos por el usuario
    OPERADOR,       // + - * / ^
    SIMBOLO,        // = , < > ( ) :_: '
    CONTROL,        // tokens internos (salto de linea)
    ERROR           // lexema no reconocido
}
