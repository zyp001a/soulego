@load "seeddb"

progns := classNsNewx("env", dbns);
nsx(progns, progns)

projc := classxNewx("Proj", progns, dicc);

progc := classxNewx("Prog", progns, lifec);

progShellc := classxNewx("ProgShell", progns, progc);
objxNewx("default", progns, progShellc);

projWritex ->(a Dicx, p Str){
 @each _ k a.arr{
  @fs[p + "/" + k] = Str(a.dic[k])
 }
}

