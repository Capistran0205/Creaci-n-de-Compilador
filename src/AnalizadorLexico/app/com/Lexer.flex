package AnalizadorLexico.app.com;

import static Compilador.app.com.Tokens.*;

%%
%class Lexer
%type Tokens

L = [a-zA-Z]
D = [0-9]
espacio = [ \t\r\n]+

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

{espacio} { /* Ignorar espacios */ }
"//".* { /* Ignorar comentario de una línea */ }
"/*"([^*]|\*+[^*/])*\*+ "/" { /* Ignorar comentario multilínea */ }

"=" { lexeme = yytext(); return OperadorAsignacion; }
"+" | "-" | "*" | "/" { lexeme = yytext(); return OperadorAritmetico; }

"(" { lexeme = yytext(); return ParentesisApertura; }
")" { lexeme = yytext(); return ParentesisCierre; }
"{" { lexeme = yytext(); return LlaveApertura; }
"}" { lexeme = yytext(); return LlaveCierre; }

"<<" { lexeme = yytext(); return OperadorSalida; }
">>" { lexeme = yytext(); return OperadorEntrada; }
">" | "<" | ">=" | "<=" { lexeme = yytext(); return OperadorRelacional; }

{L}({L}|{D}|"_")* { lexeme = yytext(); return Identificador; }
"-"?{D}+(\.{D}+)? { lexeme = yytext(); return Numero; }

. { lexeme = yytext(); return ERROR; }
