D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
ID    [a-zA-Z_][a-zA-Z_0-9]*

%{
#include <stdio.h>
#include "ast.h"
#include "y.tab.h"

void count();
void comment();
void unput_if();
int check_type();
%}

%%
"/*"			{ comment(); }

{ID}		{ count(); yylval = initstr(yytext); return(check_type()); }

{D}+{ID}?		{ count(); yylval = initstr(yytext); return(INT); }
{D}*"."{D}+{ID}?	{ count(); yylval = initstr(yytext); return(FLOAT); }

{ID}?'(\\.|[^\\'])+'	{ count(); yylval = initstr(yytext); return(STR); }
{ID}?\"(\\.|[^\\"])*\"	{ count(); yylval = initstr(yytext); return(STR); }

[;,\n\r]  { count(); return(ED); }

"{"		{ count(); return('{'); }
"}"		{ count(); return('}'); }
"("		{ count(); return('('); }
")"		{ count(); return(')'); }

[ \t\v\f]		{ count(); }
<<EOF>>  {  static int once = 0; return once++ ? 0 : ED; }
.			{ /* ignore bad characters */ }

%%

int yywrap()
{
	return(1);
}


void comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}

int row = 1;//the line number (end of grammar)
int funcrow = 0;//the line count for func decl(end - start)
int column = 0;
int columnsp = 0;
#define LINE_DUMP_SIZE 1024
char line_dump[LINE_DUMP_SIZE];
int nocount_flag = 0;
void count()
{
	int i;
	if(nocount_flag){
		nocount_flag = 0;
		return;
	}
	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n'){
      row++;
      funcrow++;
			column = 0;
			columnsp = 0;			
		}else{
			line_dump[column] = yytext[i];
			column++;
			if(yytext[i] == '\t'){
				columnsp+=8;
			}else{
				columnsp++;				
			}
    }
//	ECHO;
}

void unput_if(){
	nocount_flag = 1;
	unput('f');
	unput('i');
	unput('@');
}
int check_type()
{
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(ID);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(ID);
}
