lex lex.l
yacc -v -d yacc.y
#if warning: 1 shift/reduce conflict [-Wconflicts-sr],
#check y.output, keyword conflict
gcc lex.yy.c y.tab.c ast.c -o parser
