/*
  Sección de configuración
  Donde se guardara la clase LexerCup de Java al generarse. %class LexerCup
  Importación de la clase Symbol de CUP para crear tokens que serán usados por el parser.  
  Se asigna el tipo de retorno para los tokens. %type java_cup.runtime.Symbol
  Declaración para integrar JFlex con CUP. %cup
  Indicar que la clase a generarse sea pública
*/
package AnalizadorSintactico.app.com;
import java_cup.runtime.Symbol;

%%

%class LexerCup
%type java_cup.runtime.Symbol
%cup
%full
%line
%char
%public

/* ================= ESTADOS =================
    Para definir contextos específicos durante el análisis síntactico
    Sirve para indicar la aplicación de ciertas reglas definidas más adelante aplicadas a
    comentarios, strings o carácteres.
    Tipos de estados:
    - %state: Estado inclusivo -las reglas generales  Estado inclusivo - las reglas generales (sin estado) también se aplican.
    - %xstate: Estado exclusivo - solo se aplican las reglas específicas de ese estado.
    Manejo de estados:
    yybegin(NOMBRE_ESTADO) - Cambiar al estado especificado.
    yybegin(YYINITIAL) - Volver al estado inicial.
*/

/* ================= DECLARACIÓN DE ESTADOS ================= 
    Para definir contextos específicos durante el análisis síntactico
*/
%state COMENTARIO_LINEA
%state COMENTARIO_MULTILINEA
%xstate CADENA_STRING
%xstate CADENA_CHAR
%xstate RECOVERY_MODE

// Definición de expresiones regulares para letras, digitos y espaciados
L = [a-zA-Z]+
D = [0-9]+
espacio = [ \t\r\n]+

%{  
    // Variables para manejo de cadenas
    private StringBuilder cadenaBuffer;
    private int estadoAnterior;
    private int contadorErroresLexicos = 0;
    private boolean modoRecuperacion = false;
    /*
        Métodos para simplificar la creación de la clase Symbol. Cup
        los usa para pasar tokens al parser junto con su valor y posición
    */    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    // Método para reportar errores léxicos
    private Symbol reportarErrorLexico(String mensaje) {
        contadorErroresLexicos++;
        String error = String.format("Error léxico en línea %d, columna %d: %s - Token: '%s'", 
                                    yyline + 1, yychar + 1, mensaje, yytext());
        System.err.println(error);
        return symbol(sym.ERROR, error);
    }
    
    // Método para inicializar buffer de cadena
    private void iniciarCadena() {
        cadenaBuffer = new StringBuilder();
    }
    
    // Método para manejar caracteres de escape
    private void agregarEscape(char c) {
        switch(c) {
            case 'n': cadenaBuffer.append('\n'); break;
            case 't': cadenaBuffer.append('\t'); break;
            case 'r': cadenaBuffer.append('\r'); break;
            case '\\': cadenaBuffer.append('\\'); break;
            case '\"': cadenaBuffer.append('\"'); break;
            case '\'': cadenaBuffer.append('\''); break;
            default: 
                cadenaBuffer.append('\\');
                cadenaBuffer.append(c);
        }
    }

    // Método para entrar en modo recuperación
    private void iniciarRecuperacion() {
        modoRecuperacion = true;
        yybegin(RECOVERY_MODE);
    }
    
    // Método para salir del modo recuperación
    private void finalizarRecuperacion() {
        modoRecuperacion = false;
        // Regreso al estado inicial
        yybegin(YYINITIAL);
    }

%}

