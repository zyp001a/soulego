@load "seedimp"

envns := classNsNewx("env", impns);
nsx(envns, envns)

envc := classxNewx("Env", envns)//TODO static mem.heap

envprogc := classxNewx("Env_Prog", envns, envc, progc)

bearf := funcNewx("bear", envns, ->(arr ArrCptx)Cpt{
 // assign newsoul (new Soul)
 // prog = Framework_golang imp (Framework_soulimp imp soul)
 // prog.main()

 log("bear")
}, envc)

funcNewx("bootstrap", envns, , ->(arr ArrCptx)Cpt{
// prog = Framework_golang imp (Framework_soulimp imp this)
//  prog.main()
 log("bootstrap")
}, envc)

funcNewx("main", envns, , ->(arr ArrCptx)Cpt{
 log("main")
}, envprogc)

envNewx ->(ns Classx)Objx{
 @return objNewx(envprogc, {  
  mem: memNewx(classMemNewx(ns))
 }Cpt)
}
