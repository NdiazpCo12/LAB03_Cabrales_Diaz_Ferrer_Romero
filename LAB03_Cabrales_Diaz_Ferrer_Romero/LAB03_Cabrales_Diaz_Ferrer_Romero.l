%{
#include "LAB03_Cabrales_Diaz_Ferrer_Romero.tab.h"   /* Funcion que genera bison que incluye tokens y constantes compartidas con el parser */
#include <stdio.h>                                   
#include <string.h>                                  /* Manejo de cadenas */
#include <stdlib.h>                                  
extern int yylineno;                                 /* Número de línea actual */
int token_line = 1;                                  /* Línea del token que se procesa */
%}


%option noyywrap

DIGIT [0-9]
ID [A-Za-z_][A-Za-z0-9_]*
NEWLINE ([\r\n]+)

%%

{NEWLINE} { token_line = yylineno; yylineno++; return NEWLINE; }

[ \t]+ ;

"and" { token_line = yylineno; return AND; }
"else" { token_line = yylineno; return ELSE; }
"is"   { token_line = yylineno; return IS; }
"or" { token_line = yylineno; return OR; }
"not" { token_line = yylineno; return NOT; }
"def" { token_line = yylineno; return DEF; }
"if" { token_line = yylineno; return IF; }
"elif" { token_line = yylineno; return ELIF; }
"for" { token_line = yylineno; return FOR; }
"in" { token_line = yylineno; return IN; }
"while" { token_line = yylineno; return WHILE; }
"return" { token_line = yylineno; return RETURN; }
"pass" { token_line = yylineno; return PASS; }
"break" { token_line = yylineno; return BREAK; }
"continue" { token_line = yylineno; return CONTINUE; }
"import" { token_line = yylineno; return IMPORT; }
"print" { token_line = yylineno; return PRINT; }
"range" { token_line = yylineno; return RANGE; }

"+" { token_line = yylineno; return PLUS; }
"-" { token_line = yylineno; return MINUS; }
"**" { token_line = yylineno; return POWER; }
"*" { token_line = yylineno; return TIMES; }
"/" { token_line = yylineno; return DIVIDE; }
"//" { token_line = yylineno; return FLOOR; }
"%" { token_line = yylineno; return MOD; }
"==" { token_line = yylineno; return EQ; }
"!=" { token_line = yylineno; return NE; }
"<=" { token_line = yylineno; return LE; }
">=" { token_line = yylineno; return GE; }
"<" { token_line = yylineno; return LT; }
">" { token_line = yylineno; return GT; }
"=" { token_line = yylineno; return ASSIGN; }
":" { token_line = yylineno; return COLON; }
"," { token_line = yylineno; return COMMA; }
"(" { token_line = yylineno; return LPAREN; }
")" { token_line = yylineno; return RPAREN; }
"[" { token_line = yylineno; return LBRACKET; }
"]" { token_line = yylineno; return RBRACKET; }


{ID} { token_line = yylineno; yylval.str = strdup(yytext); return IDENTIFIER; }
{DIGIT}+("."{DIGIT}+)?([eE][+-]?{DIGIT}+)? { token_line = yylineno; yylval.str = strdup(yytext); return NUMBER; }

\\'([^\\'\\n]*)\\' { token_line = yylineno; yylval.str = strdup(yytext); return STRING; }
\\\"([^\\\"\\n]*)\\\" { token_line = yylineno; yylval.str = strdup(yytext); return STRING; }


"#".* { ; }
. { token_line = yylineno; return yytext[0]; }
<<EOF>> { return 0; }
%%

