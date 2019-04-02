@load "seedprog"

impns := classNsNewx("imp", progns);
nsx(impns, impns)

impBase := 

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #imp = Classx(arr[0])
 #tar = Classx(arr[1]) 
 #r = impx(imp, tar, mem)
 log(r)
}, classImpc, midc, [classc])//nsc use any for convenience

impx ->(imp Classx, cla Classx, mem Memx)Midx{
 #r = midNewx(paragraphf) 

 @return callMemx(Objx(f.obj).dic["imp"], [obj]Cpt, mem)
}
