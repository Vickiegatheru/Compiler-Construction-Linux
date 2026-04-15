%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int line_num;
extern FILE *yyin;
void yyerror(const char *s);

int indent = 0;
void print_node(const char* s) {
    for(int i = 0; i < indent; i++) printf("  | ");
    printf("%s\n", s);
}
%}

%union {
    int ival;
    char* sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER STRING
%token INT RETURN IF ELSE PRINTF REL_OP ASSIGN_OP ARITH_OP
%left ARITH_OP

%%
program:
    { print_node("PROGRAM_START"); indent++; }
    ext_defs
    { indent--; print_node("PROGRAM_END"); }
    ;

ext_defs:
    func_def
    | ext_defs func_def
    ;

func_def:
    INT IDENTIFIER '(' params ')' '{' 
    { printf("  |-- FUNCTION: %s\n", $2); indent++; }
    statements 
    '}'
    { indent--; }
    ;

params:
    /* empty */
    | param_list
    ;

param_list:
    INT IDENTIFIER
    | param_list ',' INT IDENTIFIER
    ;

statements:
    /* empty */
    | statements stmt
    ;

stmt:
    INT IDENTIFIER ';' { printf("  |-- DECLARATION: %s\n", $2); }
    | IDENTIFIER ASSIGN_OP expr ';' { printf("  |-- ASSIGNMENT to %s\n", $1); }
    | RETURN expr ';' { print_node("RETURN_STMT"); }
    | IF '(' expr ')' '{' statements '}' ELSE '{' statements '}' { print_node("IF_ELSE_BLOCK"); }
    | PRINTF '(' STRING ',' expr ')' ';' { print_node("PRINTF_CALL"); }
    ;

expr:
    NUMBER { printf("  |   |-- CONST: %d\n", $1); }
    | IDENTIFIER { printf("  |   |-- VAR: %s\n", $1); }
    | IDENTIFIER '(' args ')' { printf("  |   |-- FUNC_CALL: %s\n", $1); }
    | expr ARITH_OP expr { print_node("ARITH_OP"); }
    ;

args:
    /* empty */
    | arg_list
    ;

arg_list:
    expr
    | arg_list ',' expr
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "PARSER ERROR: %s at line %d\n", s, line_num);
}

int main(int argc, char **argv) {
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if(!yyin) {
            perror("File opening failed");
            return 1;
        }
    }
    yyparse();
    return 0;
}
