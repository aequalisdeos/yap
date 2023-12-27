%{
#include <stdio.h>
%}
%%
[0-9]+ { printf("integer number\n"); }
[+-]?[0-9]+\.[0-9]+ {printf("float number\n"); }
[a-zA-Z]+ { printf("string\n"); }
"+" { printf("plus\n"); }
"-" { printf("minus\n"); }
"*" { printf("multiplication\n"); }
"/" { printf("division\n"); }
"(" { printf("left bracket\n"); }
")" { printf("right bracket\n"); }
"." { printf("point\n"); }
"," { printf("comma\n"); }
"%" { printf("percent\n"); }
"&" { printf("ampersand\n"); }
"!" { printf("exclamation mark\n"); }
"%" { printf("question mark\n"); }
. { printf("unknown\n"); }
%%
int main() {
yylex();
return 0;
}