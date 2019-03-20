T := @enum CPT CLASS NULL\
 INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 ARRSTR\
 FUNC FUNCSTATE FUNCCLASS\
 LOG MID\
 STATE
ArrCptx := @type Arr Cpt
DicCptx := @type Dic Cpt
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
Funcx ->(ArrCptx)Cpt
FuncClassx ->(ArrCptx, Classx)Cpt
FuncStatex ->(ArrCptx, Statex)Cpt
Classx =>{
 type: T
 name: Str
 prt: Classx
 alt: Classx 
 
 dic: DicClassx
 id: Uint
 
 scope: Classx 
 class: Classx
 
 obj: Cpt
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
 len: Uint
 size: Uint
 id: Uint
}
Arrx => {
 class: Classx
 val: ArrCptx
 len: Uint
 size: Uint
 id: Uint 
}
Statex =>{
 prt: Statex
 arr: ArrCptx
 dic: DicCptx
 class: Classx
 len: Uint
 id: Uint
}
Midx =>{
 func: Classx
 args: ArrCptx
 ln: Uint
}













uidi := Uint(1)

cptc := classNewx("Cpt");
cptc.type = T##CPT
classc := classNewx("Class", cptc);
classc.type = T##CLASS
classScopec := classNewx("ClassScope", classc);
rootsp := classNewx("Root");
rootsp.class = scopec;
scopex(rootsp, rootsp);

basesp := classScopeNewx("Base", rootsp);

scopex(cptc, basesp)
scopex(classc, basesp)
scopex(classScopec, basesp)
scopex(rootsp, basesp)


adminsp := classScopeNewx("Admin", rootsp, basesp);
selfsp := classScopeNewx("Self", rootsp, basesp);


classStatec := defNewx("ClassState", classc);

classScopeFuncc := defNewx("ClassScopeFunc", classScopec);

funcc := defNewx("Func", cptc);
funcc.type = T##FUNC
funcStatec := defNewx("FuncState", cptc);
funcStatec.type = T##FUNCSTATE
funcClassc := defNewx("FuncClass", cptc);
funcClassc.type = T##FUNCCLASS

voidc := defNewx("Void", cptc);

valc := defNewx("Val", cptc);
strc := defNewx("Str", valc);
numc := defNewx("Num", valc);
intc := defNewx("Int", numc);

jsonArrc := defNewx("JsonArr", valc);

midc := defNewx("Mid", cptc)
midc.type = T##MID

logf := funcNewx(basesp, "log", ->(arr ArrCptx)Cpt{
 log(arr[0]);
}, cptc)
undf := funcNewx(basesp, "und", ->(arr ArrCptx)Cpt{
 #ast = JsonArr(arr[0])
 @return undx(ast, classStateNewx(undsp))
}, jsonArrc, midc)
recf := funcNewx(basesp, "rec", ->(arr ArrCptx)Cpt{
 #str = Str(arr[0])
 #ast = JsonArr(osCmd(osEnvGet("HOME")+"/soulego/parser", str))
 @if(ast.len() == 0){
  log(ast)
  die("progl2cpt: wrong grammar")
 }
// log(ast)
 @return ast
}, strc, jsonArrc)
rebearf := funcNewx(basesp, "rebear", ->(arr ArrCptx)Cpt{
 
})
selfStartf := funcNewx(basesp, "start", ->(arr ArrCptx)Cpt{
 #osargs = @soul.getCmdArgs()
 @if(osargs.len() == 1){
  log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
  @soul.exit(0)
 }@else{
  Str#fc = @fs[osargs[1]]
  JsonArr#ast = callx(recf, [fc]Cpt)
//  Midx#mid = callx(undf, [ast]Cpt)  
  log(ast)
 }
}, selfsp)
adminStartf := funcNewx(basesp, "start", ->(arr ArrCptx)Cpt{
 callx(selfStartf)
}, adminsp)
mainf := funcNewx(basesp, "main", ->(arr ArrCptx)Cpt{
 callx(adminStartf)
})

callx(mainf);






uidx ->()Uint{
 uidi ++
 @return uidi;
}
scopex ->(class Classx, scope Classx){
 class.scope = scope;
 scope.dic[class.name] = class;
}
classNewx ->(name Str, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = &Classx{
  type: T##CLASS
  name: name
  id: uidx()
 }
 @if(dic != _){
  x.dic = dic
  @each k v dic{
   @if(v.scope){ //the prop of class is class
    #nv = classNewx(k, v);
    scopex(nv, x)
   }@else{
    scopex(v, x)    
   }
  }
 }@else{
  x.dic = &DicClassx
 }
 @if(prt){
  x.prt = prt
  @if(prt.type > x.type){
    x.type = prt.type;
  }
 }
 @if(alt){
  x.alt = alt
  @if(alt.type > x.type){
    x.type = alt.type;
  }
 }
 @return x;
}
classScopeNewx ->(name Str, scope Classx, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = classNewx(name, prt, alt, dic);
 x.class = classScopec;
 scopex(x, scope);
 @return x;
}
classStateNewx ->(scope Classx, prt Classx)Classx{
 #name = Str(uidx());
 #x = classNewx(name, prt);
 x.class = classStatec;
 scopex(x, scope);
 @return x;
}
stateNewx ->(class Classx, prt Statex)Statex{
 #x = &Statex{
  prt: prt
  arr: &ArrCptx
  dic: &DicCptx
  class: class
  id: uidx()
 }
 @return x
}
funcNewx ->(sp Classx, key Str, val Funcx, m Classx, return Classx, argtypes ArrClassx)Classx{
 //get func class from argtypes and return
 #x = cget(x, key)
 @if(!x){
  #x = classNewx(key);
  x.class = classScopeFuncc;
  scopex(x, sp);
 }

 #fc = funcc;
 @if(!m){
  m = voidc
 }
 y = classNewx(m.name, fc)
 scopex(y, x)
 y.obj = val;    
 @return y
}
funcStateNewx ->(sp Classx, key Str, val FuncStatex)Classx{
 //get func class from argtypes and return
 #fc = funcStatec
 #x = classNewx(key, fc);
 scopex(x, sp);
 x.obj = val; 
 @return x
}
funcClassNewx ->(sp Classx, key Str, val FuncClassx)Classx{
 //get func class from argtypes and return
 #fc = funcClassc
 #x = classNewx(key, fc);
 scopex(x, sp);
 x.obj = val; 
 @return x
}
defNewx ->(name Str, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = classNewx(name, prt, alt, dic)
 scopex(x, basesp);
 @return x;
}
callx ->(func Classx, args ArrCptx)Cpt{
 @return call(Funcx(func.obj), [args])
}
callClassx ->(func Classx, args ArrCptx, cl Classx)Cpt{
 @return call(FuncClassx(func.obj), [args, cl])
}
cgetx ->(cl Classx, key Str, cache Dic)Cptx{
 #r = cl.dic[key]
 @if(r != _){
  @return r
 }
 @if(cl.class.id == scopec.id){
  //DBGET
 }
 @if(cl.prt){
  #v = cl.prt
  #k = Str(v.id);
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = cgetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @if(cl.alt){
  #v = cl.alt
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
undx ->(ast JsonArr, cl Classx)Midx{
 #id = Str(ast[0])
 #f = cgetx(cl.scope, id, {});
 @if(!f){
  log(ast)
  die("ast error")
 }
 @return callClassx(f, [ast]Cptx, cl)
}

