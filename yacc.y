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
%token IDENTIFIER

%token HEX OCT INT BYTE FLOAT INTSCI FLOATSCI STR

%token INC DEC
%token ADD SUB MUL DIV MOD
%token LE GE EQ NE LT GT
%token AND OR

%token ASSIGN ADD_ASSIGN  SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token DEF1 DEF2
%token COLON DOT AMP NOT QUES

%token L1 R1 L2 R2 L3 R3

%token ELLIPSIS
%token CASE DEFAULT IF ELSE SWITCH FOR EACH GOTO CONTINUE BREAK RETURN


%start start
%%

start
: units
{
	*ret = $$;
}
;

units
: unit
{
	$$ = initnode("units");
	if($1->type != TNULL){
		addnode($$, $1);
	}
}
| units unit
{
	$$ = $1;
	if($2->type != TNULL){
		addnode($$, $2);
	}
}
;

unit
: stat
{
	if($1->type != TNULL){
		$$ = initnode("stat");
		addnode($$, $1);
		addint($$, row);
	}
}
| decl
{
	$$ = $1;
}
;

decl
: IDENTIFIER IDENTIFIER DEF1 comp ED
{
	$$ = initnode("decl1");
	addnode($$, $1);
	addnode($$, $2);
	addnode($$, $4);
	addint($$, row);					
}
| IDENTIFIER IDENTIFIER DEF2 stat ED
{
	$$ = initnode("decl2");
	addnode($$, $1);
	addnode($$, $2);
	addnode($$, $4);
	addint($$, row);					
}
;

stat
: open_stat
{
	$$ = $1;	
}
| closed_stat
{
	$$ = $1;
}
;


open_stat
: IF L1 expr R1 stat
| IF L1 expr R1 closed_stat ELSE open_stat
| loop_header open_stat
;

closed_stat
: simple_stat
{
	$$ = $1;
}
| IF L1 expr R1 closed_stat ELSE closed_stat
| loop_header closed_stat
;

simple_stat
: comp_stat
{
	$$ = $1;
}
| expr_stat
{
	$$ = $1;
}
| jump_stat
{
	$$ = $1;
}
;

comp_stat
: params block
;

expr_stat
: ED
{
	$$ = initnull();
}
| expr ED
{
	$$ = $1;
}
;

jump_stat
: GOTO IDENTIFIER ED
| CONTINUE ED
| BREAK ED
| RETURN ED
| RETURN expr ED
;

loop_header
: FOR
{
	$$ = $1;
}
;

expr
: cond_expr
{
	$$ = $1;
}
| unary_expr assign_op expr
;

cond_expr
: or_expr
{
	$$ = $1;
}
| or_expr QUES expr COLON cond_expr
;

or_expr
: and_expr
{
	$$ = $1;
}
| or_expr OR and_expr
;

and_expr
: eq_expr
{
	$$ = $1;
}
| and_expr AND eq_expr
;

eq_expr
: rel_expr
{
	$$ = $1;
}
| eq_expr EQ rel_expr
| eq_expr NE rel_expr
;

rel_expr
: add_expr
{
	$$ = $1;
}
| rel_expr LT add_expr
;

add_expr
: mul_expr
{
	$$ = $1;
}
| add_expr ADD mul_expr
;

mul_expr
: unary_expr
{
	$$ = $1;
}
| mul_expr MUL unary_expr
;

unary_expr
: postfix_expr
{
	$$ = $1;
}
| unary_op unary_expr
;

postfix_expr
: pri_expr
{
	$$ = $1;
}
| postfix_expr L2 expr R2
| postfix_expr L1 R1
| postfix_expr DEC
;

pri_expr
: cons
{
	$$ = $1;
}
| L1 expr R1
{
	$$ = $2;
}
;

unary_op
: NOT
;

assign_op
: ASSIGN
{
	$$ = initstrstat("assign");
}
;

cons
: INT
{
	$$ = initnode("int");
	addnode($$, $1);
}
;

comp
: types params block IDENTIFIER
| params block IDENTIFIER
| types block IDENTIFIER
| types params block
| types block
| params block
| block IDENTIFIER
| block
;

types
: IDENTIFIER
{
	$$ = initnode("types");
	addnode($$, $1);	
}
| types IDENTIFIER
{
	$$ = $1;
	addnode($$, $2);	
}
;

params
: L1 R1
{
	$$ = initnode("params");
}
;

block
: L3 R3
{
	$$ = initnode("units");	
}
| L3 units R3
{
	$$ = $2;	
}
;


%%
void main()
{
	Ast *ast;
  if(!yyparse(&ast)){
		printpretty(ast, 1);
	}
}	
