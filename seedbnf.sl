@load "seedexec"

bnfns := classNsNewx("bnf", execns);
nsx(bnfns, bnfns)



bnfc := classxNewx("Bnf", bnfns, objc);

jsonArrc := classxNewx("JsonArr", bnfns, valc);

astc := classxNewx("Ast", bnfns, jsonArrc);

undc := classxNewx("Und", bnfns);

bnfUndNewx("paragraph", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #r = midNewx(paragraphf)
 @for(#i = 1; i < ast.len(); i++){
  #e = ast[i]
  #mid = undx(e, cl)
  r.args.push(mid);
 }
 @return r
})
bnfUndNewx("sentence", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #r = undx(ast[1], cl)
 r.ln = Str(ast[2])
 @return r;
})
bnfUndNewx("id", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #r = cgetx(cl, ast[1], {})
 @if(!r){
  r = cgetx(cl.ns, ast[1], {})
 }
 @return r;
})
bnfUndNewx("words", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #nsfunc = cgetx(cl.ns, "Bnf_"+ast[1], {})
 @if(!nsfunc){
  die("und func not defined " + ast[1]);
 }
 @return callClassMemx(Objx(nsfunc.obj).dic["und"], [ast]Cpt, cl) 
})
bnfUndNewx("var", ->(arr ArrCptx, cl Classx)Cpt{
 @return midNewx(valf, [11]Cpt) 
})
bnfUndNewx("call", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 log(arr)
 @return midNewx(valf, [12]Cpt)
 #midfunc = undx(ast[2], cl)
 @if(midfunc.func != idf){
  @return 
 }
 #nsfunc = Classx(midfunc.args[0])
 @if(!nsfunc){
  log(ast[2])
  die("not function")
 }
 #args = &ArrCptx
 @for(#i = 3; i < ast.len(); i++){
  #e = ast[i]
  #arg = undx(e, cl)
  args.push(arg)
 }
 //TODO fill empty
 @if(args.len() == 0){
  #c = voidc
 }@else{
  #c = typepredx(args[0]);
 }
 #func = cgetx(nsfunc, c.name);
 @if(!func){
  log(nsfunc.name)   
  log(c.name)
  die("func not defined");
 }
 @return midNewx(func, args)
})

bnfUndNewx ->(name Str, func FuncClassMemx)Classx{
 #o = {
  und: func
  //bnf/rec
 }Cpt
 #oc = objxNewx(name, bnfns, bnfc, o)
 @return oc
}

undNewx ->(ns Classx)Objx{
 @return objNewx(undc, {
  mem: memNewx(classMemNewx(ns))
 }Cpt)
}


undx ->(ast JsonArr, cl Classx)Midx{
 #id = Str(ast[0])
 #f = cgetx(cl.ns, "Bnf_"+id, {});
 @if(!f){
  log(ast)
  die("ast error, not defined "+ id)
 }
 @return callClassMemx(Objx(f.obj).dic["und"], [ast]Cpt, cl)
}

inx ->(ast JsonArr, und Objx)Cpt{
 #global = Memx(und.dic["mem"])
 #undglobal = global.class
 #mid = undx(ast, undglobal)
 #r = execx(mid, global)
 @return r;
}

recx ->(str Str)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}
