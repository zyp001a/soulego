@load "seeddb"

progns := classNsNewx("env", dbns);
nsx(progns, progns)

progc := classxNewx("Prog", progns, lifec);

progShellc := classxNewx("ProgShell", progns, progc);
objxNewx("default", progns, progShellc)
