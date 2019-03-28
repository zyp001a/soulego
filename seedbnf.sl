@load "seedexec"

bnfns := classNsNewx("bnf", execns);
nsx(bnfns, bnfns)



bnfc := classxNewx("Bnf", bnfns, objc);

jsonArrc := classxNewx("JsonArr", bnfns, valc);


undNewx("paragraph", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #r = midNewx(paragraphf)
 @for(#i = 1; i < ast.len(); i++){
  #e = ast[i]
  #mid = undx(e, cl)
  r.args.push(mid);
 }
 @return r
})
undNewx("sentence", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #r = undx(ast[1], cl)
 r.ln = Str(ast[2])
 @return r;
})
undNewx("words", ->(arr ArrCptx, cl Classx)Cpt{
 #ast = JsonArr(arr[0])
 #nsfunc = cgetx(cl.ns, ast[1], {})
 @if(!nsfunc){
  die("func name not defined " + ast[1])
 }
 #args = &ArrCptx
 @for(#i = 2; i < ast.len(); i++){
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

undNewx ->(name Str, func FuncClassMemx)Classx{
 #o = {
  und: func
 }Cpt
 #oc = objxNewx(name, bnfns, bnfc, o)
 @return oc
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
