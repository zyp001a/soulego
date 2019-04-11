T := @enum CLASS CLASSNS CLASSISO CLASSSET\
 OBJ INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 FUNC FUNCMEM FUNCCLASSMEM FUNCBLOCK\
 MID MEM DYM\
 ARRRAW DICRAW
ArrCptx := @type Arr Cpt
DicCptx := @type Dic Cpt
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
ArrStrx := @type Arr Str
Classx =>{
 type: T
 name: Str
 prt: Classx
 alt: Classx 

 dic: DicClassx
 id: Uint
 
 ns: Classx 
 class: Classx
 
 obj: Cpt
 path: Str
 cpath: Str
}
Objx =>{
 class: Classx
 dic: DicCptx 
}
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




uidi := Uint(1)

classc := &Classx{
 type: T##CLASS
 name: "Class"
 id: uidx()
 dic: &DicCptx
}
classc.class = classc
classNsc := classNewx("ClassNs", classc);
classNsc.type = T##CLASSNS

classIsoc := classNewx("ClassIso", classc);
classIsoc.type = T##CLASSISO

classSetc := classNewx("ClassSet", classc);
classNsc.type = T##CLASSSET


basens := classNsNewx("base");
nsx(basens, basens)

nsx(classc, basens)
nsx(classNsc, basens)


objc := classxNewx("Obj", basens);
objc.type = T##OBJ

voidc := classxNewx("Void", basens);
anyc := classxNewx("Any", basens);
dymc := classxNewx("Dym", basens);

valc := classxNewx("Val", basens);
strc := classxNewx("Str", basens, valc);
numc := classxNewx("Num", basens, valc);
intc := classxNewx("Int", basens, numc);
floatc := classxNewx("Float", basens, numc);


uidx ->()Uint{
 uidi ++
 @return uidi;
}
nsx ->(class Classx, ns Classx){
 class.ns = ns;
 ns.dic[class.name] = class;

//NOT NECESSARY
 @if(ns.type == T##CLASSNS){
  class.path = Str(ns.obj) + "/" + class.name
 }
 
}
classNewx ->(name Str, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = &Classx{
  type: T##CLASS
  name: name
  class: classc
  id: uidx()
 }
 @if(dic != _){
  x.dic = dic
  @each k v dic{
   @if(v.ns){ //the prop of class is class
    #nv = classNewx(k, v);
    nsx(nv, x)
   }@else{
    nsx(v, x)    
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
classNsNewx ->(name Str, prt Classx, alt Classx)Classx{
 #x = classNewx("Ns_"+name, prt, alt);
 x.type = T##CLASSNS
 x.class = classNsc;
 x.obj = name;
 @return x;
}
classObjNewx ->(name Str, ns Classx, class Classx, prt Classx, alt Classx)Classx{
 #x = classNewx(class.name+"_"+name, prt, alt);
 x.type = T##CLASS
 x.class = class;
 x.obj = name;
 nsx(x, ns)
 @return x;
}
objNewx ->(class Classx, dic DicCptx)Objx{
 @if(!dic){
  dic = &DicCptx
 }
 @return &Objx{
  class: class
  dic: dic  
 }
}
objxNewx ->(name Str, ns Classx, class Classx, dic DicCptx)Classx{
 #x = classNewx(class.name + "_"+name);
 x.type = T##OBJ
 x.class = class;
 x.obj = objNewx(class, dic);
 nsx(x, ns)
 @return x;
}
classxNewx ->(name Str, ns Classx, prt Classx, alt Classx, dic DicClassx)Classx{
 #x = classNewx(name, prt, alt, dic)
 nsx(x, ns);
 @return x;
}
DBX ->(Classx, Str)Classx
dbx := {}DBX
cgetx ->(cl Classx, key Str, cache Dic)Classx{
 #r = cl.dic[key]
 @if(r != _){
  @return r
 }
 @if(!cache){
  cache = &Dic
 }
 @if(cl.class.type == T##CLASSNS){
  //DBGET
  @if(dbx["val"]){
   #rr = call(dbx["val"], [cl, key])
   @if(rr){
    @return rr
   }
  }
 }
 @if(cl.prt){
  #v = cl.prt;
  #k = Str(v.id);
  @if(cache[k] == _){
   cache[k] = 1;
   r = cgetx(v, key, cache)
   @if(r != _){
    @return r;
   }
  }
 }
 //TODO if prt and alt return different result: die error
 @if(cl.alt){
  #v = cl.alt
  #k = Str(v.id);
  @if(cache[k] == _){
   cache[k] = 1;
   r = cgetx(v, key, cache)
   @if(r != _){
    @return r;
   }
  }
 }
 @return _;
}
nsGetx ->(cl Classx, ns Classx, key Str)Classx{

}
isoGetx ->(iso Classx, tar Classx)Classx{
}
cinx ->(cl Classx, tar Classx)Bool{
 @if(cl.id == tar.id){
  @return @true
 }
 @if(cl.prt){
  #r = cinx(cl.prt, tar);
  @if(r){
   @return r;
  }
 }
 @if(cl.alt){
  #r = cinx(cl.alt, tar);
  @if(r){
   @return r;
  }
 }
 @return @false
 //TODO cache
}

