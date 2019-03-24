@load "seedbase"
Funcx ->(ArrCptx)Cpt

funcns := classNsNewx("func", basens);
nsx(funcns, funcns)

classNsFuncc := classxNewx("ClassNsFunc", funcns, classNsc);

funcc := classxNewx("Func", funcns);
funcc.type = T##FUNC

classNsFuncNewx ->(key Str, sp Classx)Classx{
 #x = classNewx(key);
 x.class = classNsFuncc;
 nsx(x, sp);
 x.obj = Str(sp.obj) + "/" + key;
 @return x
}
funcNewx ->(key Str, sp Classx, val Funcx, m Classx, return Classx, argtypes ArrClassx)Classx{
 //get func class from argtypes and return
 #x = cgetx(sp, key, {})
 @if(!x){
  #x = classNsFuncNewx(key, sp)
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
callx ->(func Funcx, args ArrCptx)Cpt{
 @return call(func, [args])
}