%%
/* ========================= ELEMENTOS CLAVES ======================= 
   yytext() - Texto coincidente actual
   yylength() - Longitud del texto coincidente
   yyline - Número de línea actual
   yycolumn - Número de columna actual   
*/
/* ========================= ESTADO INICIAL ========================= */
<YYINITIAL> {
    /* Tipos de datos */
    "int"       { return new Symbol(sym.TipoInt, yychar, yyline, yytext()); }
    "string"    { return new Symbol(sym.TipoString, yychar, yyline, yytext()); }
    "char"      { return new Symbol(sym.TipoChar, yychar, yyline, yytext()); }
    "boolean"   { return new Symbol(sym.TipoBoolean, yychar, yyline, yytext()); }
    "double"    { return new Symbol(sym.TipoDouble, yychar, yyline, yytext()); }
    "float"     { return new Symbol(sym.TipoFloat, yychar, yyline, yytext()); }
    
    /* Palabras reservadas de control */
    "if"        { return new Symbol(sym.InstruccionIf, yychar, yyline, yytext()); }
    "else"      { return new Symbol(sym.InstruccionElse, yychar, yyline, yytext()); }
    "while"     { return new Symbol(sym.InstruccionWhile, yychar, yyline, yytext()); }
    
    /* Operaciones de entrada/salida */
    "cin"       { return new Symbol(sym.EntradaInfo, yychar, yyline, yytext()); }
    "cout"      { return new Symbol(sym.SalidaInfo, yychar, yyline, yytext()); }
    
    /* Programa principal */
    "main"      { return new Symbol(sym.InicioPrograma, yychar, yyline, yytext()); }
    
    /* Valores booleanos */
    "true"      { return new Symbol(sym.OperadorTrue, yychar, yyline, yytext()); }
    "false"     { return new Symbol(sym.OperadorFalse, yychar, yyline, yytext()); }
    
    /* Palabras especiales del lenguaje */
    "Finish"    { return new Symbol(sym.FinPrograma, yychar, yyline, yytext()); }
    ":_:"       { return new Symbol(sym.FinLinea, yychar, yyline, yytext()); }
    ","         { return new Symbol(sym.Separador, yychar, yyline, yytext()); }
    "endl"      { return new Symbol(sym.SaltoLinea, yychar, yyline, yytext()); }
    "concat"    { return new Symbol(sym.ConcatenacionText, yychar, yyline, yytext()); }
    
    /* Operadores de asignación */
    "="         { return new Symbol(sym.OperadorAsignacion, yychar, yyline, yytext()); }
    "+="        { return new Symbol(sym.OperadorASuma, yychar, yyline, yytext()); }
    "-="        { return new Symbol(sym.OperadorAResta, yychar, yyline, yytext()); }
    "*="        { return new Symbol(sym.OperadorAMultiplicacion, yychar, yyline, yytext()); }
    "/="        { return new Symbol(sym.OperadorADivision, yychar, yyline, yytext()); }
    "%="        { return new Symbol(sym.OperadorAModulo, yychar, yyline, yytext()); }
    
    /* Operadores aritméticos */
    "++"        { return new Symbol(sym.OperadorIncremento, yychar, yyline, yytext()); }
    "--"        { return new Symbol(sym.OperadorDecremento, yychar, yyline, yytext()); }
    "+"         { return new Symbol(sym.OperadorSuma, yychar, yyline, yytext()); }
    "-"         { return new Symbol(sym.OperadorResta, yychar, yyline, yytext()); }
    "*"         { return new Symbol(sym.OperadorMultiplicacion, yychar, yyline, yytext()); }
    "/"         { return new Symbol(sym.OperadorDivision, yychar, yyline, yytext()); }
    
    /* Operadores lógicos */
    "&&"        { return new Symbol(sym.OperadorLAnd, yychar, yyline, yytext()); }
    "||"        { return new Symbol(sym.OperadorLOr, yychar, yyline, yytext()); }
    "!"         { return new Symbol(sym.OperadorLNot, yychar, yyline, yytext()); }
    
    /* Operadores de comparación */
    ">="        { return new Symbol(sym.OperadorMayorIgual, yychar, yyline, yytext()); }
    "<="        { return new Symbol(sym.OperadorMenorIgual, yychar, yyline, yytext()); }
    "=="        { return new Symbol(sym.OperadorIgual, yychar, yyline, yytext()); }
    "!="        { return new Symbol(sym.OperadorDiferente, yychar, yyline, yytext()); }
    ">"         { return new Symbol(sym.OperadorMayor, yychar, yyline, yytext()); }
    "<"         { return new Symbol(sym.OperadorMenor, yychar, yyline, yytext()); }
    
    /* Operadores de flujo (E/S) */
    "<<"        { return new Symbol(sym.OperadorSalida, yychar, yyline, yytext()); }
    ">>"        { return new Symbol(sym.OperadorEntrada, yychar, yyline, yytext()); }
    
    /* Delimitadores */
    "("         { return new Symbol(sym.ParentesisApertura, yychar, yyline, yytext()); }
    ")"         { return new Symbol(sym.ParentesisCierre, yychar, yyline, yytext()); }
    "{"         { return new Symbol(sym.LlaveApertura, yychar, yyline, yytext()); }
    "}"         { return new Symbol(sym.LlaveCierre, yychar, yyline, yytext()); }
    "["         { return new Symbol(sym.CorcheteApertura, yychar, yyline, yytext()); }
    "]"         { return new Symbol(sym.CorcheteCierre, yychar, yyline, yytext()); }
    
    /* Inicio de comentarios */
    "//"        { yybegin(COMENTARIO_LINEA); }
    "/*"        { yybegin(COMENTARIO_MULTILINEA); }
    
    /* Inicio de cadenas */
    "\""        { iniciarCadena(); yybegin(CADENA_STRING); }
    "'"         { iniciarCadena(); yybegin(CADENA_CHAR); }
    
    /* Identificadores y números */
    {L}({L}|{D}|"_")*       { return new Symbol(sym.Identificador, yychar, yyline, yytext()); }
    "-"?{D}+(\.{D}+)?       { return new Symbol(sym.Numero, yychar, yyline, yytext()); }
    
    /* Espacios en blanco */
    {espacio}   { /* Ignorar espacios */ }
    
    /* Cualquier otro carácter es un error */
    .           { return new Symbol(sym.ERROR, yychar, yyline, yytext()); }
}

