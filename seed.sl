T := @enum CPT CLASS NULL\
 INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 ARRSTR\
 FUNC FUNCEXE\
 LOG MID
Cptx := @type Cpt
ArrCptx := @type Arr Cptx
DicCptx := @type Dic Cptx
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
Funcx ->(ArrCptx)Cptx
FuncExex ->(ArrCptx, ExeStatex)Cptx
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
rootsp := classNewx("Root");
rootsp.class = scopec;
scopex(rootsp, rootsp);
scopeNewx ->(name Str, scope Classx, parents ArrClassx, dic DicClassx)Classx{
 #x = classNewx(name, parents, dic);
 x.class = scopec;
 scopex(x, scope);
 @return x;
}


defsp := scopeNewx("Def", rootsp);
exesp := scopeNewx("Exe", rootsp);
recsp := scopeNewx("Rec", rootsp);
undsp := scopeNewx("Und", rootsp);
impsp := scopeNewx("Imp", rootsp);
datsp := scopeNewx("Dat", rootsp);
tessp := scopeNewx("Tes", rootsp);

defBasesp := scopeNewx("Base", defsp)
exeBasesp := scopeNewx("Base", exesp, [defBasesp])
recBasesp := scopeNewx("Base", recsp)
undBasesp := scopeNewx("Base", undsp)
impBasesp := scopeNewx("Base", impsp)
datBasesp := scopeNewx("Base", datsp)
tesBasesp := scopeNewx("Base", tessp)

scopex(cptc, defBasesp)
scopex(classc, defBasesp)
scopex(scopec, defBasesp)
scopex(rootsp, defBasesp)

defNewx ->(name Str, parents ArrClassx, dic DicClassx)Classx{
 #x = classNewx(name, parents, dic)
 scopex(x, defBasesp);
 @return x;
}

perc := defNewx("Per", [classc]);

basepr := defNewx("Base");
basepr.class = perc;
idpr := defNewx("Id", [basepr]);
idpr.class = perc
segopr := defNewx("Sego", [basepr]);//superego
segopr.class = perc
adminpr := defNewx("Admin", [basepr]);//superego
adminpr.class = perc


funcc := defNewx("Func", [cptc]);
funcc.type = T##FUNC
funcexec := defNewx("FuncExe", [cptc]);
funcexec.type = T##FUNCEXE

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

undStatec := defNewx("UndState", [classc])
exeStatec := defNewx("ExeState", [classc])

inf := funcNewx(perc, "in", ->(arr ArrCptx)Cptx{
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
funcNewx(perc, "out", ->(arr ArrCptx)Cptx{
 #s = Str(arr[1])
 print(s)
}, [strc])
valf := funcExeNewx(valc, "val", ->(arr ArrCptx, stt ExeStatex)Cptx{
 @return arr[0]
})
stateIdf := funcExeNewx(undStatec, "id", ->(arr ArrCptx, stt ExeStatex)Cptx{
 #und = UndStatex(arr[0]);
 #key = Str(arr[1]);
 #exe = exeFindx(stt, und)
 @if(!exe){
  log("exe find error")
 }
 @return exeGetx(exe, key);
})

funcNewx(undBasesp, "units", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 @return undx(ast[1], arr[1], arr[2])
})
funcNewx(undBasesp, "stat", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 #x = undx(ast[1], arr[1], arr[2])
 x.ln = Uint(Str(ast[2]))
 @return x
})
funcNewx(undBasesp, "int", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 @return midNewx(valf, [Int(Str(ast[1]))]Cptx);
})
funcNewx(undBasesp, "id", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 #sp = Classx(arr[1])
 #stt = UndStatex(arr[2]) 
 @return undGetx(stt, Str(ast[1]))
})
funcNewx(undBasesp, "call", ->(arr ArrCptx)Cptx{
 #ast = JsonArr(arr[0])
 #f = undx(ast[1], arr[1], arr[2])
 @return midNewx(f);
})

