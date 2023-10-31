%{
    #include "y.tab.h"
    #include <string.h>
    int yyparse(void);

    #define YY_USER_ACTION column += yyleng;
    #define ADDLINE line++; column = 1;

    int line = 1, column = 1;
    int line_yacc = 1, column_yacc = 1;
%}

digit                   [0-9]
words                   if|else|then
spaces                  \ |\t|\n

%%

{digit}+                { yylval = atoi(yytext); return NATURAL; }
[()=,*/+-]              { return yytext[0]; }
{words}                 { if(strcmp(yytext, "if") == 0) return IF; if(strcmp(yytext, "then") == 0) return THEN; if(strcmp(yytext, "else") == 0) return ELSE;}
\n                      { return 0; }
{spaces}                { if(strcmp(yytext, "\n") == 0) ADDLINE; }
.                       { printf("Unrecognized character\n"); }

%%

int main() {
    yyparse();
    return 0;
}
int yywrap() {
    return 1;
}