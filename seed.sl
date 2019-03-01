T := @enum CLASS OBJ\
 INT FLOAT NUMBIG STR BYTES ARR ARRSTR DIC\
 ID CALL ARRMID DICMID
Cptx := @type Cpt
ArrCptx := @type Arr Cptx
DicCptx := @type Dic Cptx
Funcx ->(ArrCptx)Cptx
Objx =>{
 class: Classx
 val: Cpt
}
ArrClassx := @type Arr Classx
DicClassx := @type Dic Classx
Classx =>{
 type: T
 name: Str
 parents: ArrClassx
 dic: DicClassx
 id: Int
 
 scope: Classx 
 class: Classx
 
 obj: Objx
}

ArrStrx := @type Arr Str
Intx := @type Int
Floatx := @type Float
Strx := @type Str
Bytex := @type Byte

StateDefx =>{
 parent: StateDefx
 arr: ArrClassx
 dic: DicClassx
 id: Int 
}
Statex =>{
 parent: Statex
 arr: ArrCptx
 dic: DicCptx
 def: StateDefx
 id: Int
}
ArrStatex := @type Arr Statex
Envx =>{
 stack: ArrStatex
 state: Statex
 exec: Classx
 def: Classx
}

uidi := Uint(1)
uidx ->()Uint{
 uidi ++
 @return uidi;
}

classNewx ->(name Str, dic DicClassx, parents ArrClassx)Classx{
 #x = &Classx{
  type: T##CLASS
  name: name
  id: uidx()
  dic: &DicClassx
 }
 @if(dic){
  x.dic = dic
  @each k v dic{
   @if(v.scope){
    #nv = classNewx(k, _, [v]);
    scopex(nv, x)
   }@else{
    scopex(v, x)    
   }
  }
 }
 @if(arr){
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
classc := classNewx("Class");
scopec := classNewx("Scope");
rootc := classNewx("Root");
rootc.class = scopec;
scopex(rootc, rootc);
idc := classNewx("Id", {
 Def: scopec
 Rec: scopec
 Exe: scopec
 Out: scopec
});
objc := classNewx("Obj");
idNewx ->(name Str){
 #x = objNewx(idc)
 @return x;
}
basec := idNewx("Base")

objNewx ->(){
 
}