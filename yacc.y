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
	$$ = initnode("paragraph");
	if($1->type != TNULL){
		addnode($$, $1);
	}
}
| paragraph sentence
{
	$$ = $1;
	if($2->type != TNULL){
		addnode($$, $2);
	}
}
;

sentence
: words ED
{
	$$ = initnode("sentence");
	addnode($$, $1);
	addint($$, row);	
}
| ED
{
	$$ = initnull();
}
;

words
: ID 
{
	$$ = initnode("words");	
	addnode($$, $1);
}
| words word
{
	$$ = $1;
	addnode($$, $2);
}
;

word
: INT 
{
	$$ = initnode("int");
	addnode($$, $1);
}
| FLOAT
{
	$$ = initnode("int");
	addnode($$, $1);
}
| STR
{
	$$ = initnode("str");
	addnode($$, $1);
}
| ID
{
	$$ = initnode("id");
	addnode($$, $1);	
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
	$$ = initnode("paragraph");	
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
