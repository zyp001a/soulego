#ifndef __AST_H__
#define __AST_H__
typedef struct _Ast
{
	char* str;
	struct _Ast** arr;
	int len;
	int ln; //ln = -2: string | ln = -1: id
	void* info;
} Ast;
#define YYSTYPE Ast*
#define MAXBUF 1024*1024
Ast* init(char *str, int ln);
Ast* initstr(char *str);
Ast* initstr2(char *str, char q);
void print(Ast *ast);
void add(Ast *ast, Ast *subast);

//void printpretty(Ast *ast, int ind);
#endif // __EXPRESSION_H__


