@load "seedfunc"
FuncMemx ->(ArrCptx, Memx)Cpt
FuncClassMemx ->(ArrCptx, Classx)Cpt
//TODO mem split to stack and heap
Memx =>{
 prt: Memx
 arr: ArrCptx
 dic: DicCptx
 class: Classx
 len: Uint
 id: Uint
}

memns := classNsNewx("mem", funcns);
nsx(memns, memns)

memc := classxNewx("Mem", memns)
memc.type = T##MEM

classMemc := classxNewx("ClassMem", memns, classc);
classMemc.type = T##CLASSMEM

funcMemc := classxNewx("FuncMem", memns, funcc);
funcMemc.type = T##FUNCMEM
funcClassMemc := classxNewx("FuncClassMem", memns, funcc);
funcClassMemc.type = T##FUNCCLASSMEM


funcMemNewx ->(key Str, sp Classx, val FuncMemx, m Classx, return Classx, argtypes ArrClassx)Classx{
 //get func class from argtypes and return
 #fc = funcMemc
 #x = classNewx(key, fc);
 nsx(x, sp);
 x.obj = val; 
 @return x
}
funcClassMemNewx ->(key Str, sp Classx, val FuncClassMemx)Classx{
 //get func class from argtypes and return
 #fc = funcClassMemc
 #x = classNewx(key, fc);
 nsx(x, sp);
 x.obj = val; 
 @return x
}
classMemNewx ->(ns Classx, prt Classx)Classx{
 #name = "Mem_"+Str(uidx());
 #x = classNewx(name, prt);
 x.type = T##CLASSMEM 
 x.class = classMemc;
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
callClassMemx ->(func FuncClassMemx, args ArrCptx, cl Classx)Cpt{
 @return call(func, [args, cl])
}
callMemx ->(func FuncMemx, args ArrCptx, mem Memx)Cpt{
 @return call(func, [args, mem])
}
