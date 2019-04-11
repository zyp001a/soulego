@load "seedsoul"
selfns := classNsNewx("self", soulns);
nsx(selfns, selfns)

envSelfo := objxNewx("self", selfns, envc, {
 mem: memNewx(classMemNewx(soulns))//TODO multi ns
}Cpt)
soulSelfo := objxNewx("self", selfns, soulc, {
 mem: memNewx(classMemNewx(selfns))//TODO multi ns
 env: envSelfo
}Cpt)
callx(soulMainf.obj, [soulSelfo]Cpt)

