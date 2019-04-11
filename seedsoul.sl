@load "seedenv"
//self: main rebear 
soulns := classNsNewx("soul", envns);
nsx(soulns, soulns)

soulc := classxNewx("Soul", soulns, undc)//, undc, impc)

soulMainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
 #soul = Objx(Classx(arr[0]).obj)
 #osargs = @soul.getCmdArgs()
 @if(osargs.len() == 1){
  log("./soul3 [FILE]")
  @soul.exit(0)
 }@else{ 
  Str#fc = @fs[osargs[1]]
  JsonArr#ast = recx(fc);
  inx(ast, soul);
 }
}, soulc)
