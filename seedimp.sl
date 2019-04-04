@load "seedagent"

impns := classNsNewx("imp", agentns);
nsx(impns, impns)

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #tar = Classx(arr[0])
 #r = impx(tar)
 log(tar)
 log(r)
}, anyc, midc)//nsc use any for convenience

impx ->(cla Classx)Midx{
 #r = midNewx(paragraphf) 
 @return r
}
