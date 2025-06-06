package AnalizadorLexico.app.com;
import Compilador.app.com.Tokens;
import static Compilador.app.com.Tokens.*;

%%
%public
%class Lexer
%type Tokens
%line
%char

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
/* ================= DECLARACIÓN DE ESTADOS ================= */
%state COMENTARIO_LINEA        // Estado para comentarios de línea (//)
%state COMENTARIO_MULTILINEA   // Estado para comentarios en bloque (/* ... */)
%xstate CADENA_STRING          // Estado para cadenas de texto (entre comillas dobles "")
%xstate CADENA_CHAR            // Estado para caracteres individuales (entre comillas simples '')

// ===================== EXPRESIONES REGULARES =====================
// Definición de expresiones regulares para facilitar el análisis léxico
L = [a-zA-Z]+           // Letras (para identificadores y palabras clave)
D = [0-9]+              // Dígitos numéricos
espacio = [ \t\r]+      // Espacios en blanco (se ignorarán)

%{
    // ===================== VARIABLES GLOBALES PARA EL MANEJO DE CADENAS =====================
    public String lexeme; // Almacena el lexema actual
    
    // Variables auxiliares para el manejo de cadenas de texto
    private StringBuilder cadenaBuffer; // Acumulador de caracteres en cadenas
    private int lineaInicioCadena;      // Línea donde inició una cadena
    private int charInicioCadena;       // Posición de inicio de una cadena
    
    // Método para inicializar el buffer de una cadena
    private void iniciarCadena() {
        cadenaBuffer = new StringBuilder();
        lineaInicioCadena = yyline;
        charInicioCadena = yychar;
    }
    
    // Método para procesar caracteres de escape dentro de una cadena
    private void procesarEscape(String escape) {
        switch(escape) {
            case "\\n": cadenaBuffer.append('\n'); break;
            case "\\t": cadenaBuffer.append('\t'); break;
            case "\\r": cadenaBuffer.append('\r'); break;
            case "\\\\": cadenaBuffer.append('\\'); break;
            case "\\\"": cadenaBuffer.append('"'); break;
            case "\\'": cadenaBuffer.append('\''); break;
            default:
                // Si el escape no está reconocido, se mantiene el texto literal
                cadenaBuffer.append(escape);
        }
    }
%}

%%

/* ========================= ESTADO INICIAL ========================= */
<YYINITIAL> {
    /* Tipos de datos */
    "int"       { lexeme = yytext(); return TipoDato; }
    "string"    { lexeme = yytext(); return TipoDato; }
    "char"      { lexeme = yytext(); return TipoDato; }
    "boolean"   { lexeme = yytext(); return TipoDato; }
    "double"    { lexeme = yytext(); return TipoDato; }
    "float"     { lexeme = yytext(); return TipoDato; }
    
    /* Instrucciones de control y de ciclica */
    "if"        { lexeme = yytext(); return InstruccionCondicional; }
    "else"      { lexeme = yytext(); return InstruccionCondicional; }
    "while"     { lexeme = yytext(); return InstruccionBucle; }
    
    /* Entrada/Salida */
    "cin"       { lexeme = yytext(); return EntradaInfo; }
    "cout"      { lexeme = yytext(); return SalidaInfo; }
    
    /* Control de programa */
    "main"      { lexeme = yytext(); return InicioPrograma; }
    "Finish"    { lexeme = yytext(); return FinPrograma; }
    
    /* Símbolos especiales */
    ":_:"       { lexeme = yytext(); return FinLinea; }
    ","         { lexeme = yytext(); return Separador; }
    "endl"      { lexeme = yytext(); return SaltoLinea; }
    "concat"    { lexeme = yytext(); return ConcatenacionText; }
    
    /* Operadores de asignación y atribución */
    "="         { lexeme = yytext(); return OperadorAsignacion; }
    "+="        { lexeme = yytext(); return OperadorAtribucion; }
    "-="        { lexeme = yytext(); return OperadorAtribucion; }
    "*="        { lexeme = yytext(); return OperadorAtribucion; }
    "/="        { lexeme = yytext(); return OperadorAtribucion; }
    "%="        { lexeme = yytext(); return OperadorAtribucion; }
    
    /* Operadores aritméticos */
    "+"         { lexeme = yytext(); return OperadorAritmetico; }
    "-"         { lexeme = yytext(); return OperadorAritmetico; }
    "*"         { lexeme = yytext(); return OperadorAritmetico; }
    "/"         { lexeme = yytext(); return OperadorAritmetico; }
    "++"        { lexeme = yytext(); return OperadorIncremento; }
    "--"        { lexeme = yytext(); return OperadorDecremento; }
    
    /* Valores booleanos */
    "true"      { lexeme = yytext(); return OperadorBooleano; }
    "false"     { lexeme = yytext(); return OperadorBooleano; }
    
    /* Operadores de entrada/salida */
    "<<"        { lexeme = yytext(); return OperadorSalida; }
    ">>"        { lexeme = yytext(); return OperadorEntrada; }
    
    /* Operadores relacionales */
    ">="        { lexeme = yytext(); return OperadorRelacional; }
    "<="        { lexeme = yytext(); return OperadorRelacional; }
    "=="        { lexeme = yytext(); return OperadorRelacional; }
    "!="        { lexeme = yytext(); return OperadorRelacional; }
    ">"         { lexeme = yytext(); return OperadorRelacional; }
    "<"         { lexeme = yytext(); return OperadorRelacional; }
    
    /* Operadores lógicos */
    "&&"        { lexeme = yytext(); return OperadorLogico; }
    "||"        { lexeme = yytext(); return OperadorLogico; }
    "!"         { lexeme = yytext(); return OperadorLogico; }
    
    /* Delimitadores */
    "("         { lexeme = yytext(); return ParentesisApertura; }
    ")"         { lexeme = yytext(); return ParentesisCierre; }
    "{"         { lexeme = yytext(); return LlaveApertura; }
    "}"         { lexeme = yytext(); return LlaveCierre; }
    "["         { lexeme = yytext(); return CorcheteApertura; }
    "]"         { lexeme = yytext(); return CorcheteCierre; }
    
    /* Inicio de comentarios */
    "//"        { yybegin(COMENTARIO_LINEA); }
    "/*"        { yybegin(COMENTARIO_MULTILINEA); }
    
    /* Inicio de cadenas */
    "\""        { iniciarCadena(); yybegin(CADENA_STRING); }
    "'"         { iniciarCadena(); yybegin(CADENA_CHAR); }
    
    /* Saltos de línea */
    \n{espacio}* { lexeme = yytext(); return Linea; }
    
    /* Identificadores y números */
    {L}({L}|{D}|"_")*       { lexeme = yytext(); return Identificador; }
    "-"?{D}+(\.{D}+)?       { lexeme = yytext(); return Numero; }
    
    /* Espacios en blanco */
    {espacio}   { /* Ignorar espacios */ }
    
    /* Cualquier otro carácter es un error */
    .           { lexeme = yytext(); return ERROR; }
}

