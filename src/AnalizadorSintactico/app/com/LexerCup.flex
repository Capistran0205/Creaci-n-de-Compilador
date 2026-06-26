/* ============================================================
   LexerCup.flex  -  Lexer que alimenta al parser CUP
   Generador: JFlex 1.4.3   (modo %cup)
   ------------------------------------------------------------
   Depende de sym.java (lo genera CUP). Devuelve Symbol e
   IGNORA comentarios, espacios y saltos de linea.         
   ============================================================ */

package AnalizadorSintactico.app.com;

import java_cup.runtime.*;

%%

%public
%class LexerCup
%unicode
%cup
%line
%column

%{
    /* Symbol sin valor (palabras clave, operadores, simbolos) */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    /* Symbol con valor (identificadores y literales) */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator   = \r|\n|\r\n
Letra            = [a-zA-Z]
Digito           = [0-9]
Identificador    = {Letra}({Letra}|{Digito}|_)*
Numero           = {Digito}+("."{Digito}+)?
CadenaLiteral    = @[^@]*@
CaracterLiteral  = '(\\.|[^'\\])'
Espacio          = {LineTerminator}|[ \t\f]

%%

/* ---- Palabras reservadas ---- */
"entero"            { return symbol(sym.ENTERO);   }
"decimal"           { return symbol(sym.DECIMAL);  }
"caracter"          { return symbol(sym.CARACTER); }
"cadena"            { return symbol(sym.CADENA);   }
"booleano"          { return symbol(sym.BOOLEANO); }
"verdadero"         { return symbol(sym.VERDADERO);     }
"falso"             { return symbol(sym.FALSO);    }
"mt"                { return symbol(sym.MT);       }
"inp"               { return symbol(sym.INP);      }

/* ---- Fin de instruccion, operadores y simbolos ---- */
":_:"               { return symbol(sym.FIN_LINEA);        }
"="                 { return symbol(sym.ASIGNACION); }
","                 { return symbol(sym.COMA);       }
"'"                 { return symbol(sym.COMILLA);    }
"<"                 { return symbol(sym.MENOR);      }
">"                 { return symbol(sym.MAYOR);      }
"("                 { return symbol(sym.PAR_IZQ);    }
")"                 { return symbol(sym.PAR_DER);    }
"+"                 { return symbol(sym.SUMA);       }
"-"                 { return symbol(sym.RESTA);      }
"*"                 { return symbol(sym.MULT);       }
"/"                 { return symbol(sym.DIV);        }
"^"                 { return symbol(sym.POT);   }

/* ---- Literales (llevan su lexema como valor) ---- */
{Numero}            { return symbol(sym.NUMERO,           yytext()); }
{CadenaLiteral}     { return symbol(sym.CADENA_LITERAL,   yytext()); }
{CaracterLiteral}   { return symbol(sym.CARACTER_LITERAL, yytext()); }

/* ---- Identificadores ---- */
{Identificador}     { return symbol(sym.IDENTIFICADOR,    yytext()); }

/* ---- Comentarios: se ignoran (yyline cuenta los saltos internos) ---- */
"#"[^\r\n]*         { /* comentario de una linea (estilo Python) */ }
"/*" ~"*/"          { /* comentario multilinea (estilo C/Java)    */ }

/* ---- Espacios y saltos de linea: se ignoran ---- */
{Espacio}           { /* nada */ }

/* ---- Caracter no reconocido: se emite un token ERROR para que el
        parser lo marque (en vez de descartarlo en silencio) ---- */
[^]                 { return symbol(sym.ERROR, yytext()); }
