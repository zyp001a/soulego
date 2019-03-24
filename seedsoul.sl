@load "seedbnf"

soulns := classNsNewx("soul", bnfns);
nsx(soulns, soulns)

soulc := classxNewx("Soul", soulns)
selfc := classxNewx("Self", soulns, soulc)
monitorc := classxNewx("Monitor", soulns)


rebearf := funcNewx("rebear", soulns, ->(arr ArrCptx)Cpt{
 log("rebear")
})



selfStartf := funcNewx("start", soulns, ->(arr ArrCptx)Cpt{
 #osargs = @soul.getCmdArgs()
 @if(osargs.len() == 1){
  log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
  @soul.exit(0)
 }@else{
  Str#fc = @fs[osargs[1]]
  JsonArr#ast = recx(fc);
  #undglobal = classMemNewx(soulns)
  Midx#mid = undx(ast, undglobal)
  #global = memNewx(undglobal)
  execx(mid, global)
 }
}, selfc)
monitorStartf := funcNewx("start", soulns,  ->(arr ArrCptx)Cpt{
 callx(selfStartf.obj)
}, monitorc)

mainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
 callx(monitorStartf.obj)
})



recx ->(str Str)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}
