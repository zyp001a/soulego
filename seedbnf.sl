@load "seedexec"

bnfns := classNsNewx("bnf", execns);
nsx(bnfns, bnfns)



classBnfc := classxNewx("ClassBnf", bnfns, classc);
bnfBasec := classObjNewx("base", bnfns, classBnfc)

jsonArrc := classxNewx("JsonArr", bnfns, valc);

astc := classxNewx("Ast", bnfns, jsonArrc);

undc := classxNewx("Und", bnfns);

bnfUndNewx("func", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #key = "Func_" + uidx();
 #m = anyc;
 #ret = anyc;  
 #fc = funcBlockc;
 #newcl = classMemNewx(cl.ns, cl);
 #block = undx(ast[2], newcl)
 #f = funcNewx(key, cl, block, m, ret, _, fc);
 #r = midNewx(valf, [f]Cpt, Str(ast[1]))
 @return r;
})
bnfUndNewx("paragraph", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #args = &ArrMidx;
 @for(#i = 2; i < ast.len(); i++){
  #e = ast[i]
  #mid = undx(e, cl)
  args.push(mid);
 }
 #r = midNewx(paragraphf, [cl, args]Cpt, Str(ast[1]))
 @return r
})
bnfUndNewx("id", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #key = ast[2]
 #r = cgetx(cl, key, {})
 @if(r){
  @return midNewx(idf, [r, cl]Cpt); 
 }
 r = cgetx(cl.ns, key, {}) 
 @if(r){
  @return midNewx(idf, [r, cl.ns]Cpt); 
 }
 die("id not defined "+ast[2])
})

bnfUndNewx("call", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #midfunc = undx(ast[2], cl)
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

 @if(midfunc.func != idf){
  @return midNewx(callmidf, [midfunc, args]Cpt)
 }@else{
  #nsfunc = Classx(midfunc.args[0])
  @if(!nsfunc){
   log(ast[2])  
   die("not function")
  }

  #func = cgetx(nsfunc, c.name, {});//TODO rget
  @if(!func){
   log(nsfunc)
   log(nsfunc.name)   
   log(c.name)
   die("func not defined");
  }
  @return midNewx(callf, [func, args]Cpt)  
 }
})
bnfUndNewx("var", ->(arr ArrCptx, cl Classx)Cpt{
 @return midNewx(valf, [11]Cpt) 
})

bnfUndNewx ->(name Str, func FuncClassMemx)Classx{
 #o = {
  und: func
  //bnf/rec
 }Cpt
 #oc = objxNewx(name, bnfns, bnfBasec, o)
 @return oc
}

undNewx ->(ns Classx)Objx{
 @return objNewx(undc, {
  mem: memNewx(classMemNewx(ns))
 }Cpt)
}


undx ->(ast JsonArr, cl Classx)Midx{
 #id = Str(ast[0])
 #f = cgetx(cl.ns, "ClassBnf_base_"+id, {});//TODO other prefix
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
