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
 x.cpath = sp.cpath + "/" + key;
 @return x
}
funcNewx ->(key Str, sp Classx, val Cpt, m Classx, return Classx, argtypes ArrClassx, fc Classx)Classx{
 //get func class from argtypes and return
 #x = cgetx(sp, key, {})
 @if(!x){
  #x = classNsFuncNewx(key, sp)
 }
 @if(!m){
  m = voidc
 }
 @if(!fc){
  fc = funcc;
 }
 @if(!return){
  return = voidc
 }
 y = classNewx(m.name, fc, _, {
  return: return
 })
 nsx(y, x)
 y.obj = val;    
 @return y
}
callx ->(func Funcx, args ArrCptx)Cpt{
 @return call(func, [args])
}
