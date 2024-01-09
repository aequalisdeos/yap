%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h"
int yylex(void);
extern int yylineno;
extern FILE* yyin;
extern FILE* yyout;
void yyerror(char *str);
int yywrap(){
    return 1;
} 
struct ast *newAst(int nodetype, struct ast *l, struct ast *r);
struct ast *newNum(int integer);
struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el);
void treeFree(struct ast *);
struct ast{
    int nodetype;
    struct ast *l;
    struct ast *r;
};
struct numval{
    int nodetype;			
    int number;
};
struct flow{
    int nodetype;			
    struct ast *cond;		
    struct ast *tl;		    
    struct ast *el;		    
};
void robotFunc(int operations, int step);
int checkArea(int step);
int Hand;
int count = 0;
int robot_position[2];
int arr_hall[100][100];
void move(int step);
void paint(int step);
int subPiant(int x1, int y1, int x2, int y2, int x, int y);
int *paintArray = NULL; 
int sewRow; 
%}
%union{
    struct ast *a;
    int number;
}
%token OB CB FCB FOB COMMA SEMICOLON
%token IF ELSE WHILE
%token AREA IS CLEAR
%token UP DOWN LEFT RIGHT
%token PAINT NOTHING 
%token <number> NUMBER
%type <a> command condition else argyment base move operation lenth
%%
commands:
| commands command { eval($2); treeFree($2); }
;
command: IF OB condition CB FOB argyment FCB else { $$ = newFlow('I', $3, $6, $8); }
| IF OB condition CB FOB argyment FCB { $$ = newFlow('I', $3, $6, NULL);  }
| WHILE OB condition CB FOB argyment FCB { $$ = newFlow('W', $3, $6, NULL);  }
| argyment { $$ = newAst('a', $1, NULL); }
;
else: ELSE FOB argyment FCB { $$ = newAst('e', $3, NULL); }
;
condition: AREA IS CLEAR move { $$ = newAst('c', $4, NULL); }
;
move: UP { $$ = newAst('u', NULL, NULL); }
| DOWN { $$ = newAst('d', NULL, NULL); }
| RIGHT { $$ = newAst('r', NULL, NULL); }
| LEFT { $$ = newAst('l', NULL, NULL); }
;
argyment: move base { $$ = newAst('m', $1, $2); }
;
base: OB operation COMMA lenth CB SEMICOLON { $$ = newAst('b', $2, $4); }
;
operation: NOTHING { $$ = newAst('n', NULL, NULL);  }
| PAINT { $$ = newAst('p', NULL, NULL);  }
;
lenth: NUMBER { $$ = newNum($1); }
%%
int main(void){
    char *area = "input.txt";
    FILE* areatext = fopen(area, "r");
    char buffer[256];
    int n = atoi(fgets(buffer, sizeof(buffer), areatext));
    int k = 0, i = 0;
    while((fgets(buffer, sizeof(buffer), areatext))!=NULL)
            {
                for(int j = 0; j < n * 2; j+=2){
                    arr_hall[i][j/2] = buffer[j] - '0';
                }
                i++;
            }
            fclose(areatext);
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            printf("%i ", arr_hall[i][j]);
        }
        printf("\n");
    }
    char *commandFileName = "prog.txt";
    FILE* commandFile = fopen(commandFileName, "r");
    if (commandFile == NULL){
        fprintf(yyout, "%d. Can't open file %s", count, commandFileName);
        exit(1);
    }
    char *robot = "position.txt";
    FILE* robotFile = fopen(robot, "r");
    if (robotFile == NULL){
        fprintf(yyout, "%d. Can't open file %s", count, robot);
        exit(1);
    }
    fseek(robotFile, 0, SEEK_SET);
    fscanf(robotFile, "%d ", &robot_position[0]);
    fscanf(robotFile, "%d", &robot_position[1]);
    char *resultFileName = "output.txt";
    FILE* resultFile = fopen(resultFileName, "w");
    yyin = commandFile;
    yyout = resultFile;
    yyparse();
    fclose(yyin);
    fclose(robotFile);
    fclose(yyout);
    free(paintArray);
    return 0;
}
void yyerror(char *str){
    count++;
    fprintf(yyout ,"%d. error: %s in line %d\n", count, str, yylineno);
    exit(1);
}
struct ast *newAst(int nodetype, struct ast *l, struct ast *r){
    struct ast *a = malloc(sizeof(struct ast));
    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}
