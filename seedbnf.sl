@load "seedmid"

bnfns := classNsNewx("bnf", midns);
nsx(bnfns, bnfns)

bnfc := classxNewx("Bnf", bnfns, objc);

jsonArrc := classxNewx("JsonArr", bnfns, valc);

undf := funcNewx("und", bnfns, ->(arr ArrCptx)Cpt{
 #ast = JsonArr(arr[0])
 @return undx(ast, classMemNewx(bnfns))
}, jsonArrc, midc)
recf := funcNewx("rec", bnfns, ->(arr ArrCptx)Cpt{
 #str = Str(arr[0])
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}, strc, jsonArrc)



undNewx("paragraph", ->(arr ArrCptx, cl Classx)Cpt{
 log(arr)
 @return midNewx(valf)
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
 @return callClassx(DicCptx(f.obj)["und"], [ast]Cpt, cl)
}