rfuncNewx(impBasesp, perc, "Main", ->(arr ArrCptx)Cptx{
 #per = Classx(arr[0])
 log(per)
 @return "1";
})


funcNewx(perc, "rebear", ->(arr ArrCptx)Cptx{
})
mainf := funcNewx(perc, "main", ->(arr ArrCptx)Cptx{
 onx(idpr, segopr, "imp()"); 
})
funcNewx(perc, "imp", ->(arr ArrCptx)Cptx{
 #p = Classx(arr[0]);
 #imp = cgetx(impsp, p.name);
 #f = rgetx(imp, perc, "Main");
 #r = callx(f, [p]Cptx);
 print(#r);
 @return; 
})


getDefx ->(self Classx, src Classx)Classx{
 @return defBasesp;
}
getRecx ->(self Classx, src Classx, msg Str)Classx{
 @return recBasesp;
}
getUndx ->(self Classx, src Classx, ast JsonArr)Classx{
 @return undBasesp;
}
getExex ->(self Classx, src Classx, mid Midx)Classx{
 @return exeIdsp;
}
onx ->(self Classx, src Classx, msg Str){
 #sprec = getRecx(self, src, msg);
 #ast = recx(msg, sprec);
 #spund = getUndx(self, src, ast);
 #spdef = getDefx(self, src); 
 #sttund = undStateNewx(spdef)
 #mid = undx(ast, spund, sttund);
 
 #spexe = getExex(self, src, mid);
 #sttexe = exeStateNewx(sttund);
 #r = exex(mid, spexe, sttexe);
 log(r)
}
recx ->(str Str, rec Classx)JsonArr{
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
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
 @if(func.type == T##FUNC){
  //process args
  #nargs = []Cptx
  @each _ arg args{
   args.push(exex(arg, stt))
  }
  @return call(Funcx(func.val), [nargs])
 }@elif(func.type == T##FUNCEXE){
  @return call(FuncExex(func.val), [args, stt]) 
 }@else{
  log(func);
  log("not func error"); 
 }
}
funcNewx ->(c Classx, key Str, val Funcx, argtypes ArrClassx, return Classx)Classx{
 #x = classNewx(key, [funcc]);
 scopex(x, c);
 x.obj = val; 
 @return x
}
funcExeNewx ->(c Classx, key Str, val FuncExex, argtypes ArrClassx, return Classx)Classx{
 #x = classNewx(key, [funcexec]);
 scopex(x, c);
 x.obj = val; 
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
undGetx ->(cl UndStatex, key Str, flag Int)Cptx{
 #r = cl.dic[key];
 @if(r){
  @return midNewx(stateIdf, [cl, key]Cptx);
 }
 #r = undGetx(cl.und, key, 1)
 @if(r){
  @return r;
 }
 @if(flag){
  @return
 }
 #r = cgetx(cl.def, key)
 @if(r){
  @return midNewx(valf, [r]Cptx); 
 }
}
exeFindx ->(exe ExeStatex, und UndStatex)ExeStatex{
 @if(exe.und.id == und.id){
  @return exe;
 }
 @if(exe.parent == _){
  @return
 }
 @return exeFindx(exe.parent, und)
}
exeGetx ->(exe ExeStatex, key Str)Cptx{
 @return exe.dic[key];
}
rgetx ->(cl Classx, cl2 Classx, key Str)Classx{
 #r = subRgetx(cl, cl2, key)
 @if(r){
 //TODO cache
  @return r;
 }
}
subRgetx ->(cl Classx, cl2 Classx, key Str, limit Int)Classx{
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
  #rr = subRgetx(cl, v, key, 1)
  @if(rr != _){
   @return rr;
  }
 }
 @if(limit){
  @return
 }
 @each _ v cl2.parents {
  #rr = subRgetx(cl, v, "default", 1)
  @if(rr != _){
   @return rr;
  }  
 }
 @each _ v cl.parents {
  #rr = subRgetx(v, cl2, key)
  @if(rr != _){
   @return rr;
  } 
 }
 @return _;
}

callx(mainf);