/* ========================= COMENTARIO DE LÍNEA ========================= */
<COMENTARIO_LINEA> {
    [^\r\n]*    { /* Contenido del comentario - ignorar */ }
    \r|\n|\r\n  { 
        yybegin(YYINITIAL); 
        lexeme = yytext(); 
        return Linea; 
    }
    <<EOF>>     { yybegin(YYINITIAL); }
}

/* ========================= COMENTARIO MULTILÍNEA ========================= */
<COMENTARIO_MULTILINEA> {
    [^*\n]+     { /* Contenido del comentario - ignorar */ }
    "*"+"/"     { yybegin(YYINITIAL); }
    "*"+        { /* Asterisco que no cierra el comentario */ }
    \n          { /* Nueva línea dentro del comentario */ }
    <<EOF>>     { 
        // Regreso al estado inicial
        yybegin(YYINITIAL); 
        lexeme = "/* comentario sin cerrar */";
        return ERROR;
    }
}

/* ========================= CADENA STRING ========================= */
<CADENA_STRING> {
    "\""        { 
        // Regreso al estado inicial
        yybegin(YYINITIAL); 
        lexeme = "\"" + cadenaBuffer.toString() + "\"";
        return CadenaText;
    }
    
    \\[nt\"\\r] { 
        procesarEscape(yytext());
    }
    
    \\(.|\n)    { 
        // Escape no reconocido - agregar literal
        cadenaBuffer.append(yytext());
    }
    
    [^\"\\\n]+  { 
        cadenaBuffer.append(yytext()); 
    }
    
    \n          {
        // Regreso al estado inicial
        yybegin(YYINITIAL);
        lexeme = "cadena sin cerrar";
        return ERROR;
    }
    
    <<EOF>>     {
        // Regreso al estado inicial
        yybegin(YYINITIAL);
        lexeme = "cadena sin cerrar al final";
        return ERROR;
    }
}

/* ========================= CADENA CHAR ========================= */
<CADENA_CHAR> {
    "'"         {
        // regreso al estado inical
        yybegin(YYINITIAL);
        String contenido = cadenaBuffer.toString();
        
        // Validar que sea un solo carácter (o escape válido)
        if (contenido.length() == 0) {
            lexeme = "carácter vacío";
            return ERROR;
        } else if (contenido.length() == 1 || 
                  (contenido.length() == 2 && contenido.charAt(0) == '\\')) {
            lexeme = "'" + contenido + "'";
            return CharText;
        } else {
            lexeme = "demasiados caracteres en literal";
            return ERROR;
        }
    }
    
    \\[nt'\\r]  {
        procesarEscape(yytext());
    }
    
    \\(.|\n)    {
        // Escape no reconocido - agregar literal
        cadenaBuffer.append(yytext());
    }
    
    [^'\\\n]    { 
        cadenaBuffer.append(yytext()); 
    }
    
    \n          {
        // regreso al estado inicial
        yybegin(YYINITIAL);
        lexeme = "carácter sin cerrar";
        return ERROR;
    }
    
    <<EOF>>     {
        // Regreso al estado inicial
        yybegin(YYINITIAL);
        lexeme = "carácter sin cerrar al final";
        return ERROR;
    }
}