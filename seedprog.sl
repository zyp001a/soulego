@load "seeddb"

progns := classNsNewx("env", dbns);
nsx(progns, progns)

progc := classxNewx("Prog", progns, objc);

projc := classxNewx("Proj", progns, progc);