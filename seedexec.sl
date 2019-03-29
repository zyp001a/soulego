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

execx ->(mid Midx, mem Memx)Cpt{
 @if(mid.func.type == T##FUNC){
  @return callx(mid.func.obj, mid.args)
 }@elif(mid.func.type == T##FUNCMEM){
  @return callMemx(mid.func.obj, mid.args, mem) 
 } 
}