/* ========================= COMENTARIO DE LÍNEA ========================= */
<COMENTARIO_LINEA> {
    [^\r\n]*    { /* Contenido del comentario - ignorar */ }
    \r|\n|\r\n  { yybegin(YYINITIAL); }
    <<EOF>>     { yybegin(YYINITIAL); }
}

/* ========================= COMENTARIO MULTILÍNEA ========================= */
<COMENTARIO_MULTILINEA> {
    [^*]+       { /* Contenido del comentario - ignorar */ }
    "*"+"/"     { yybegin(YYINITIAL); }
    "*"+        { /* Asterisco que no cierra el comentario */ }
    <<EOF>>     { 
        yybegin(YYINITIAL); 
        return new Symbol(sym.ERROR, yychar, yyline, "Comentario multilínea sin cerrar");
    }
}

/* ========================= CADENA STRING ========================= */
<CADENA_STRING> {
    "\""        { 
        yybegin(YYINITIAL); 
        return new Symbol(sym.CadenaText, yychar, yyline, "\"" + cadenaBuffer.toString() + "\"");
    }
    
    \\[nt\"\\r] { 
        char escapedChar = yytext().charAt(1);
        agregarEscape(escapedChar);
    }
    
    \\(.|\n)    { 
        // Escape no reconocido - mantener literal
        cadenaBuffer.append(yytext());
    }
    
    [^\"\\\n]+  { cadenaBuffer.append(yytext()); }
    
    \n          {
        yybegin(YYINITIAL);
        return new Symbol(sym.ERROR, yychar, yyline, "Cadena sin cerrar");
    }
    
    <<EOF>>     {
        yybegin(YYINITIAL);
        return new Symbol(sym.ERROR, yychar, yyline, "Cadena sin cerrar al final del archivo");
    }
}

/* ========================= CADENA CHAR ========================= */
<CADENA_CHAR> {
    "'"         {
        yybegin(YYINITIAL);
        String contenido = cadenaBuffer.toString();
        if (contenido.length() == 1 || (contenido.length() == 2 && contenido.charAt(0) == '\\')) {
            return new Symbol(sym.CharText, yychar, yyline, "'" + contenido + "'");
        } else {
            return new Symbol(sym.ERROR, yychar, yyline, "Carácter literal inválido - demasiados caracteres");
        }
    }
    
    \\[nt'\\r]  {
        char escapedChar = yytext().charAt(1);
        agregarEscape(escapedChar);
    }
    
    \\(.|\n)    {
        // Escape no reconocido - mantener literal  
        cadenaBuffer.append(yytext());
    }
    
    [^'\\\n]    { 
        cadenaBuffer.append(yytext()); 
    }
    
    \n          {
        yybegin(YYINITIAL);
        return new Symbol(sym.ERROR, yychar, yyline, "Carácter literal sin cerrar");
    }
    
    <<EOF>>     {
        yybegin(YYINITIAL);
        return new Symbol(sym.ERROR, yychar, yyline, "Carácter literal sin cerrar al final del archivo");
    }

    /* ========================= MODO RECUPERACIÓN ========================= */
    <RECOVERY_MODE> {
        /* Sincronización en puntos seguros */
        ":_:"       { finalizarRecuperacion(); return symbol(sym.FinLinea, yytext()); }
        "{"         { finalizarRecuperacion(); return symbol(sym.LlaveApertura, yytext()); }
        "}"         { finalizarRecuperacion(); return symbol(sym.LlaveCierre, yytext()); }
        \n          { finalizarRecuperacion(); return symbol(sym.Linea, yytext()); }

        /* Ignorar todo lo demás hasta encontrar un punto de sincronización */
        .           { /* Ignorar durante recuperación */ }

        <<EOF>>     { finalizarRecuperacion(); }
    }

}