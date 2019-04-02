@load "seedfunc"

viewns := classNsNewx("view", funcns);
nsx(viewns, viewns)

entityc := classxNewx("Entity", viewns);
lifec := classxNewx("Life", viewns, entityc);
selfc := classxNewx("Self", viewns, lifec);



