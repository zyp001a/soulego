@load "seedexec"

bnfns := classNsNewx("bnf", execns);
nsx(bnfns, bnfns)



bnfc := classxNewx("Bnf", bnfns);

bnfBasec := objxNewx("base", bnfns, bnfc)
bnfBaseo := Objx(bnfBasec.obj)

jsonArrc := classxNewx("JsonArr", bnfns, valc);

astc := classxNewx("Ast", bnfns, jsonArrc);

undc := classxNewx("Und", bnfns);

bnfUndNewx("func", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #m = anyc;
 #ret = anyc;  
 #fc = funcBlockc;
 #newcl = classMemNewx(cl.ns, cl);
 
 @if(ast.len() >3){
  #key = Str(undx(ast[2], cl).args[0])
  #block = undx(ast[3], newcl)
 }@else{
  @if(ast[1] != ""){
   #key = "Func_" + uidx();
  }@else{
   #key = Str(ast[1])
  }
  #block = undx(ast[2], newcl)  
 }

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
 #r = cmgetx(cl, key)
 @if(r){
  @return r
 }
 die("id not defined "+key)
})
/*
bnfUndNewx("funcns", ->(arr ArrCptx, clx Classx)Cpt{
// #ast = JsonArr(arr[0])
 #key = Str(arr[1])
 #r = classNsFuncNewx(key, clx.ns)
 @return midNewx(valf, [r]Cpt)
})
*/
bnfUndNewx("get", ->(arr ArrCptx, clx Classx)Cpt{
 #ast = JsonArr(arr[0]) 
 #clmid = undx(ast[2], clx)
 #key = JsonArr(ast[3])[2]
 @if(clmid.func.id == valf.id || clmid.func.id == idf.id){
  #cl = Classx(clmid.args[0])
  #r = cgetx(cl, key);
  @if(!r){   
   die("key not get: " + key);
  }
  @return midNewx(getf, [r, cl, key]Cpt);
 }
 log(clmid.func.name)
 log(valf.name)
 die("get not defined")
})
bnfUndNewx("set", ->(arr ArrCptx, cl Classx)Cpt{
})
bnfUndNewx("call", ->(arr ArrCptx, cl Classx)Cpt{
 log("call "+cl.ns.cpath)
 #ast = JsonArr(arr[0])
 #midfunc = undx(ast[2], cl)
 #args = &ArrCptx
 @for(#i = 3; i < ast.len(); i++){
  #e = ast[i]
  #arg = undx(e, cl)
  args.push(arg)
 }
 @return midNewx(callmidf, [midfunc, args]Cpt)
})
  

bnfUndNewx("calln", ->(arr ArrCptx, cl Classx)Cpt{
 log("calln "+cl.ns.cpath)
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

 #name = Str(midfunc.args[0])
 #func = nscgetx(cl, name, c);
 @if(!func){
  log(cl.ns.cpath) 
  log(name)
  log(c.name)  
  die("func not defined");
 }
 @return midNewx(callf, [func, args]Cpt)  
})
bnfUndNewx("str", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 @return midNewx(valf, [ast[2], strc]Cpt) 
})
bnfUndNewx("var", ->(arr ArrCptx, cl Classx)Cpt{
 @return midNewx(valf, [11]Cpt) 
})

bnfUndNewx ->(name Str, func FuncClassMemx)Dic{
 #o = {
  und: func
  //bnf/rec
 }Cpt
 DicCptx#dic = bnfBaseo.dic
 dic[name] = o
 @return o
}

undNewx ->(ns Classx)Objx{
 @return objNewx(undc, {
  mem: memNewx(classMemNewx(ns))
 }Cpt)
}


undx ->(ast JsonArr, cl Classx, key Str)Midx{//TODO with bnf obj
 #id = Str(ast[0])
 DicCptx#dic = bnfBaseo.dic
 #f = dic[id];
 @if(!f){
  log(ast)
  die("ast error, not defined "+ id)
 }
 @return callClassMemx(DicCptx(f)["und"], [ast, key]Cpt, cl)
}

inx ->(ast JsonArr, und Objx, key Str)Cpt{
 #global = Memx(und.dic["mem"])
 #undglobal = global.class
 #mid = undx(ast, undglobal, key)
 #r = execx(mid, global)
 @return r;
}

recx ->(str Str)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(str) 
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}
