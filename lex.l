D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
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

"@switch"		{ count(); return(SWITCH); }
"@case"			{ count(); return(CASE); }
"@default"		{ count(); return(DEFAULT); }

"@for"			{ count(); return(FOR); }
"@each"			{ count(); return(EACH); }

"@goto"			{ count(); return(GOTO); }
"@break"			{ count(); return(BREAK); }
"@continue"		{ count(); return(CONTINUE); }

"@return"		{ count(); return(RETURN); }

"@if"			{ count(); return(IF); }
"@else"			{ count(); return(ELSE); }
"@elif"			{ count(); unput_if(); return(ELSE); }

{ID}		{ count(); yylval = initstr(yytext); return(check_type()); }

0[xX]{H}+{ID}?		{ count(); yylval = initstr(yytext); return(HEX); }
0{D}+{ID}?		{ count(); yylval = initstr(yytext); return(OCT); }
{D}+{ID}?		{ count(); yylval = initstr(yytext); return(INT); }
@'(\\.|[^\\'])+'	{ count(); yylval = initstr(yytext); return(BYTE); }

{D}+{E}{ID}?		{ count(); yylval = initstr(yytext); return(INTSCI); }
{D}*"."{D}+({E})?{ID}?	{ count(); yylval = initstr(yytext); return(FLOAT); }
{D}+"."{D}*({E})?{ID}?	{ count(); yylval = initstr(yytext); return(FLOATSCI); }

{ID}?'(\\.|[^\\'])+'	{ count(); yylval = initstr(yytext); return(STR); }
{ID}?\"(\\.|[^\\"])*\"	{ count(); yylval = initstr(yytext); return(STR); }

"..."			{ count(); return(ELLIPSIS); }

"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }

"++"			{ count(); return(INC); }
"--"			{ count(); return(DEC); }
"&&"			{ count(); return(AND); }
"||"			{ count(); return(OR); }
"<="			{ count(); return(LE); }
">="			{ count(); return(GE); }
"=="			{ count(); return(EQ); }
"!="			{ count(); return(NE); }

"->"			{ count(); return(DEF1); }
"=>"			{ count(); return(DEF2); }

[;,\n\r]  { count(); return(ED); }

("{"|"<%")		{ count(); return(L1); }
("}"|"%>")		{ count(); return(R1); }
("["|"<:")		{ count(); return(L2); }
("]"|":>")		{ count(); return(R2); }
"("			{ count(); return(L3); }
")"			{ count(); return(R3); }
":"			{ count(); return(COLON); }
"."			{ count(); return(DOT); }

"="			{ count(); return(ASSIGN); }

"&"			{ count(); return(AMP); }
"!"			{ count(); return(NOT); }

"+"			{ count(); return(ADD); }
"-"			{ count(); return(SUB); }
"*"			{ count(); return(MUL); }
"/"			{ count(); return(DIV); }
"%"			{ count(); return(MOD); }
"<"			{ count(); return(LT); }
">"			{ count(); return(GT); }
"?"			{ count(); return(QUES); }


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
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}
