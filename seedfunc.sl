@load "seedstruct"
NativeFuncx ->(ArrCptx)Cpt
ArrArgx := @type Arr Argx
Argx =>{
 name: Str
 class: Class
 val: Cpt
}
Funcx =>{
 val: Cpt
 args: ArrArgx
 return: Classx
 main: Classx
 class: Classx
}

funcns := classNsNewx("func", structns)
nsx(funcns, funcns)

funcc := classxNewx("Func", funcns);
funcc.type = T##FUNC

funcNewx ->(key Str, sp Classx, val Cpt, main Classx, return Classx, args ArrArgx, fc Classx)Classx{
//get func class from argtypes and return
 @if(!main){
  main = anyc
 }
 @if(!fc){
  fc = funcc;
 }
 @if(!return){
  return = anyc
 }
 @if(!args){
  args = &ArrArgx;
 }
 @if(main.id != anyc.id){
  #keyx = key + "__" + main.name
 }@else{
  #keyx = key
 }
 y = classNewx(keyx, fc) 
 nsx(y, sp) 
 y.obj = &Funcx{
  val: val
  args: args
  return: return
  main: main
  class: y 
 }
 @return y
}
