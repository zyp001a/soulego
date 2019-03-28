@load "seedbnf"
//self: main rebear 
soulns := classNsNewx("soul", bnfns);
nsx(soulns, soulns)

soulc := classxNewx("Soul", soulns)
selfc := classxNewx("Self", soulns, soulc)
envc := classxNewx("Env", soulns, soulc)//TODO static mem.heap


bearf := funcNewx("bear", soulns, ->(arr ArrCptx)Cpt{
 log("bear")
}, envc)



selfMainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
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
envMainf := funcNewx("main", soulns,  ->(arr ArrCptx)Cpt{
 callx(selfMainf.obj)
}, envc)

mainf := funcNewx("main", soulns, ->(arr ArrCptx)Cpt{
 //init env
 callx(bearf.obj, [arr[0]])
}, envc)



recx ->(str Str)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}

soulNewx ->(envns Classx)Objx{
 @return objNewx(envc, {
  mem: memNewx(classMemNewx(envns))
 }Cpt)
}