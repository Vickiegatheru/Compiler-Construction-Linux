%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>

extern int line_num;
extern int is_parsing; // Flag to stop printing tokens during Stage 2
%}

%option noyywrap

%%
"int"       { if(!is_parsing) printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return INT; }
"return"    { if(!is_parsing) printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return RETURN; }
"if"        { if(!is_parsing) printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return IF; }
"else"      { if(!is_parsing) printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ELSE; }
"printf"    { if(!is_parsing) printf("TOKEN: KEYWORD     | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return PRINTF; }

[0-9]+      { 
    if(!is_parsing) printf("TOKEN: NUMBER      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.ival = atoi(yytext); 
    return NUMBER; 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    if(!is_parsing) printf("TOKEN: IDENTIFIER  | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.sval = strdup(yytext); 
    return IDENTIFIER; 
}

\"[^\"\n]*\" { 
    if(!is_parsing) printf("TOKEN: STRING      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    yylval.sval = strdup(yytext); 
    return STRING; 
}

">"|"<"|">="|"<="|"==" { 
    if(!is_parsing) printf("TOKEN: REL_OP      | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    return REL_OP; 
}

"="         { if(!is_parsing) printf("TOKEN: ASSIGN_OP   | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ASSIGN_OP; }
"+"|"-"|"*"|"/" { if(!is_parsing) printf("TOKEN: ARITH_OP    | LEXEME: %-10s | LINE: %d\n", yytext, line_num); return ARITH_OP; }

";"|"("|")"|"{"|"}"|"," { 
    if(!is_parsing) printf("TOKEN: DELIMITER   | LEXEME: %-10s | LINE: %d\n", yytext, line_num);
    return yytext[0]; 
}

[ \t\r]+    { /* ignore whitespace */ }
\n          { line_num++; }
.           { if(!is_parsing) printf("TOKEN: ERROR       | LEXEME: %-10s | LINE: %d\n", yytext, line_num); }
%%
