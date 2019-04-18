@load "seedmid"

execns := classNsNewx("exec", midns);
nsx(execns, execns)

execc := classxNewx("Exec", execns)//need main mem(stack+ heap)
funcBlockc := classxNewx("FuncBlock", execns, funcc);

mainf := funcMemNewx("main", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, anyc)
valf := funcMemNewx("val", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, valc, dymc)
paragraphf := funcMemNewx("paragraph", execns, ->(arr ArrCptx, mem Memx)Cpt{
 #pr = ArrMidx(arr[1])
 @each _ e pr{
  #r = execx(e, mem)
  @if(r){
   
  }
 }
})
idf := funcMemNewx("id", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, valc, dymc)
getf := funcMemNewx("get", execns, ->(arr ArrCptx, mem Memx)Cpt{
 @return arr[0]
}, valc, dymc)
callf := funcMemNewx("call", execns, ->(arr ArrCptx, mem Memx)Cpt{
 #func = Classx(arr[0])
 #args = ArrCptx(arr[1])
 #argsn = &ArrCptx
 @each _ v args{
  argsn.push(execx(v, mem))
 }
 @return callx(func.obj, argsn, mem)
}, anyc)//funcc
execx ->(mid Midx, mem Memx)Cpt{
 @return callx(mid.func.obj, mid.args, mem)
}
callx ->(func Funcx, args ArrCptx, mem Memx)Cpt{
 @if(cinx(func.class, funcMemc)){
  @return call(NativeFuncMemx(func.val), [args, mem]Cpt)
 }@elif(cinx(func.class, funcBlockc)){
  @return callBlockx(func, [args, mem]Cpt) 
 }@else{
  @return call(NativeFuncx(func.val), [args])
 }
}
rexecx ->(class Classx, obj Cpt)Midx{
 @if(cinx(class, objc)){
  
 }
 @return midNewx(valf, ["1"]Cpt)
}

callBlockx ->(func Funcx, args ArrCptx, mem Memx)Cpt{
 #block = Midx(func.val)
 #classmem = Classx(block.args[0])
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
 @if(r){
  @return midNewx(idf, [r, cl.ns, key]Cpt);
 }
}
nscgetx ->(cl Classx, key Str, cl2 Classx)Classx{
 #r = ccgetx(cl, key, cl2)
 @if(r){
  @return r
 }
 #r = ccgetx(cl.ns, key, cl2)
 @if(r){
  @return r
 }
}