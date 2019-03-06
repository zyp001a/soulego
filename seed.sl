T := @enum CPT CLASS NULL\
 INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 ARRSTR\
 LOG MID
Cptx := @type Cpt
ArrCptx := @type Arr Cptx
DicCptx := @type Dic Cptx
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
Funcx ->(ArrCptx)Cptx
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
 func: Funcx
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
UndStatex =>{
 parent: UndStatex
 arr: ArrClassx
 dic: DicClassx
 def: Classx
 id: Uint 
}
ExeStatex =>{
 parent: ExeStatex
 arr: ArrCptx
 dic: DicCptx
 und: UndStatex
 id: Uint
}

Midx =>{
 func: Classx
 args: ArrCptx
 ln: Uint
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
undStateNewx ->(def Classx, parent UndStatex)UndStatex{
 #x = &UndStatex{
  parent: parent
  arr: &ArrClassx
  dic: &DicClassx
  def: def
  id: uidx()
 }
 @return x
}
exeStateNewx ->(und UndStatex, parent ExeStatex)ExeStatex{
 #x = &ExeStatex{
  parent: parent
  arr: &ArrClassx
  dic: &DicClassx
  und: und
  id: uidx()
 }
 @return x
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


defc := scopeNewx("Def", rootc);
exec := scopeNewx("Exe", rootc);
recc := scopeNewx("Rec", rootc);
undc := scopeNewx("Und", rootc);
impc := scopeNewx("Imp", rootc);
datc := scopeNewx("Dat", rootc);
tesc := scopeNewx("Tes", rootc);

defBasec := scopeNewx("Base", defc)
exeBasec := scopeNewx("Base", exec)
recBasec := scopeNewx("Base", recc)
undBasec := scopeNewx("Base", undc)
impBasec := scopeNewx("Base", impc)
datBasec := scopeNewx("Base", datc)
tesBasec := scopeNewx("Base", tesc)

scopex(cptc, defBasec)
scopex(classc, defBasec)
scopex(scopec, defBasec)
scopex(rootc, defBasec)

defNewx ->(name Str, parents ArrClassx, dic DicClassx)Classx{
 #x = classNewx(name, parents, dic)
 scopex(x, defBasec);
 @return x;
}

perc := defNewx("Per", [classc]);

basec := defNewx("Base");
basec.class = perc;
idc := defNewx("Id", [basec]);
segoc := defNewx("Sego", [idc]);//superego


funcc := defNewx("Func", [cptc]);

objc := defNewx("Obj", [cptc]);
objc.type = T##DIC
objNewx ->(class Classx, dic DicCptx){
}
valc := defNewx("Val", [cptc]);
strc := defNewx("Str", [valc]);
numc := defNewx("Num", [valc]);
intc := defNewx("Int", [numc]);

jsonArrc := defNewx("JsonArr", [valc]);

midc := defNewx("Mid", [cptc])
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
getx ->(cl Classx, key Str)Cptx{
 
}
rgetx ->(cl Classx, cl2 Classx, key Str)Classx{
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
}, [perc], strc)
funcNewx(idc, "out", ->(arr ArrCptx)Cptx{
 #s = Str(arr[1])
 print(s)
}, [strc])
valf := funcNewx(valc, "val", ->(arr ArrCptx)Cptx{
 @return arr[0]
})

funcNewx(undBasec, "units", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 @return undx(ast[1], arr[1], arr[2])
})
funcNewx(undBasec, "stat", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 #x = undx(ast[1], arr[1], arr[2])
 x.ln = Uint(Float(ast[2]))
 @return x
})
funcNewx(undBasec, "int", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 @return midNewx(valf, [Int(Str(ast[1]))]Cptx);
})


mainf := funcNewx(idc, "main", ->(arr ArrCptx)Cptx{
 onx(idc, segoc, "1");
})


getDefx ->(self Classx, src Classx)Classx{
 @return defBasec;
}
getRecx ->(self Classx, src Classx, msg Str)Classx{
 @return recBasec;
}
getUndx ->(self Classx, src Classx, ast JsonArr)Classx{
 @return undBasec;
}
getExex ->(self Classx, src Classx, mid Midx)Classx{
 @return defBasec;
}
onx ->(self Classx, src Classx, msg Str){
 #recsp = getRecx(self, src, msg);
 #ast = recx(msg, recsp);
 #undsp = getUndx(self, src, ast);
 #defsp = getDefx(self, src); 
 #undstt = undStateNewx(defsp)
 #mid = undx(ast, undsp, undstt);
 
 #exesp = getExex(self, src, mid);
 #exestt = exeStateNewx(undstt);
 #r = exex(mid, exesp, exestt);
 log(r)
}
recx ->(str Str, rec Classx)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  die("progl2cpt: wrong grammar")
 }
 log(ast)
 @return ast
}
undx ->(ast JsonArr, und Classx, stt UndStatex)Midx{
 #id = Str(ast[0])
 #f = cgetx(und, id);
 @if(!f){
  log(ast)
  log("ast error")
 }
 @return callx(f, [ast, und, stt]Cptx)
}
exex ->(mid Midx, exe Classx, stt ExeStatex)Cptx{
 #fc = mid.func;
 #f = rgetx(exe, fc.scope, fc.name)
 //check func
 @if(!f){
  log(exe.name + "/" + fc.scope.name + "/" + fc.name)  
  log("no mid error")
 }
 @return callx(f, mid.args, stt);
}
callx ->(func Classx, args ArrCptx, stt ExeStatex)Cptx{
 @if(!func.func){
  log(func);
  log("not func error");
 }
 @return call(func.func, [args])
}
funcNewx ->(c Classx, key Str, val Funcx, argtypes ArrClassx, return Classx)Classx{
 #x = classNewx(key, [funcc]);
 scopex(x, c);
 x.func = val; 
 @return x
}
rfuncNewx ->(sp Classx, c Classx, key Str, val Funcx)Classx{
 #nc = cgetx(sp, c.name)
 @if(nc == _){
  #nc = classNewx(c.name);
  scopex(nc, sp)
 }
 #x = classNewx(key, [funcc]);
 scopex(x, nc);
 x.func = val; 
 @return x
}

callx(mainf);
