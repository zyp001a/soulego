@load "seedview"
NativeFuncMemx ->(ArrCptx, Memx)Cpt
//TODO mem split to stack and heap
Memx =>{
 prt: Memx
 arr: ArrCptx
 dic: DicCptx
 class: Classx
 len: Uint
 id: Uint
}

memns := classNsNewx("mem", viewns);
nsx(memns, memns)

memc := classxNewx("Mem", memns)
memc.type = T##MEM

classMemc := classxNewx("ClassMem", memns, classc);
funcMemc := classxNewx("FuncMem", memns, funcc);

funcMemNewx ->(key Str, sp Classx, val NativeFuncMemx, m Classx, return Classx)Classx{
 @return funcNewx(key, sp, val, m, return, _, funcMemc)
}
classMemNewx ->(ns Classx, prt Classx, arr ArrClassx)Classx{
 #name = "Mem_"+Str(uidx());
 #x = classNewx(name, prt);
 x.class = classMemc;
 @if(!arr){
  arr = &ArrClassx
 }
 x.obj = arr;
 nsx(x, ns);
 @return x;
}
memNewx ->(class Classx, prt Memx)Memx{
 #x = &Memx{
  prt: prt
  arr: &ArrCptx
  dic: &DicCptx
  class: class
  id: uidx()
 }
 @return x
}
