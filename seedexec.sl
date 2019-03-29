@load "seedmid"

execns := classNsNewx("soul", midns);
nsx(execns, execns)

execc := classxNewx("Exec", execns)//need main mem(stack+ heap)

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
 log("callmid")
}, midc)

execx ->(mid Midx, mem Memx)Cpt{
 @if(mid.func.type == T##FUNC){
  @return callx(mid.func.obj, mid.args)
 }@elif(mid.func.type == T##FUNCMEM){
  @return callMemx(mid.func.obj, mid.args, mem) 
 } 
}
rexecx ->(class Classx, obj Cpt)Midx{
 @if(inx(class, objc)){
  
 }
 @return midNewx(valf, ["1"]Cpt)
}