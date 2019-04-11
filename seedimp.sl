@load "seedagent"

impns := classNsNewx("imp", agentns);
nsx(impns, impns)

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #func = Classx(arr[1])
 #arr = &ArrCptx;
 #dic = &DicCptx;//TODO change to dicx
 log("imp")
 loadDepx(func, arr, dic)
 arr.push(midNewx(mainf, [func]Cpt))
 @return midNewx(paragraphf, arr)
}, anyc, midc, [funcc])//imp progshellc TODO

loadDepx ->(func Classx, arr ArrCptx, dic DicCptx){
 #block = Midx(func.obj)
 #callarr = ArrMidx(block.args[1]) 
 @each _ c callarr{
  @if(c.func.id == callf.id){
   log("load")
  }  
 }
}