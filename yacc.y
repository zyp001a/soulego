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

%token INT FLOAT STR NULLX

%start start
%%

start
: sentence
{
	*ret = $1;
}
;

end
: ED
| end ED
;
paragraph
: sentence
{
	$$ = init("paragraph", row);
	add($$, $1);
}
| end
{
	$$ = init("paragraph", row);
}
| paragraph sentence
{
	$$ = $1;
	add($$, $2);
}
;

sentence
: words end
{
	$$ = $1;
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
	$$ = $1;
}
| ID
{
	$$ = $1;
}
| NULLX
{
	$$ = init("null", row);
}
| block
{
	$$ = $1;
}
| '(' sentence ')'
{
	$$ = $2;
}
;

block
: '{' paragraph '}'
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
