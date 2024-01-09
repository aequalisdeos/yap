%{
#include <stdlib.h>
#include "parser.tab.h"
#include <string.h>
%}
%%
[0-9]+ { yylval.number=atoi(yytext); return NUMBER; }
"("     { return OB; }
")"     { return CB; }
"{"     { return FOB; } 
"}"     { return FCB; }
","     { return COMMA; }
";"     { return SEMICOLON; }
"if"    { return IF; }
"else"  { return ELSE; }
"while" { return WHILE; }
"area" { return AREA; }
"is"   { return IS; }
"clear"   { return CLEAR; }
"up" { return UP; }
"down" { return DOWN; }
"left" { return LEFT; }
"right" { return RIGHT; }
"paint" { return PAINT; }
"nothing" { return NOTHING; }
[ \t\n]+  ; 
%%