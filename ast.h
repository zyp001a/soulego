#ifndef __AST_H__
#define __AST_H__
typedef enum _AstType{
	TNODE,
	TSTR,
	TINT,
	TNULL
} AstType;
typedef struct _Ast
{
	AstType type;
	char* str;
	struct _Ast** arr;
	int len;
} Ast;
#define YYSTYPE Ast*
Ast* initnode(char *str);
Ast* initstr(char *str);
Ast* initstrstat(char *str);
Ast* initint(int i);
Ast* initnull();
void print(Ast *ast);
void printpretty(Ast *ast, int ind);
void addnode(Ast *ast, Ast *subast);
void addstr(Ast *ast, char* str);
void addint(Ast *ast, int i);
void addnull(Ast *ast);
#endif // __EXPRESSION_H__


