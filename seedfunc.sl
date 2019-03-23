@load "seedbase"
Funcx ->(ArrCptx)Cpt
FuncClassMemx ->(ArrCptx, Classx)Cpt
FuncMemx ->(ArrCptx, Memx)Cpt
Memx =>{
 prt: Memx
 arr: ArrCptx
 dic: DicCptx
 class: Classx
 len: Uint
 id: Uint
}

funcns := classNsNewx("func", basens);
nsx(funcns, funcns)

classMemc := classxNewx("ClassMem", funcns, classc);
classMemc.type = T##CLASSMEM
classNsFuncc := classxNewx("ClassNsFunc", funcns, classNsc);


funcc := classxNewx("Func", funcns);
funcc.type = T##FUNC
funcMemc := classxNewx("FuncMem", funcns, funcc);
funcMemc.type = T##FUNCMEM
funcClassMemc := classxNewx("FuncClassMem", funcns, funcc);
funcClassMemc.type = T##FUNCCLASSMEM



valf := funcMemNewx("val", funcns, ->(arr ArrCptx, stt Memx)Cpt{
 @return arr[0]
}, valc)




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
funcNewx ->(key Str, sp Classx, val Funcx, m Classx, return Classx, argtypes ArrClassx)Classx{
 //get func class from argtypes and return
 #x = cgetx(sp, key, {})
 @if(!x){
  #x = classNewx(key);
  x.class = classNsFuncc;
  nsx(x, sp);
 }

 #fc = funcc;
 @if(!m){
  m = voidc
 }
 y = classNewx(m.name, fc)
 nsx(y, x)
 y.obj = val;    
 @return y
}
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
callx ->(func Funcx, args ArrCptx)Cpt{
 @return call(func, [args])
}
callClassx ->(func FuncClassMemx, args ArrCptx, cl Classx)Cpt{
 @return call(func, [args, cl])
}
