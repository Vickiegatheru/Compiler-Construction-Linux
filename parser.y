%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int line_num;
extern FILE *yyin;

void yyerror(const char *s);

int indent = 0;
void print_indent() {
    for(int i = 0; i < indent; i++) printf("  | ");
}
%}

%union {
    int ival;
    char* sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER STRING
%token INT RETURN IF ELSE PRINTF REL_OP ASSIGN_OP ARITH_OP
%left REL_OP
%left ARITH_OP

%%
program:
    { printf("PROGRAM_START\n"); indent++; }
    ext_defs
    { indent--; printf("PROGRAM_END\n"); }
    ;

ext_defs:
    func_def
    | ext_defs func_def
    ;

func_def:
    INT IDENTIFIER '(' params ')' '{' 
    { print_indent(); printf("FUNCTION: %s\n", $2); indent++; }
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
    INT IDENTIFIER ';'              { print_indent(); printf("DECLARATION: %s\n", $2); }
    | INT IDENTIFIER ASSIGN_OP expr ';' { print_indent(); printf("DECLARATION & ASSIGNMENT: %s\n", $2); }
    | IDENTIFIER ASSIGN_OP expr ';' { print_indent(); printf("ASSIGNMENT: %s\n", $1); }
    | RETURN expr ';'               { print_indent(); printf("RETURN_STMT\n"); }
    | IF '(' expr ')' '{' statements '}' ELSE '{' statements '}' { print_indent(); printf("IF_ELSE_BLOCK\n"); }
    | PRINTF '(' STRING ',' expr ')' ';' { print_indent(); printf("PRINTF_CALL\n"); }
    ;

expr:
    NUMBER               { print_indent(); printf("  |-- CONST: %d\n", $1); }
    | IDENTIFIER         { print_indent(); printf("  |-- VAR: %s\n", $1); }
    | IDENTIFIER '(' args ')' { print_indent(); printf("  |-- FUNC_CALL: %s\n", $1); }
    | expr ARITH_OP expr { print_indent(); printf("  |-- ARITH_OP\n"); }
    | expr REL_OP expr   { print_indent(); printf("  |-- REL_OP\n"); }
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
        if(!yyin) { perror("File opening failed"); return 1; }
    }
    yyparse();
    return 0;
}
