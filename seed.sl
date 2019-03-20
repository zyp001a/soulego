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
scopec := classNewx("Scope", classc);
rootsp := classNewx("Root");
rootsp.class = scopec;
scopex(rootsp, rootsp);

basesp := scopeClassNewx("Base", rootsp);


funcc := defNewx("Func", cptc);
funcc.type = T##FUNC
funcstatec := defNewx("FuncState", cptc);
funcstatec.type = T##FUNCSTATE
funcclassc := defNewx("FuncClass", cptc);
funcclassc.type = T##FUNCCLASS

valc := defNewx("Val", cptc);
strc := defNewx("Str", valc);
numc := defNewx("Num", valc);
intc := defNewx("Int", numc);

jsonArrc := defNewx("JsonArr", valc);

midc := defNewx("Mid", cptc)
midc.type = T##MID

logf := funcNewx(basesp, "log", ->(arr ArrCptx)Cpt{
 log(arr[0]);
})
mainf := funcNewx(basesp, "main", ->(arr ArrCptx)Cpt{
//start(Sego)
// Sego loop, listen for signal
//start(Id)
// onx(idpr, segopr, "imp()");
 callx(logf, [1]Cpt)
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
scopeClassNewx ->(name Str, scope Classx, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = classNewx(name, prt, alt, dic);
 x.class = scopec;
 scopex(x, scope);
 @return x;
}
stateClassNewx ->(){
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
funcNewx ->(sp Classx, key Str, val Funcx, argtypes ArrClassx, return Classx)Classx{
 //get func class from argtypes and return
 #fc = funcc
 #x = classNewx(key, fc);
 scopex(x, sp);
 x.obj = val; 
 @return x
}
funcStateNewx ->(sp Classx, key Str, val FuncStatex)Classx{
 //get func class from argtypes and return
 #fc = funcstatec
 #x = classNewx(key, fc);
 scopex(x, sp);
 x.obj = val; 
 @return x
}
funcClassNewx ->(sp Classx, key Str, val FuncClassx)Classx{
 //get func class from argtypes and return
 #fc = funcclassc
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

