@load "seedexec"
NativeFuncClassMemx ->(JsonArr, Classx, Classx, Str)Cpt
bnfns := classNsNewx("bnf", execns);
nsx(bnfns, bnfns)


bnfc := classxNewx("Bnf", bnfns);

bnfBasec := objxNewx("base", bnfns, bnfc)
bnfBaseo := Objx(bnfBasec.obj)

jsonArrc := classxNewx("JsonArr", bnfns, valc);

astc := classxNewx("Ast", bnfns, jsonArrc);

undc := classxNewx("Und", bnfns);
funcClassMemc := classxNewx("FuncClassMem", bnfns, funcc);

bnfUndNewx("arg", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #argcl = getIdx(ast[2], cl)
 #key = getStrx(ast[3])//TODO auto key
 #func = Funcx(belong.obj)
 func.args.push(&Argx{
  name: key,
  class: argcl
 })
 #ncl = classNewx(key, argcl)
 nsx(ncl, cl)
 @return midNewx(valf, [1]Cpt)//TODO delete
})
bnfUndNewx("block", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #func = Funcx(belong.obj)
 func.val = undx(ast[2], cl)
 @return midNewx(valf, [1]Cpt)//TODO delete
})
bnfUndNewx("def", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #prt = getIdx(ast[2], cl);
 @if(name != ""){
  #key = name;
  #ind = 3
 }@else{
  #key = getStrx(ast[3], prt.name + "_" + uidx());
  #ind = 4;
 }
 #func = classNewx(key, prt);
 @if(cinx(prt, funcc)){
  #x = &Funcx{
   class: prt
  }
  x.args = &ArrArgx
  func.obj = x
  #newcl = classMemNewx(cl.ns, cl); 
  @for(#i=ind; #i<ast.len(); i++){
   undx(ast[i], newcl, func);
  } 
  #r = midNewx(valf, [func]Cpt, Str(ast[1]))
 }@else{
  die("TODO! def not func")
 }
 @return r;
})
bnfUndNewx("paragraph", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #args = &ArrMidx;
 @for(#i = 2; i < ast.len(); i++){
  #e = ast[i]
  #mid = Midx(undx(e, cl, belong))
  args.push(mid);
 }
 #r = midNewx(paragraphf, [cl, args]Cpt, Str(ast[1]))
 @return r
})
bnfUndNewx("id", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #key = ast[2]
 #r = cmgetx(cl, key)
 @if(r){
  @return r
 }
 die("id not defined "+key)
})
bnfUndNewx("get", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #key = getStrx(ast[3])
 #clmid = undx(ast[2], cl) 
 @if(clmid.func.id == valf.id || clmid.func.id == idf.id){
  #from = Classx(clmid.args[0])
  #r = cgetx(from, key);
  @if(!r){   
   die("key not get: " + key);
  }
  @return midNewx(getf, [r, from, key]Cpt);
 }
 //TODO get from expr/ not static
 log(clmid.func.name)
 log(valf.name)
 die("get not defined")
})
bnfUndNewx("exec", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #block = undx(ast[2], cl)
 @return block;
})
bnfUndNewx("call", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 #midfunc = undx(ast[2], cl)
 #name = Str(midfunc.args[0])
 log("call func: "+name)
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

 #func = nscgetx(cl, name, c);
 @if(!func){
  log(cl.ns.cpath) 
  log(name)
  log(c.name)  
  die("func not defined");
 }
 @return midNewx(callf, [func, args]Cpt)  
})
bnfUndNewx("str", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 @return midNewx(valf, [ast[2], strc]Cpt) 
})
bnfUndNewx("var", ->(ast JsonArr, cl Classx, belong Classx, name Str)Cpt{
 @return midNewx(valf, [11]Cpt) 
})

bnfUndNewx ->(name Str, func NativeFuncClassMemx)Dic{
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
getIdx ->(ast JsonArr, cl Classx)Classx{
 @if(ast[0] != "id"){
  log(ast)
  die("cannot get id");
 }
 #key = ast[2]
 #r = cmgetx(cl, key)
 @if(r){
  @return r.args[0]
 }
 die("id not defined "+key)
}
getStrx ->(ast JsonArr, str Str)Str{
 log(ast)
 @if(ast[0] != "str"){
  @if(str != ""){
   @return str
  }
  die("cannot get str");
 }
 @return ast[2]
}

undx ->(ast JsonArr, cl Classx, belong Classx, key Str)Midx{//TODO with bnf obj
 #id = Str(ast[0])
 DicCptx#dic = bnfBaseo.dic
 #f = dic[id];
 @if(!f){
  log(ast)
  die("ast error, not defined "+ id)
 }
 @return call(NativeFuncClassMemx(DicCptx(f)["und"]), [ast, cl, belong, key]Cpt)
}

inx ->(ast JsonArr, und Objx, key Str)Cpt{
 #global = Memx(und.dic["mem"])
 #undglobal = global.class
 #mid = undx(ast, undglobal, _, key)
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
