@load "seedagent"

impns := classNsNewx("imp", agentns);
nsx(impns, impns)

funcMemNewx("imp", impns, ->(arr ArrCptx, mem Memx)Cpt{
 #tar = Classx(arr[0])
 #r = impx(tar)
 @return r
}, anyc, midc)//Prog class -> mid

impx ->(cla Classx)Midx{
 #r = midNewx(paragraphf)
 log("imp")
 @return r
}
