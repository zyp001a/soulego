@load "seedenv"

langns := classNsNewx("lang", envns);
nsx(langns, langns)

classLangc := classxNewx("Lang", langns, classNsSubc);
langGoc := classNsSubNewx("go", langns, classLangc);

langx ->(lang Classx, prog Progx, mem Memx, mid Midx)Str{
 #funccl = mid.func
 #func = Funcx(funccl.obj);
 #f = ccgetx(lang, funccl.name, func.main)
 @if(!f){
  log(lang.name)
  log(lang.cpath)  
  die(funccl.name + "__" + func.main.name + " is not defined")
 }
 callx(f.obj, [lang, prog, mid]Cpt, mem)
 @return "";
}

