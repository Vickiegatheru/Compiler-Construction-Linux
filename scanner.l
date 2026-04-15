%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
int line_num = 1;
%}

%option noyywrap

%%
"int"       { return INT; }
"return"    { return RETURN; }
"if"        { return IF; }
"else"      { return ELSE; }
"printf"    { return PRINTF; }

[0-9]+      { 
    yylval.ival = atoi(yytext); 
    return NUMBER; 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    yylval.sval = strdup(yytext); 
    return IDENTIFIER; 
}

\"[^\"\n]*\" { 
    yylval.sval = strdup(yytext); 
    return STRING; 
}

">"|"<"|">="|"<="|"==" { return REL_OP; }
"="         { return ASSIGN_OP; }
"+"|"-"|"*"|"/" { return ARITH_OP; }
";"|"("|")"|"{"|"}"|"," { return yytext[0]; }

[ \t\r]+    { /* ignore whitespace */ }
\n          { line_num++; }
.           { printf("Unknown character at line %d: %s\n", line_num, yytext); }

%%
