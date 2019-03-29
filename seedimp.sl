@load "seedprog"

impns := classNsNewx("imp", progns);
nsx(impns, impns)

classImpc := classxNewx("ClassImp", impns, classc);
impMetac := classObjNewx("meta", impns, classImpc);
impGolang := classObjNewx("golang", impns, classImpc);



funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #imp = Classx(arr[0])
 #tar = Classx(arr[1]).obj//TODO should convert to obj at pre step
 
 #r = impx(imp, tar, mem)
 log(r) 
}, anyc, projc, [progc])//nsc

impNewx("val", impMetac, ->(arr ArrCptx, mem Memx)Cpt{
 #obj = Classx(arr[0]) //it is obj
 log(obj)
 @return "123"
});

impNewx ->(name Str, imp Classx, func FuncMemx)Classx{
 #o = {
  imp: func
  //bnf/rec
 }Cpt
 #oc = objxNewx(name, impns, imp, o)
 @return oc
}

impx ->(imp Classx, mid Midx, mem Memx)Str{
 #id = "imp"+obj.class.name;//TODO it obj.class
 #f = cgetx(imp.ns, imp.name + "_" + id, {});
 @if(!f){
  log(imp.name)
  log(imp.name + "_" + id)  
  log(imp.ns)  
  die("imp error, not defined "+ id)
 }
 @return callMemx(Objx(f.obj).dic["imp"], [obj]Cpt, mem)
}
