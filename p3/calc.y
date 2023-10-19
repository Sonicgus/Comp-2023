%{
#include <stdio.h>
extern int yylex(void);
void yyerror(char *);
extern char *yytext;
%}

%token NATURAL IF THEN ELSE

%left '+' '-'
%left '*' '/'
%nonassoc '(' ')'

%%

calculator: expressions                  { printf("%d\n", $1); }
          ;

expressions: expression                 { }
           | expressions ',' expression { printf("%d,", $1); $$ = $3; }
           ;

expression: NATURAL                     { $$ = $1; }
          | expression '+' expression   { $$ = $1 + $3; }
          | expression '-' expression   { $$ = $1 - $3; }
          | expression '*' expression   { $$ = $1 * $3; }
          | expression '/' expression   { $$ = $1 / $3; }
          | '(' expression ')'          { $$ = $2; }
          ;

%%

void yyerror(char *error) {
    printf("%s '%s'\n", error, yytext);
}
