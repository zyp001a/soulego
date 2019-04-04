%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>		
#include "ast.h"		

extern char yytext[];
extern char line_dump[];
extern int row;
extern int funcrow;
extern int column;
extern int columnsp;
int yylex (void);	

void yyerror(YYSTYPE* ret, const char *s)
{
	fflush(stdout);
	printf("Line: %d\n", row);
  printf("%.*s\n", column, line_dump);		
	printf("%*c%c\n", columnsp, ' ', '^');
  printf("%s\n", s);
}
 
%}
%parse-param {YYSTYPE* ret}

%token ED
%token ID

%token INT FLOAT STR

%start start
%%

start
: paragraph
{
	*ret = $$;
}
;

paragraph
: sentence
{
	$$ = init("paragraph", row);
	add($$, $1);
}
| paragraph sentence
{
	$$ = $1;
	add($$, $2);
}
;

sentence
: words ED
{
	$$ = $1;
}
| ED
{
	$$ = NULL;
}
;

words
: ID
{
	$$ = init($1->str, row);
	free($1);
}
| words word
{
	$$ = $1;
	add($$, $2);
}
;

word
: INT 
{
	$$ = init("int", row);
	add($$, $1);
}
| FLOAT
{
	$$ = init("float", row);
	add($$, $1);
}
| STR
{
	$$ = init("str", row);
	add($$, $1);
}
| ID
{
	$$ = init("id", row);
	add($$, $1);
}
| block
{
	$$ = $1;
}
| '(' words ')'
{
	$$ = $2;
}
;

block
: '{' '}'
{
	$$ = init("paragraph", row);	
}
| '{' paragraph '}'
{
	$$ = $2;	
}
;


%%
void main()
{
	Ast *ast;
  if(!yyparse(&ast)){
		print(ast);
	}
}	
