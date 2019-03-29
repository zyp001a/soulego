@load "seedprog"

impns := classNsNewx("imp", progns);
nsx(impns, impns)

classImpc := classxNewx("ClassImp", impns, classc);
impMetac := classObjNewx("meta", impns, classImpc);



funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 log(arr)
}, anyc, projc, [progc])//nsc


impMetaNewx ->(name Str, func FuncMemx)Classx{
 #o = {
  imp: func
  //bnf/rec
 }Cpt
 #oc = objxNewx(name, impns, impMetac, o)
 @return oc
}
