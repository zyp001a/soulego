@load "seedfunc"

Midx =>{
 func: Classx
 args: ArrCptx
 ln: Uint
}

midns := classNsNewx("mid", funcns);
nsx(midns, midns)

midc := classxNewx("Mid", midns)
midc.type = T##MID

midNewx ->(func Classx, args ArrCptx, ln Uint)Midx{
 #x = &Midx{
  func: func
  args: args
  ln: ln
 }
 @if(args == _){
  x.args =  &ArrCptx
 }
 @return x
}
