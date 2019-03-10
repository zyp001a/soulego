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
Ast* initnode(char *str)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->str = str;
	p->type = TNODE;
	return p;
}
Ast* initstrstat(char *str)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->str = str;
	p->len = 1;//is static
	p->type = TSTR;
	return p;
}
Ast* initstr(char *str)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->str = strdup(str);
	p->type = TSTR;
	return p;
}
Ast* initint(int i)
{
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	p->len = i;
	p->type = TINT;	
	return p;
}
static Ast* nullnode;
Ast* initnull()
{
	if(nullnode == NULL){
		nullnode = (Ast*)malloc(sizeof(Ast));
		memset (nullnode, 0, sizeof(Ast));
		nullnode->type = TNULL;
	}
	return nullnode;
}
void print(Ast *ast)
{
	int i;
	if(ast->type == TNODE){//is ast []
		putchar('[');				
  	printf("\"%s\"", ast->str);
		for(i=0; i<ast->len; i++){
			putchar(',');
			print(ast->arr[i]);
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
void addnode(Ast *ast, Ast *subast)
{
	if(ast->len == 0){
		ast->arr = (Ast**)malloc(sizeof(Ast*));
	}else{
		ast->arr = realloc(ast->arr, (ast->len+1)*sizeof(Ast*));		
	}
	ast->arr[ast->len] = subast;
	ast->len ++;
} 
void addstr(Ast *ast, char* str)
{
	Ast *a = initstr(str);
	addnode(ast, a);
}
void addint(Ast *ast, int i)
{
	Ast *a = initint(i);
	addnode(ast, a);
}

