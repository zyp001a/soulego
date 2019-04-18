@load "seedbase"
Dicx =>{
 class: Classx
 arr: ArrStrx
 dic: DicCptx
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

structns := classNsNewx("struct", basens)

dicc := classxNewx("Dic", structns);
arrc := classxNewx("Arr", structns);

arrNewx ->(cl Classx){
 
}
dicNewx ->(cl Classx)Dicx{
 @if(!cl){
  cl = dicc
 }
 #x = &Dicx{
  class: cl
  len: 0
  size: 0
  id: uidx()
 }
 x.arr = &ArrStrx
 x.dic = &DicCptx
 @return x
}

dicSetx ->(x Dicx, key Str, val Cpt)Cpt{
 @if(!x.dic[key]){
  x.arr.push(key)
  x.len ++;
 }
 x.dic[key] = val
 @return val
}