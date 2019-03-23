@load "seedbnf"

soulns := classNsNewx("soul", bnfns);
nsx(soulns, soulns)

soulc := classxNewx("Soul", soulns)
selfc := classxNewx("Self", soulns, soulc)
monitorc := classxNewx("Monitor", soulns)


rebearf := funcNewx("rebear", soulns, ->(arr ArrCptx)Cpt{
 
})

selfStartf := funcNewx("start", soulns, ->(arr ArrCptx)Cpt{
 #osargs = @soul.getCmdArgs()
 @if(osargs.len() == 1){
  log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
  @soul.exit(0)
 }@else{
  Str#fc = @fs[osargs[1]]
  JsonArr#ast = callx(recf.obj, [fc]Cpt)
  Midx#mid = callx(undf.obj, [ast]Cpt)
  log(mid)
 }
}, selfc)
monitorStartf := funcNewx("start", soulns,  ->(arr ArrCptx)Cpt{
 callx(selfStartf.obj)
}, monitorc)

mainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
 callx(monitorStartf.obj)
})