struct ast *newNum(int i){
    struct numval *a = malloc(sizeof(struct numval));
    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'K';
    a->number = i;
    return (struct ast *)a;
}
struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el){
    struct flow *a = malloc(sizeof(struct flow));
    if(!a) {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (struct ast *)a;
}
int eval(struct ast *a){
    int value;
    int operations;
    switch(a->nodetype){
        case 'K': value = ((struct numval *)a)->number; break;
        case 'a':
            eval(a->l); 
            break;
        case 'c': 
            Hand = eval(a->l); 
            value = checkArea(1);
            break;
        case 'e': 
            eval(a->l); 
            break;
        case 'm':
            Hand = eval(a->l); 
            eval(a->r); 
            break;
        case 'b': 
            count++;
            operations = eval(a->l); 
            value = eval(a->r); 
            robotFunc(operations, value);
            break;    
        case 'p': 
            value = 'p';
            break;
        case 'n': 
            value = 'n';
            break;
        case 'l': 
            value = 'l';
            break;
        case 'r':    
            value = 'r';
            break;                 
        case 'u': 
            value = 'u';
            break;     
        case 'd': 
            value = 'd';
            break;
        case 'I':
            if(eval(((struct flow *)a)->cond) == 't') { 
                if(((struct flow *)a)->tl) {
                    eval(((struct flow *)a)->tl);
                } else {
                    value = 'f'; 
                }
            } else { 
                if(((struct flow *)a)->el) {
                    eval(((struct flow *)a)->el);
                } else {
                    value = 'f'; 
                }		
            }
            break;
        case 'W':
            value = 'f'; 
            if(((struct flow *)a)->tl) {
                while(eval(((struct flow *)a)->cond) == 't'){
                    eval(((struct flow *)a)->tl);
                }
            }
            break;
    }
    return value;
}
void robotFunc(int operations, int step){
    switch(operations){
        case 'p':
            paint(step);
            fprintf(yyout, "%d. The robot moved to coordinate (%d,%d)\n", count, robot_position[0], robot_position[1]);   
            break;
        case 'n':
            move(step);
            fprintf(yyout, "%d. The robot moved to coordinate (%d,%d)\n", count, robot_position[0], robot_position[1]);      
            break;
    }
}
int checkArea(int step){
    int tempArray[2] = {robot_position[0], robot_position[1]};
    for (int i = 0; i < step; i++){
        switch(Hand){
            case 'l':
                if (arr_hall[tempArray[0] - 1][tempArray[1]] == 1){
                    return 'f';
                }
                break;
            case 'r':
                if (arr_hall[tempArray[0] + 1][tempArray[1]] == 1){
                    return 'f';
                }
                break;
            case 'd':
                if (arr_hall[tempArray[0]][tempArray[1] + 1] == 1){
                    return 'f';
                }
                break;
            case 'u':
                if (arr_hall[tempArray[0]][tempArray[1] - 1] == 1){
                    return 'f';
                }
                break;
        }
        switch(Hand){
            case 'l':
                tempArray[0] -= 1;
                break;
            case 'r':
                tempArray[0] += 1;
                break;
            case 'd':
                tempArray[1] += 1;
                break;
            case 'u':
                tempArray[1] -= 1;
                break;
        }
    }
    return 't';
}
void move(int step){
    switch(checkArea(step)){
        case 't':
            if (Hand == 'l'){
                robot_position[0] -= step;
            }    
            if (Hand == 'r'){
                robot_position[0] += step;
            }    
            if (Hand == 'd'){
                robot_position[1] += step;
            }    
            if (Hand == 'u'){
                robot_position[1] -= step;
            }
            break; 
        case 'f':
            fprintf(yyout, "%d. Error: the robot is trying to move into a wall at coordinate (%d,%d)\n", count, robot_position[0], robot_position[1]);
            exit(0);
            break;
    }
}
void paint(int step){
    if (checkArea(step) == 'f'){
        fprintf(yyout, "%d. Error: the robot is trying to paint a wall at coordinate (%d,%d)\n", count, robot_position[0], robot_position[1]);
        exit(0);
    }
    sewRow++;
    int paintSaveArray = sewRow - 1;
    paintArray = (int*) realloc(paintArray, (sewRow + 1) * 4 * sizeof(int));
    *(paintArray + paintSaveArray * 4 + 0) = robot_position[0];
    *(paintArray + paintSaveArray * 4 + 1) = robot_position[1];
    *(paintArray + paintSaveArray * 4 + 2) = robot_position[0];
    *(paintArray + paintSaveArray * 4 + 3) = robot_position[1] + step;
    robot_position[1] += step;
    fprintf(yyout, "%d. The robot has painted the line from (%d,%d) to (%d,%d)\n", count, *(paintArray + paintSaveArray * 4 + 0), *(paintArray + paintSaveArray * 4 + 1), *(paintArray + paintSaveArray * 4 + 2), *(paintArray + paintSaveArray * 4 + 3));
}
void treeFree(struct ast *a){
    switch(a->nodetype){
        case 'm':
        case 'b':
            treeFree(a->r);
        case 'a':
        case 'e':
            treeFree(a->l);
        case 'K':
        case 'c':
        case 'l':
        case 'r':
        case 'u':
        case 'd':
        case 'n':
        case 'p':
            break;
        case 'I':
        case 'W':
            free( ((struct flow *)a)->cond);
            if( ((struct flow *)a)->tl) free( ((struct flow *)a)->tl);
            if( ((struct flow *)a)->el) free( ((struct flow *)a)->el);
            break;
        default: 
            fprintf(yyout, "%d. internal error: free bad node %c\n", count, a->nodetype);
    }
}
