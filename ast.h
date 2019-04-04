#ifndef __AST_H__
#define __AST_H__
typedef struct _Ast
{
	char* str;
	struct _Ast** arr;
	int len;
	int ln; //ln = -1: string
} Ast;
#define YYSTYPE Ast*
Ast* init(char *str, int ln);
Ast* initstr(char *str);
void print(Ast *ast);
void add(Ast *ast, Ast *subast);

//void printpretty(Ast *ast, int ind);
#endif // __EXPRESSION_H__


