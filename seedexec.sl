@load "seedmid"

execns := classNsNewx("exec", midns);
nsx(execns, execns)

execc := classxNewx("Exec", execns)//need main mem(stack+ heap)
funcBlockc := classxNewx("FuncBlock", execns, funcc);
funcBlockc.type = T##FUNCBLOCK


valf := funcMemNewx("val", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, valc, dymc, [classc])
paragraphf := funcMemNewx("paragraph", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @each _ e arr{
  #r = execx(e, mem)
  @if(r){
  }
 }
})
idf := funcMemNewx("id", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, valc, dymc, [classc, strc])
callf := funcMemNewx("call", execns, ->(arr ArrCptx, mem Memx)Cpt{
 #func = Classx(arr[0])
 #args = ArrCptx(arr[1])
 #argsn = &ArrCptx
 @each _ v args{
  argsn.push(execx(v, mem))
 }
 @return execx(midNewx(func, argsn), mem)
}, anyc)//funcc
callmidf := funcMemNewx("call", execns, ->(arr ArrCptx, mem Memx)Cpt{
 #funcmid = Midx(arr[0])
 #args = ArrCptx(arr[1])
 #argsn = &ArrCptx
 @each _ v args{
  argsn.push(execx(v, mem))
 }
 #func = Classx(execx(funcmid, mem))
 @return execx(midNewx(func, argsn), mem) 
}, midc)

execx ->(mid Midx, mem Memx)Cpt{
 @if(mid.func.type == T##FUNC){
  @return callx(mid.func.obj, mid.args)
 }@elif(mid.func.type == T##FUNCMEM){
  @return callMemx(mid.func.obj, mid.args, mem) 
 }@elif(mid.func.type == T##FUNCBLOCK){
  @return callBlockx(mid.func, mid.args, mem);
 }
 die("unknown func type")
}
rexecx ->(class Classx, obj Cpt)Midx{
 @if(cinx(class, objc)){
  
 }
 @return midNewx(valf, ["1"]Cpt)
}

callBlockx ->(func Classx, args ArrCptx, mem Memx)Cpt{
 #block = Midx(func.obj)
 #classmem = block.args[0]
 #newmem = memNewx(classmem, mem)
 #callarr = ArrMidx(block.args[1])
 @each _ mid callarr{
  #r = execx(mid, newmem)
  @if(r){
  }
 }
}

cmgetx ->(cl Classx, key Str)Midx{
 #r = cgetx(cl, key, {})
 @if(r){
  @return midNewx(idf, [r, cl, key]Cpt);
 }
 #r = cgetx(cl.ns, key, {})
 @return midNewx(idf, [r, cl.ns, key]Cpt);
}