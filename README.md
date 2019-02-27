It is not a program, it is a creature.

# Features

# Grammar
The grammar is a modification of ANSI C grammar.
* https://github.com/zyp001a/ansi-c-grammar

## new symbol
@ keyword and string grammar

A? a? -> C+()?R?{}?E?

a => 1
a = 1
Dic<A>

{}


## general modification
* no need for main function, start from compound_statement without { }, global var with keyword "@global"
* use @'' for char; use @"" for char*; '', "", `` are all strings;
* change or remove all "," related grammar
* "," and "\n" are consider as ";"
* add dictionary grammar, change array grammar (JS like)
* pointers are used by default, -> is ., so no static defined struct, * & are used as different meaning
* pseudo OOP support, object grammar (GO like, &Class{})
* change function definition, which is also class (GO style, JS internal)
* struct, enum, union is static class, function is dynamic class
* sum type support (Haskell, enum + union)

* template grammar ("@`*`", default PHP like, "<= >" to "~= ~")
* command grammar (bash like, begin with $)
* big number support (1b)
* named arguments, default function def (R/Python like, "call(x, a=1, b=2)")
* substr, arr splice, index -1 ...(R/Python like, "a[-1]; a[1:2]; b=[1,2]; a[b]")
* lexical error handlering (deno vo feature)
* concurrent grammar, parallel grammar, dim grammar (deno vo feature)
* lamada is not supported (I don't like it for low readablilty), but there are iterator grammars, (x1 = @each e x e+1;) and matrix grammar.

## function definition


# Namespace
* def
** base
*** Ast Json 
*** Ns Scope
*** Class Obj Int Float Str Arr Dic Func
*** Stack State
*** Main Env Call Id
** ns
** id
** main
* rec
** base
** static
** main
* exe
** base
*** Env Call Id
** main
*** Main
* mon
** base
** main
* out
** base
** main
   --    rec
	        ^
	|		    |
exec <-- def --> out
  |       |
	        
   --   mon