T := @enum CPT OBJ CLASS TOBJ\
 INT FLOAT NUMBIG STR BYTES ARR DIC\
 ID CALL ARRMID DICMID
Cptx => {
 type: T

 id: Int

 class: Cptx
 scope: Cptx

 owner: Cptx //for method and prop

 arr: Arrx
 dic: Dicx

 str: Str
 int: Int

 val: Cpt
}
Arrx := @type Arr Cptx
Dicx := @type Dic Cptx
Funcx ->(Arrx, Cptx)Cptx


mainsp := nsNewx()

envmainv := objNewx()
uidi := Uint(1)

dicNewx ->(dic Dicx, arr Arrx, class Cptx)Cptx{
 #r = &Cptx{
  type: T##DIC
  
  class: class
  id: uidx()
  
  dic: dicOrx(dic)
  arr: arrOrx(arr)
 }
 @if(arr == _){
  @if(dic != _){
   @each k _ dic{
    r.arr.push(strNewx(k))
   }
  }@else{
   r.arr = &Arrx
  }
 }@else{
  r.arr = arr
 }
 @return r
}

nssp := 

nsNewx ->(name Str)Cptx{
 Cptx#x = dicNewx()
 x.name = "Ns_" + name
 x.str = name
 @return x;
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
