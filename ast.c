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
char strbuf[MAXBUF];
Ast* initstr2(char *str, char q)
{
	int i = -1;
	Ast* p = (Ast*)malloc(sizeof(Ast));
	memset (p, 0, sizeof(Ast));
	int start = 0;
	int nlen = 0;	
	int cur = 0;
	while(1){
		i++;
		if(!start){
			if(str[i] == q){
				start = 1;
			}
		}else{
			if(str[i] == q){
				break;
			}			
			if(str[i] == '\\' && str[i+1] == q){
				strbuf[cur] = str[i+1];
				i++;				
			}else{
				strbuf[cur] = str[i];
			}
			nlen ++;
			cur ++;
		}
	}
	p->str = malloc(nlen+1);
	strncpy(p->str, strbuf, nlen);
	p->str[nlen] = 0;
	p->ln = -2;
	return p;
}
void print(Ast *ast)
{
	int i;
	if(ast->ln >= 0){//is ast []
		putchar('[');				
  	printf("\"%s\",\"%d\"", ast->str, ast->ln);
		for(i=0; i<ast->len; i++){
			putchar(',');
			print(ast->arr[i]);
		}
		putchar(']');
	}else if(ast->ln == -1){
		putchar('"');		
	 	fprintf(stdout, "%s", ast->str);
		putchar('"');		
	}else{		
		putchar('"');
		for(i=0; i<strlen(ast->str); i++){
			if(ast->str[i] == '"'){
				fprintf(stdout, "\\%c", ast->str[i]);
			}else{
				fprintf(stdout, "%c", ast->str[i]);				
			}
		}
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
