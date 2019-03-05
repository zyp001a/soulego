T := @enum CPT CLASS NULL\
 INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 ARRSTR LOG\
 FUNC MID
Cptx := @type Cpt
ArrCptx := @type Arr Cptx
DicCptx := @type Dic Cptx
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
Classx =>{
 type: T
 name: Str
 parents: ArrClassx
 dic: DicClassx
 id: Uint
 
 scope: Classx 
 class: Classx
 
 obj: Cptx
 impl: Classx
}

ArrStrx := @type Arr Str
Intx := @type Int
Floatx := @type Float
Strx := @type Str
Bytex := @type Byte
Dicx =>{
 class: Classx
 keys: ArrStrx
 val: DicCptx
 len: Int
 size: Int
}
Arrx => {
 class: Classx
 val: ArrCptx
 len: Int
 size: Int 
}
StateDefx =>{
 parent: StateDefx
 arr: ArrClassx
 dic: DicClassx
 id: Uint 
}
Statex =>{
 parent: Statex
 arr: ArrCptx
 dic: DicCptx
 def: StateDefx
 id: Uint
}
ArrStatex := @type Arr Statex
Envx =>{
 stack: ArrStatex
 state: Statex
 exe: Classx
}
FuncCptx ->(ArrCptx)Cptx
Funcx =>{
 class: Classx
 val: FuncCptx
}
Midx =>{
 func: Funcx
 args: ArrCptx
}
uidi := Uint(1)
uidx ->()Uint{
 uidi ++
 @return uidi;
}

classNewx ->(name Str, parents ArrClassx, dic DicClassx)Classx{
 #x = &Classx{
  type: T##CLASS
  name: name
  id: uidx()
 }
 @if(dic != _){
  x.dic = dic
  @each k v dic{
   @if(v.scope){
    #nv = classNewx(k, [v]);
    scopex(nv, x)
   }@else{
    scopex(v, x)    
   }
  }
 }@else{
  x.dic = &DicClassx
 }
 @if(parents){
  x.parents = parents
  @each _ v parents{
   @if(v.type > x.type){
    x.type = v.type;
   }
  }
 }@else{
  x.parents = &ArrClassx
 }
 @return x;
}
scopex ->(class Classx, scope Classx){
 class.scope = scope;
 scope.dic[class.name] = class;
}
cptc := classNewx("Cpt");
cptc.type = T##CPT
classc := classNewx("Class", [cptc]);
classc.type = T##CLASS
scopec := classNewx("Scope", [classc]);
rootc := classNewx("Root");
rootc.class = scopec;
scopex(rootc, rootc);
scopeNewx ->(name Str, scope Classx)Classx{
 #x = classNewx(name);
 x.class = scopec;
 scopex(x, scope);
 @return x;
}
stateDefNewx ->(parent StateDefx)StateDefx{
 #x = &StateDefx{
  parent: parent
  arr: &ArrClassx
  dic: &DicClassx
  id: uidx()
 }
 @return x;
}
stateDefc := classNewx("StateDef", [cptc]);
statec := classNewx("State", [cptc]);
funcc := classNewx("Func", [cptc]);
funcc.type = T##FUNC

objc := classNewx("Obj", [cptc]);
objc.type = T##DIC
objNewx ->(class Classx, dic DicCptx){
}

strc := classNewx("Str", [cptc]);

midc := classNewx("Mid", [cptc])
midc.type = T##MID



defc := scopeNewx("Def", rootc);
exec := scopeNewx("Exe", rootc);
Impc := scopeNewx("Imp", rootc);
recc := scopeNewx("Rec", rootc);
datac := scopeNewx("Data", rootc);

defBasec := scopeNewx("Base", defc)
exeBasec := scopeNewx("Base", exec)


Idx =>{
 name: Str
 id: Uint
 exes: ArrClassx
}
idNewx ->()Idx{
 @return &Idx{
  id: uidx()
  exes: &ArrClassx
 }
}
idc := classNewx("Id", [cptc]);
scopex(idc, defBasec);
midNewx ->(func Funcx, args ArrCptx)Midx{
 #x = &Midx{
  func: func
  args: args
 }
 @if(args == _){
  x.args =  &ArrCptx
 }
 @return x
}

cgetx ->(cl Classx, key Str, cache Dic)Cptx{
 #r = cl.dic[key]
 @if(r != _){
  @return r
 }
 @if(cl.class.id == scopec.id){
  //DBGET
 }
 @each _ v cl.parents {
  #k = Str(v.id);
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = cgetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @return _;
}
getx ->(){
}
rgetx ->(cl Classx, cl2 Classx, key Str)Cptx{
 #r = cl.dic[cl2.name]
 @if(r != _){
  r2 = r.dic[key]
  @if(r2 != _){
   @return r2
  }
 }
 @if(cl.class.id == scopec.id){
  //DBGET
  log(cl.dic)
  log(cl2.name)
  log(key)    
 }
 @each _ v cl2.parents {
  #rr = rgetx(cl, v, key)
  @if(rr != _){
   @return rr;
  }
 }
 @each _ v cl.parents {
  #rr = rgetx(v, cl2, key)
  @if(rr != _){
   @return rr;
  } 
 }
 @return _;
}
ast2midx ->(ast JsonArr, c Classx, sd StateDefx)Midx{
}
midx ->(mid Midx, env Envx)Cptx{
 #fc = mid.func.class;
 #f = Funcx(rgetx(env.exe, fc.scope, fc.name))
 //check func
 @return callx(f, mid.args);
}
callx ->(func Funcx, args ArrCptx)Cptx{
 @return call(func.val, [args])
}
funcNewx ->(c Classx, key Str, val FuncCptx, argtypes ArrClassx, return Classx)Funcx{
 #fc = classNewx(key, [funcc]);
 scopex(x, c);
 #x = &Funcx{
  class: fc
  val: val
 }
 @return x
}
inf := funcNewx(idc, "in", ->(arr ArrCptx)Cptx{
 @return "1"
 #osargs = @soul.getCmdArgs()
 @if(osargs.len() == 1){
  log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
  @soul.exit(0)
 }@else{
  Str#fc = @fs[osargs[1]]
  @return fc  
 }
 @return
}, [idc], strc)
outf := funcNewx(idc, "out", ->(arr ArrCptx)Cptx{
 #s = Str(arr[1])
 print(s)
}, [idc, strc])
//funcNewx(exeBasec, idc, "out", ->(arr ArrCptx)Cptx{
//})
recf := funcNewx(idc, "rec", ->(arr ArrCptx)Cptx{
 @return midNewx(outf, [Str(arr[1])]Cpt)
 #str = Str(arr[1])
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  die("progl2cpt: wrong grammar")
 }
 @return ast2midx(ast, defBasec, stateDefNewx());
}, [strc], midc)
bootstrapf := funcNewx(idc, "bootstrap", ->(arr ArrCptx)Cptx{
 #envMaino = &Envx{
  stack: &ArrStatex
  state: &Statex
  exe: defBasec
 }
 #idSelfo = idNewx() 
 #idMaino = idNewx()
 @for 1 {
  #s = Str(callx(inf, [idSelfo, idMaino]Cptx))
  #m = Midx(callx(recf, [idSelfo, s]Cptx))  
  #r = midx(m, envMaino)
  @if(r == _){
  }
  @break
 }
 @return _;
})

callx(bootstrapf);
