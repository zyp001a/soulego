@load "seedlang"

impns := classNsNewx("imp", langns);
nsx(impns, impns)

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #func = Classx(arr[1])
// #prog = objNewx(progc)
 arr.push(midNewx(mainf, [func]Cpt))
 #proj = dicNewx(projc)
 dicAddx(proj, "main.go", "1");
 projWritex(proj, "tmp");
 @return;
}, anyc, _, [funcc, langc])//imp progshellc TODO

/*
loadDepx ->(func Classx, arr ArrCptx, dic DicCptx){
 #block = Midx(func.obj)
 #callarr = ArrMidx(block.args[1])
 @each _ c callarr{
  @if(c.func.id == callf.id){
   arr.push(c.args[0])
  }
 }
}
*/