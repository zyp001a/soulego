T := @enum CLASS CLASSNS CLASSNSSUB CLASSSET CLASSTUPLE\
 OBJ INT FLOAT NUMBIG STR BYTES ARR DIC TIME\
 FUNC FUNCMEM FUNCCLASSMEM FUNCBLOCK\
 MID MEM DYM\
 ARRRAW DICRAW
Cptx := @type Cpt
ArrCptx := @type Arr Cptx
DicCptx := @type Dic Cptx
ArrClassx := @type Arr Classx
ArrObjx := @type Arr Objx
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



uidi := Uint(1)

classc := &Classx{
 type: T##CLASS
 name: "Class"
 id: uidx()
 dic: &DicCptx
}
classc.class = classc
classNsc := classNewx("Ns", classc);
classNsc.type = T##CLASSNS

classNsSubc := classNewx("NsSub", classNsc);
classNsSubc.type = T##CLASSNSSUB

classSetc := classNewx("Set", classc);
classSetc.type = T##CLASSSET

classTuplec := classNewx("Tuple", classc);
classTuplec.type = T##CLASSTUPLE


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
  class.path = ns.cpath + "/" + class.name
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
 x.cpath = name;
 @return x;
}
classNsSubNewx ->(name Str, ns Classx, class Classx, prt Classx, alt Classx)Classx{
 #x = classNewx(class.name+"_"+name, prt, alt);
 x.type = T##CLASSNSSUB;
 x.class = classNsSubc;
 nsx(x, ns)
 x.cpath = ns.cpath + "/" + class.name+"_"+name;
 @return x;
}
classSetNewx ->(name Str, arr ArrClassx, prt Classx, alt Classx)Classx{
 #x = classNewx("Set_"+name, prt, alt);
 x.type = T##CLASSSET
 x.class = classSetc
 x.obj = arr;
 @return x;
}
/*
classObjNewx ->(name Str, ns Classx, class Classx, prt Classx, alt Classx)Classx{
 #x = classNewx(class.name+"_"+name, prt, alt);
 x.type = T##CLASS
 x.class = class;
 x.cpath = name;
 nsx(x, ns)
 @return x;
}
*/
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
 #x = classNewx(class.name + "_" + name);
 x.type = T##OBJ;
 x.class = class;
 x.obj = objNewx(class, dic);
 nsx(x, ns);
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
 @if(cinx(cl.class, classNsc)){
  //DBGET
  @if(dbx["val"]){
   #rr = call(dbx["val"], [cl, key])
   @if(rr){
    cl.dic[key] = rr;
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
ccgetx ->(cl Classx, key Str, cl2 Classx, cache Dic)Classx{
 #r = ccsubgetx(cl, key, cl2);
 @if(r){
  @return r
 }
 #r = ccsubgetx(cl, key, anyc);
 @if(r){
  @return r
 }
 @if(!cache){
  cache = &Dic
 }  
 @if(cl.prt){
  #v = cl.prt;
  #k = Str(v.id);
  @if(cache[k] == _){
   cache[k] = 1;
   r = ccgetx(v, key, cl2, cache)
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
   r = ccgetx(v, key, cl2, cache)
   @if(r != _){
    @return r;
   }
  }
 }
 @return _; 
 
}
ccsubgetx ->(cl Classx, key Str, cl2 Classx, cache Dic)Classx{
 @if(cl2.id == anyc.id){
  #keyx = key
 }@else{
  #keyx = key+ "__" + cl2.name; 
 }
 #r = cl.dic[keyx];
 @if(r){
  @return r
 }
 @if(!cache){
  cache = &Dic
 }
 @if(cinx(cl.class, classNsc)){
  //DBGET
  @if(dbx["val"]){
   #rr = call(dbx["val"], [cl, keyx])
   @if(rr){
    cl.dic[keyx] = rr;   
    @return rr
   }
  }
 }
 @if(cl2.prt){
  #v = cl2.prt;
  #k = Str(v.id);
  @if(cache[k] == _){
   cache[k] = 1;
   r = ccsubgetx(cl, key, v, cache)
   @if(r != _){
    @return r;
   }
  }
 }
 //TODO if prt and alt return different result: die error
 @if(cl2.alt){
  #v = cl2.alt
  #k = Str(v.id);
  @if(cache[k] == _){
   cache[k] = 1;
   r = ccsubgetx(cl, key, v, cache)
   @if(r != _){
    @return r;
   }
  }
 }
 @return _;
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
