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
void comment2();
void unput_if();
int add_ed();
int check_type();
%}

%%
"/*"			{ comment(); }
"//"			{ comment2(); }

{ID}		{ count(); return(check_type()); }

{D}+{ID}?		{ count(); yylval = initstr(yytext); return(INT); }
{D}*"."{D}+{ID}?	{ count(); yylval = initstr(yytext); return(FLOAT); }

{ID}?'(\\.|[^\\'])+'	{ count(); yylval = initstr(yytext); return(STR); }
{ID}?\"(\\.|[^\\"])*\"	{ count(); yylval = initstr(yytext); return(STR); }

[;,\n\r]  { count(); return(ED); }

"{"		{ count(); return('{'); }
"}"		{ return(add_ed('}')); }
"("		{ count(); return('('); }
")"		{ return(add_ed(')')); }

[ \t\v\f]		{ count(); }
<<EOF>>  {  static int once = 0; return once++ ? 0 : ED; }
.			{ /* ignore bad characters */ }

%%

int yywrap()
{
	return(1);
}

void comment2(){
  char c;
	while ((c = input()) != '\n' && c != 0){}
//    putchar(c);
}
void comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0){}
//		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

//	if (c != 0)
//		putchar(c1);
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

int add_edc = 0;
int add_ed(int ret){
  if(add_edc){
    add_edc = 0;
    count();
    return ret;
  }else {
    add_edc = 1;
    unput((char)ret);
    return ED;
  }
}

void unput_if(){
	nocount_flag = 1;
	unput('f');
	unput('i');
	unput('@');
}
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(ID);
*/
int check_type()
{
  if(yytext[0] == '_' && yyleng == 1){
    return(NULLX);
  }
  yylval = initstr(yytext);
	return(ID);
}
