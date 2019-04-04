@load "seedlang"

envns := classNsNewx("env", langns);
nsx(envns, envns)

envc := classxNewx("Env", envns, agentc)//TODO static mem.heap

bearf := funcNewx("bear", envns, ->(arr ArrCptx)Cpt{
 // assign newsoul (new Soul)
 // prog = Framework_golang imp (Framework_soulimp imp soul)
 // prog.main()

 log("bear")
}, envc)

funcNewx("bootstrap", envns, ->(arr ArrCptx)Cpt{
// prog = Framework_golang imp (Framework_soulimp imp this)
//  prog.main()
 log("bootstrap")
}, envc)

/*
envNewx ->(ns Classx)Objx{
 @return objNewx(envc, {  
  mem: memNewx(classMemNewx(ns))
 }Cpt)
}
*/