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
L = [a-zA-Z]+
D = [0-9]+
espacio = [ , \t, \r, \n]+
%{      
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
%}
%%
// Reglas de Patrón-Acción. Las cuales permiten devolver Símbolos para el analizador sintáctico
int { return new Symbol(sym.TipoInt, yychar, yyline, yytext()); }
string { return new Symbol(sym.TipoString, yychar, yyline, yytext()); }
char { return new Symbol(sym.TipoChar, yychar, yyline, yytext()); }
boolean { return new Symbol(sym.TipoBoolean, yychar, yyline, yytext()); }
double { return new Symbol(sym.TipoDouble, yychar, yyline, yytext()); }
float { return new Symbol(sym.TipoFloat, yychar, yyline, yytext()); }
if { return new Symbol (sym.InstruccionIf, yychar, yyline, yytext()); }
else { return new Symbol (sym.InstruccionElse, yychar, yyline, yytext()); }
while { return new Symbol (sym.InstruccionWhile, yychar, yyline, yytext()); }
cin { return new Symbol (sym.EntradaInfo, yychar, yyline, yytext());}
cout { return new Symbol (sym.SalidaInfo, yychar, yyline, yytext());}
main { return new Symbol (sym.InicioPrograma, yychar, yyline, yytext());}
true { return new Symbol (sym.OperadorTrue, yychar, yyline, yytext()); }
false { return new Symbol (sym.OperadorFalse, yychar, yyline, yytext()); }
"Finish" { return new Symbol (sym.FinPrograma, yychar, yyline, yytext());}
":_:" { return new Symbol (sym.FinLinea, yychar, yyline, yytext());}
"," { return new Symbol (sym.Separador, yychar, yyline, yytext());}
"endl" { return new Symbol (sym.SaltoLinea, yychar, yyline, yytext());}
"concat" { return new Symbol (sym.ConcatenacionText, yychar, yyline, yytext()); } 

{espacio} { /* Ignorar espacios */ }
"//".* { /* Ignorar comentario de una línea */ }
"/"([^]|\+[^/])\+ "/" { /* Ignorar comentario multilínea */ }

"=" { return new Symbol (sym.OperadorAsignacion, yychar, yyline, yytext());}
"+" { return new Symbol (sym.OperadorSuma, yychar, yyline, yytext());}
"-" { return new Symbol (sym.OperadorResta, yychar, yyline, yytext());}
"*" { return new Symbol (sym.OperadorMultiplicacion, yychar, yyline, yytext());}
"/" { return new Symbol (sym.OperadorDivision, yychar, yyline, yytext());}
"+=" { return new Symbol (sym.OperadorASuma, yychar, yyline, yytext()); }
"-=" { return new Symbol (sym.OperadorAResta, yychar, yyline, yytext()); }
"*=" { return new Symbol (sym.OperadorAMultiplicacion, yychar, yyline, yytext()); }
"/=" { return new Symbol (sym.OperadorADivision, yychar, yyline, yytext()); }
"%=" { return new Symbol (sym.OperadorAModulo, yychar, yyline, yytext()); }
"++" { return new Symbol (sym.OperadorIncremento, yychar, yyline, yytext());}
"--" {return new Symbol (sym.OperadorDecremento, yychar, yyline, yytext());}

"&&" { return new Symbol (sym.OperadorLAnd, yychar, yyline, yytext());}
"||" { return new Symbol (sym.OperadorLOr, yychar, yyline, yytext());}
"!" { return new Symbol (sym.OperadorLNot, yychar, yyline, yytext());}

"<<" { return new Symbol (sym.OperadorSalida, yychar, yyline, yytext()); }
">>" { return new Symbol (sym.OperadorEntrada, yychar, yyline, yytext());}
">" { return new Symbol (sym.OperadorMayor, yychar, yyline, yytext());}
"<" { return new Symbol (sym.OperadorMenor, yychar, yyline, yytext());}
">=" { return new Symbol (sym.OperadorMayorIgual, yychar, yyline, yytext());}
"<=" { return new Symbol (sym.OperadorMenorIgual, yychar, yyline, yytext());}
"==" { return new Symbol (sym.OperadorIgual, yychar, yyline, yytext());}
"!=" { return new Symbol (sym.OperadorDiferente, yychar, yyline, yytext());}

"(" { return new Symbol (sym.ParentesisApertura, yychar, yyline, yytext());}
")" { return new Symbol (sym.ParentesisCierre, yychar, yyline, yytext());}
"{" { return new Symbol (sym.LlaveApertura, yychar, yyline, yytext()); }
"}" { return new Symbol (sym.LlaveCierre, yychar, yyline, yytext()); }
"[" { return new Symbol (sym.CorcheteApertura, yychar, yyline, yytext()); }
"]" { return new Symbol (sym.CorcheteCierre, yychar, yyline, yytext()); }

{L}({L}|{D}|"_")* { return new Symbol (sym.Identificador, yychar, yyline, yytext()); }
"-"?{D}+(\.{D}+)? { return new Symbol (sym.Numero, yychar, yyline, yytext()); }
\"([^\"\\\n]|\\[nt\"\\])*\"  { return new Symbol(sym.CadenaText, yychar, yyline, yytext()); }
\'([^\'\\\n]|\\[nt\'\\])\' { return new Symbol(sym.CharText, yychar, yyline, yytext()); }

. { return new Symbol (sym.ERROR, yychar, yyline, yytext());}