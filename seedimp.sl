@load "seedlang"

impns := classNsNewx("imp", langns);
nsx(impns, impns)

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
// #tartype = Classx(arr[0])
 #func = Classx(arr[1])
 #lang = Classx(arr[2])
 #prog = progNewx();
 #newmem = memNewx(classMemNewx(impns), mem)
 langx(lang, prog, newmem, midNewx(mainf, [func]Cpt))
 #proj = progToProjx(prog)
 projWritex(proj, "tmp");
 @return proj;
}, anyc, projc)//ProgShell.imp TODO

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