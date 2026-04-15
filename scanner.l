%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>

extern int line_num;
%}

%option noyywrap

%%
"int"       { printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return INT; }
"return"    { printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return RETURN; }
"if"        { printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return IF; }
"else"      { printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ELSE; }
"printf"    { printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return PRINTF; }

[0-9]+      { 
    printf("TOKEN: NUMBER      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.ival = atoi(yytext); 
    return NUMBER; 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    printf("TOKEN: IDENTIFIER  | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.sval = strdup(yytext); 
    return IDENTIFIER; 
}

\"[^\"\n]*\" { 
    printf("TOKEN: STRING      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.sval = strdup(yytext); 
    return STRING; 
}

">"|"<"|">="|"<="|"==" { 
    printf("TOKEN: REL_OP      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    return REL_OP; 
}

"="         { printf("TOKEN: ASSIGN_OP   | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ASSIGN_OP; }
"+"|"-"|"*"|"/" { printf("TOKEN: ARITH_OP    | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ARITH_OP; }

";"|"("|")"|"{"|"}"|"," { 
    printf("TOKEN: DELIMITER   | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    return yytext[0]; 
}

[ \t\r]+    { /* ignore whitespace */ }
\n          { line_num++; }
.           { printf("TOKEN: ERROR       | LEXEME: %-10s | LINE: %d\n", yytext, line_num); }
%%
