%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern int token_line;
extern int yylex(void);
extern FILE* yyin;

void record_error(int line);

int yyerror(const char *s);  /* Manejador de errores sintácticos */
int error_count = 0;
int error_lines[1023];
int error_lines_count = 0;
%}

%union { char *str; }  /* Definición del tipo de valor semántico */

%token <str> IDENTIFIER NUMBER STRING
%token AND ELSE IS OR NOT DEF IF ELIF FOR IN WHILE RETURN PASS BREAK CONTINUE IMPORT PRINT RANGE 
%token NEWLINE COLON COMMA LPAREN RPAREN LBRACKET RBRACKET ASSIGN PLUS MINUS TIMES DIVIDE FLOOR MOD POWER EQ NE LE GE LT GT

%start file_input

%%

file_input
    : statements
    ;

statements
    : /* empty */             /* Puede estar vacío (archivo sin código) */
    | statements statement     /* O contener una o más sentencias */
    ;

statement
    : simple_stmt NEWLINE
    | compound_stmt
    | error NEWLINE { record_error(token_line); yyerrok; }    /* Captura error de sintaxis */
    ;

simple_stmt
    : small_stmt
    ;

small_stmt
    : assignment
    | PASS
    | BREAK
    | CONTINUE
    | IMPORT IDENTIFIER
    | PRINT LPAREN opt_expr_list RPAREN
    | RETURN opt_expr
    ;

opt_expr
    : /* empty */
    | expression
    ;

opt_expr_list
    : /* empty */
    | expr_list
    ;

expr_list
    : expression
    | expr_list COMMA expression
    ;

assignment
    : IDENTIFIER ASSIGN expression
    ;

compound_stmt
    : if_stmt
    | for_stmt
    | while_stmt
    | funcdef
    ;

funcdef
    : DEF IDENTIFIER LPAREN opt_params RPAREN COLON NEWLINE statements
    ;

opt_params
    : /* empty */
    | param_list
    ;

param_list
    : IDENTIFIER
    | param_list COMMA IDENTIFIER
    ;

if_stmt
    : IF expression COLON NEWLINE statements elif_list opt_else
    ;

elif_list
    : /* empty */
    | elif_list ELIF expression COLON NEWLINE statements
    ;

opt_else
    : /* empty */
    | ELSE COLON NEWLINE statements
    ;

for_stmt
    : FOR IDENTIFIER IN expression COLON NEWLINE statements
    ;

while_stmt
    : WHILE expression COLON NEWLINE statements
    ;

expression
    : term
    | expression AND term
    | expression OR term
    | NOT expression
    ;

term
    : factor                    /* Operación básica */
    | term PLUS factor
    | term MINUS factor
    | term TIMES factor
    | term DIVIDE factor
    | term FLOOR factor
    | term MOD factor
    | term POWER factor
    ;

range_args
    : expression
    | expression COMMA expression
    ;

primary
    : NUMBER
    | STRING
    | IDENTIFIER
    | LPAREN expression RPAREN
    | LBRACKET expr_list RBRACKET
    | RANGE LPAREN range_args RPAREN
    ;

postfix
    : primary
    | postfix LBRACKET expression RBRACKET
    | postfix LPAREN opt_expr_list RPAREN
    ;

factor
    : postfix  /* Factor básico */
    ;

%%

void record_error(int line) {
    int i;
    for (i = 0; i < error_lines_count; i++)     /* Evita duplicar errores por línea */
        if (error_lines[i] == line)
            return;
    error_lines[error_lines_count++] = line;       /* Guarda la línea con error */

}

int yyerror(const char *s) {
    return 0; /* No imprime mensaje en consola, solo registra error */               
}

int main(int argc, char **argv) {
    yylineno = 1; /* Inicializa contador de línea */

    if (argc > 1) yyin = fopen(argv[1], "r"); /* Si se pasa archivo, lo abre */
    else yyin = stdin; /* Si no, usa entrada estándar */
    yyparse();
    FILE *f = fopen("salida.txt", "w"); 
    if (error_lines_count == 0)  /* Si no hay errores */
        fprintf(f, "Prueba con el archivo de entrada\n0 errores\n");
    else {
        int i;
        fprintf(f, "Prueba con el archivo de entrada\n");
        for (i = 0; i < error_lines_count; i++)
            fprintf(f, "línea %d error\n", error_lines[i]); /* Escribe errores */
    }
    return 0;
}
