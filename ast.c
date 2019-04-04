#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
/*
 generate ast 
 ["main",
   ["func", ""]
 ]
*/
Ast* init(char *str, int ln)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->str = str;
	p->ln = ln;
	return p;
}
Ast* initstr(char *str)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->str = strdup(str);
	p->ln = -1;
	return p;
}
void print(Ast *ast)
{
	int i;
	if(ast->ln != -1){//is ast []
		putchar('[');				
  	printf("\"%s\",\"%d\"", ast->str, ast->ln);
		for(i=0; i<ast->len; i++){
			putchar(',');
			print(ast->arr[i]);
		}
		putchar(']');
	}else{
		putchar('"');
  	fprintf(stdout, "%s", ast->str);
		putchar('"');
	}
}
/*
void printpretty(Ast *ast, int ind)
{
	int i;
	if(ast->type == TNODE){//is ast []
		putchar('[');
		if(ast->len > 0){
			printf("\n%*c", ind, ' ');			
		}
  	printf("\"%s\"", ast->str);
		for(i=0; i<ast->len; i++){
			putchar(',');
			printf("\n%*c", ind, ' ');						
			printpretty(ast->arr[i], ind+1);
		}
		if(ast->len > 0){
			if(ind <= 1)
				putchar('\n');
			else
				printf("\n%*c", ind-1, ' ');
		}
		putchar(']');
	}else if(ast->type == TSTR){//is str
		putchar('"');
  	fprintf(stdout, "%s", ast->str);
		putchar('"');
	}else{
  	printf("\"%d\"", ast->len);				
	}
}
*/
void add(Ast *ast, Ast *subast)
{
	if(subast == NULL){
		return;
	}
	if(ast->len == 0){
		ast->arr = (Ast**)malloc(sizeof(Ast*));
	}else{
		ast->arr = realloc(ast->arr, (ast->len+1)*sizeof(Ast*));		
	}
	ast->arr[ast->len] = subast;
	ast->len ++;
} 
