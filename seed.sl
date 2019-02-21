T := @enum CPT OBJ CLASS TOBJ\
 INT FLOAT NUMBIG STR BYTES ARR ARRSTR DIC\
 ID CALL ARRMID DICMID
Cptx => {
 type: T

 id: Int

 class: Cptx
 scope: Cptx

 owner: Cptx //for method and prop

 keys: Arr_Str
 arr: Arrx
 dic: Dicx

 str: Str
 int: Int

 val: Cpt
}
Arrx := @type Arr Cptx
Dicx := @type Dic Cptx
Funcx ->(Arrx, Cptx)Cptx

defns := nsNewx("def")
execns := nsNewx("exec")
mainsp := scopeNewx(defns, "main")
idsp := scopeNewx(defns, "id")
nssp := scopeNewx(defns, "ns")
mainesp := scopeNewx(execns, "main")

idmainv := objNewx()
routex(idsp, "mainsp", idmain)


uidi := Uint(1)



nsNewx ->(name Str)Cptx{
 Cptx#x = dicNewx()
 @if(nsc){
  x.class = nsc
 }
 @if(nssp){
  x.scope = nssp
 }
 x.name = name
 @return x;
}
scopeNewx ->(ns Cptx, name Str)Cptx{
 #x = dicNewx()
 @if(scopec){
  x.class = scopec
 }
 @if(nssp){
  x.scope = nssp
 }
 x.name = ns.name + "/" + name
 dicSetx(ns, name, x)
 @return x;
}
dicNewx ->(dic Dicx, arr Arr_Str, class Cptx)Cptx{
 #r = &Cptx{
  type: T##DIC
  
  class: class
  id: uidx()
  
  dic: dicOrx(dic)
 }
 @if(arr == _){
  @if(dic != _){
   @each k _ dic{
    r.keys.push(k)
   }
  }@else{
   r.keys = &Arr_Str
  }
 }@else{
  r.keys = arr
 }
 @return r
}
dicSetx ->(dic Cptx, key Str, val Cptx)Cptx{
 @if(dic.dic[name] == _){
  dic.keys.push(name)
 }
 @return val
}
objNewx ->(class Cptx, dic Dicx)Cptx{
 #x = &Cptx{
  type: T##OBJ
  id: uidx()
  dic: dicOrx(dic)
  class: class
 }
 @return x
}
uidx ->()Uint{
 uidi ++
 @return uidi;
}

dicOrx ->(x Dicx)Dicx{
 @if(!x){
  @return &Dicx
 }@else{
  @return x
 }
}
callNativex ->(func Cptx, args Arrx, env Cptx)Cptx{
 @return call(Funcx(func.val), [args, env]);
}

callNativex(mainsp.dic["Soul_main"], [], envmainv)
