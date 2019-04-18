@load "seedstruct"
Funcx ->(ArrCptx)Cpt

funcns := classNsNewx("func", structns)
nsx(funcns, funcns)

funcc := classxNewx("Func", funcns);
funcc.type = T##FUNC


funcNewx ->(key Str, sp Classx, val Cpt, m Classx, return Classx, argtypes ArrClassx, fc Classx)Classx{
//get func class from argtypes and return
 @if(!m){
  m = voidc
 }
 @if(!fc){
  fc = funcc;
 }
 @if(!return){
  return = voidc
 }
 @if(m.id != anyc.id){
  #keyx = key + "__" + m.name
 }@else{
  #keyx = key 
 }
 #nargtypes = &ArrClassx;
 @if(argtypes != _){
  @each i arg argtypes{
   @if(arg.ns){ //the prop of class is class
    #narg = classNewx("arg"+i, arg);
    nargtypes.push(narg)
   }@else{
    nargtypes.push(arg)  
   }
  }
 }
 y = classNewx(keyx, fc, _, {
  main: m
  args: classSetNewx("args", nargtypes)
  return: return
 })
 nsx(y, sp) 
 y.obj = val;
 @return y
}
callx ->(func Funcx, args ArrCptx)Cpt{
 @return call(func, [args])
}
