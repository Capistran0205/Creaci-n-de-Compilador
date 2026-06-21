/* ============================================================
   Lexico.flex  -  Analizador lexico (compatible con la interfaz)
   Generador: JFlex 1.4.3
   ------------------------------------------------------------
   yylex() devuelve un Token (enum). El texto reconocido queda
   en el campo publico 'lexeme' para que la interfaz lo lea como
   lexer.lexeme. Se devuelve Token.LINEA en cada salto de linea.
   ============================================================ */

package AnalizadorLexico.app.com;
import java.io.*;

%%

/* ===================== OPCIONES ===================== */
%public
%class AnalizadorLexico
%unicode
%type Token
%xstate COMENTARIO

%{
    /** Texto del ultimo token reconocido. La interfaz lo lee: lexer.lexeme */
    public String lexeme = "";

    /** Guarda el lexema actual y devuelve su tipo de token. */
    private Token tk(Token tipo) {
        lexeme = yytext();
        return tipo;
    }

    /** Prueba opcional por consola (mismo flujo que el boton del JFrame). */
    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            System.out.println("Uso: java AnalizadorLexico <archivo>");
            return;
        }
        AnalizadorLexico lexer =
            new AnalizadorLexico(new BufferedReader(new FileReader(args[0])));
        int numToken = 1, linea = 1;
        Token t;
        while ((t = lexer.yylex()) != null) {
            switch (t) {
                case LINEA -> linea++;
                case ERROR -> System.out.printf("%-3d %-18s Error, simbolo no definido (linea %d)%n",
                                                 numToken++, lexer.lexeme, linea);
                default    -> System.out.printf("%-3d %-18s %s%n",
                                                 numToken++, lexer.lexeme, t);
            }
        }
    }
%}

/* Al fin de archivo devuelve null (termina el while de la interfaz) */
%eofval{
    return null;
%eofval}

/* ===================== MACROS ===================== */
LineTerminator   = \r|\n|\r\n
Letra            = [a-zA-Z]
Digito           = [0-9]
Identificador    = {Letra}({Letra}|{Digito}|_)*
Numero           = {Digito}+("."{Digito}+)?
CadenaLiteral    = @[^@]*@
CaracterLiteral  = '(\\.|[^'\\])'
EspacioBlanco    = [ \t\f]+

%%

/* ===================== REGLAS ===================== */

/* ---- Palabras reservadas (ANTES que IDENTIFICADOR) ---- */
"entero"            { return tk(Token.ENTERO);   }
"decimal"           { return tk(Token.DECIMAL);  }
"caracter"          { return tk(Token.CARACTER); }
"cadena"            { return tk(Token.CADENA);   }
"booleano"          { return tk(Token.BOOLEANO); }
"verdadero"         { return tk(Token.VERDADERO); }
"falso"             { return tk(Token.FALSO);    }
"mt"                { return tk(Token.MT);       }
"inp"               { return tk(Token.INP);      }

/* ---- Fin de instruccion, operadores y simbolos ---- */
":_:"               { return tk(Token.FIN_LINEA);  }
"="                 { return tk(Token.ASIGNACION); }
","                 { return tk(Token.COMA);       }
"'"                 { return tk(Token.COMILLA);    }
"<"                 { return tk(Token.MENOR);      }
">"                 { return tk(Token.MAYOR);      }
"("                 { return tk(Token.PAR_IZQ);    }
")"                 { return tk(Token.PAR_DER);    }
"+"                 { return tk(Token.SUMA);       }
"-"                 { return tk(Token.RESTA);      }
"*"                 { return tk(Token.MULT);       }
"/"                 { return tk(Token.DIV);        }

/* ---- Literales ---- */
{Numero}            { return tk(Token.NUMERO);           }
{CadenaLiteral}     { return tk(Token.CADENA_LITERAL);   }
{CaracterLiteral}   { return tk(Token.CARACTER_LITERAL); }

/* ---- Identificadores (DESPUES de las reservadas) ---- */
{Identificador}     { return tk(Token.IDENTIFICADOR); }

/* ---- Salto de linea: token de control para contar lineas ---- */
{LineTerminator}    { return Token.LINEA; }

/* ---- Comentarios ---- */
"#"[^\r\n]*         { /* comentario de una linea (estilo Python): ignorar */ }
"/*"                { yybegin(COMENTARIO); }   /* inicia comentario multilinea */

/* ---- Salto de linea: token de control para contar lineas ---- */
{LineTerminator}    { return Token.LINEA; }

/* ---- Espacios/tabs: se ignoran ---- */
{EspacioBlanco}     { /* nada */ }

/* ===================== ESTADO: COMENTARIO MULTILINEA ===================== */
/* Dentro del comentario se ignora todo, pero los saltos de linea siguen
   emitiendo Token.LINEA para no descuadrar el conteo de lineas.          */
<COMENTARIO> {
    {LineTerminator}   { return Token.LINEA; }      /* sigue contando lineas */
    "*/"               { yybegin(YYINITIAL); }       /* fin del comentario   */
    [^]                { /* contenido del comentario: ignorar */ }
}

/* ---- Cualquier otro caracter = error lexico ---- */
[^]                 { return tk(Token.ERROR); }
