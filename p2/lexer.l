%{
    /* place here any C variables and definitions */
    #define YY_USER_ACTION col+=yyleng;
    #define ADDLIN lin++; col=0
    int col=1, lin=0;
%}
digit   [0-9]
letter  [a-zA-Z$_]
identifier {letter}({letter}|{digit})*

reserved    "integer"|"double"|"if"|"then"|"else"

space   " "|"\t"|"\f"
newline "\n"|"\r"|"\r\n"
ola     "("|")"|"="|","|"*"|"/"|"+"|"-"

strlit      \"([^"\\"]|"\\\\"|"\\\""|"\\f"|"\\t"|"\\n"|"\\r")*\"

%X COMENTARIO

%%
{digit}+                { printf("NATURAL(%s)\n",yytext); }
{digit}*"."{digit}+     { printf("DECIMAL(%s)\n",yytext); }
{reserved}              { ;}
{identifier}            { printf("IDENTIFIER(%s)\n",yytext); }
{space}                 {;}

{ola}         {printf("%s\n",yytext);}

{newline}        {ADDLIN;}

"/*"              {BEGIN COMENTARIO;}
<COMENTARIO>"*/"            {BEGIN(0);}
<COMENTARIO>{newline}        {ADDLIN;}
<COMENTARIO><<EOF>>             {return 0;}
<COMENTARIO>.            {BEGIN COMENTARIO;}
{strlit}              {printf("STRLIT(%s)\n",yytext);}

<<EOF>>                                          {return 0;}
.                                                {printf("Line %d, column %d: unrecognized character (%s)\n", lin, col, yytext);}

%%
extern int yylex();
int main() {
    yylex();    /* run the lexical analysis automaton */
    return 0;
}
int yywrap() {  /* called on EOF, return 1 to terminate */
    return 1;
}
