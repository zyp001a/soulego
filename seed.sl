@load "seedsoul"
selfns := classNsNewx("self", soulns);
nsx(selfns, selfns)
selfns.cpath = "v1"

envSelfo := objxNewx("self", selfns, envc, {
 mem: memNewx(classMemNewx(soulns))//TODO multi ns
}Cpt)
soulSelfo := objxNewx("self", selfns, soulc, {
 mem: memNewx(classMemNewx(selfns))//TODO multi ns
 env: envSelfo
}Cpt)
callx(soulMainf.obj, [soulSelfo]Cpt)

