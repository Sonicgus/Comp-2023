%{
    /* place here any C variables and definitions */
    #define ADDCOL col+=yyleng;
    #define ADDLIN lin++; col=1
    int col=1, lin=0;
%}
digit   [0-9]
letter  [a-zA-Z$_]
identifier {letter}({letter}|{digit})*

reserved    "integer"|"double"|"if"|"then"|"else"

space   " "|"\t"|"\f"

ola     "("|")"|"="|","|"*"|"/"|"+"|"-"

%%
{digit}+                { printf("NATURAL(%s)\n",yytext); ADDCOL;}
{digit}*"."{digit}+     { printf("DECIMAL(%s)\n",yytext);ADDCOL; }
{reserved}              {ADDCOL; }
{identifier}            { printf("IDENTIFIER(%s)\n",yytext);ADDCOL; }
{space}                 {ADDCOL;}

{ola}         {printf("%s\n",yytext); ADDCOL;}

"\n"|"\r"|"\r\n"        {ADDLIN;}

<<EOF>>                                          {return 0;}
.                                                {printf("Line %d, column %d: unrecognized character (%s)\n", lin, col, yytext); ADDCOL;}

%%
extern int yylex();
int main() {
    yylex();    /* run the lexical analysis automaton */
    return 0;
}
int yywrap() {  /* called on EOF, return 1 to terminate */
    return 1;
}
