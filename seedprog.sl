@load "seeddb"

Progx =>{
 def: Dicx
 glob: Dicx
 func: Dicx
 main: Str
}
progns := classNsNewx("env", dbns);
nsx(progns, progns)

projc := classxNewx("Proj", progns, dicc);

progc := classxNewx("Prog", progns, lifec);

progShellc := classxNewx("ProgShell", progns, progc);
objxNewx("default", progns, progShellc);

progNewx ->()Progx{
 #x = &Progx
 x.def = dicNewx()
 x.glob = dicNewx()
 x.func = dicNewx()
 x.main = ""
 @return x
}
projWritex ->(a Dicx, p Str){
 @each _ k a.arr{
  @fs[p + "/" + k] = Str(a.dic[k])
 }
}
progToProjx ->(prog Progx)Dicx{
 #proj = dicNewx(projc)
 #str = "package main\n";
 @each _ k prog.def.arr{
  str += Str(prog.def.dic[k])
 }
 @each _ k prog.glob.arr{
  str += Str(prog.glob.dic[k])
 }
 @each _ k prog.func.arr{
  str += Str(prog.func.dic[k])
 }
 str += "func main{\n"+prog.main+"}"
 dicSetx(proj, "main.go", str)
 @return proj
}

