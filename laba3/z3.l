%{
#include <stdio.h>
#include "z3.tab.h"
void Errors();
%}
%option noyywrap
%%
[0-9]+(\.[0-9]+)? { yylval.number = atof(yytext); return NUMBER; }
[-+*/(){}] { return yytext[0]; }
\n { return EOL; }
[ \t] { }
. { Errors(); }
%%
void Errors(){
printf("Something went wrong");
}