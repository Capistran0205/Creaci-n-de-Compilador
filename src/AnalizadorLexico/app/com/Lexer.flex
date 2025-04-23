package AnalizadorLexico.app.com;
import Compilador.app.com.Tokens;
import static Compilador.app.com.Tokens.*;

%%
%public
%class Lexer
%type Tokens

L = [a-zA-Z]+
D = [0-9]+
espacio = [ , \t, \r]+

%{
    public String lexeme;
%}
%%
int | string | char | boolean | double | float { lexeme = yytext(); return TipoDato; }
if | else { lexeme = yytext(); return InstruccionCondicional; }
while { lexeme = yytext(); return InstruccionBucle; }
cin { lexeme = yytext(); return EntradaInfo; }
cout { lexeme = yytext(); return SalidaInfo; }
main { lexeme = yytext(); return InicioPrograma; }
"Finish" { lexeme = yytext(); return FinPrograma; }
":_:" { lexeme = yytext(); return FinLinea; }
"," { lexeme = yytext(); return Separador; } 
"endl" { lexeme = yytext(); return SaltoLinea; }
"concat" { lexeme = yytext(); return ConcatenacionText; }

{espacio} { /* Ignorar espacios */ }
"//".* { /* Ignorar comentario de una línea */ }
"/*"([^*]|\*+[^*/])*\*+ "/" { /* Ignorar comentario multilínea */ }

\n[\t\r]* { lexeme = yytext(); return Linea; }
"=" { lexeme = yytext(); return OperadorAsignacion; }
"+" | "-" | "*" | "/" { lexeme = yytext(); return OperadorAritmetico; }

"+=" | "-="  | "*=" | "/=" | "%=" {lexeme = yytext(); return OperadorAtribucion;}
"++" {lexeme = yytext(); return OperadorIncremento;}
"--" {lexeme = yytext(); return OperadorDecremento;}
true | false {lexeme = yytext(); return OperadorBooleano;}
"<<" { lexeme = yytext(); return OperadorSalida; }
">>" { lexeme = yytext(); return OperadorEntrada; }
">" | "<" | ">=" | "<=" | "==" | "!=" { lexeme = yytext(); return OperadorRelacional; }
"&&" | "||" | "!" { lexeme = yytext(); return OperadorLogico;}

"(" { lexeme = yytext(); return ParentesisApertura; }
")" { lexeme = yytext(); return ParentesisCierre; }
"{" { lexeme = yytext(); return LlaveApertura; }
"}" { lexeme = yytext(); return LlaveCierre; }
"[" { lexeme = yytext(); return CorcheteApertura; }
"]" { lexeme = yytext(); return CorcheteCierre; }

{L}({L}|{D}|"_")* { lexeme = yytext(); return Identificador; }
"-"?{D}+(\.{D}+)? { lexeme = yytext(); return Numero; }
\"([^\"\\\n]|\\[nt\"\\])*\" { lexeme = yytext(); return CadenaText; }
\'([^\'\\\n]|\\[nt\'\\])\'  { lexeme = yytext(); return CharText; }

. { lexeme = yytext(); return ERROR; }
