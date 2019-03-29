@load "seedenv"
//self: main rebear 
soulns := classNsNewx("soul", envns);
nsx(soulns, soulns)

soulc := classxNewx("Soul", soulns, undc)//, undc, impc)

sbotc := classxNewx("Sbot", soulns, progc, soulc)


selfns := classNsNewx("self", soulns);
nsx(selfns, selfns)

envSelfo := objxNewx("self", selfns, envprogc, {
 mem: memNewx(classMemNewx(soulns))//TODO multi ns
}Cpt)
soulSelfo := objxNewx("self", selfns, sbotc, {
 mem: memNewx(classMemNewx(selfns))//TODO multi ns
 env: envSelfo
}Cpt)

mainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
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
}, sbotc)
