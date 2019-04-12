@load "seedenv"

langns := classNsNewx("lang", envns);
nsx(langns, langns)

classLangc := classxNewx("Lang", langns, classNsSubc);
langGoc := classNsSubNewx("go", langns, classLangc);

langx ->(lang Classx, prog Progx, mem Memx, mid Midx)Str{
 #func = mid.func;
 #f = ccgetx(lang, func.name, func.dic["main"].prt)
 @if(!f){
  log(lang.name)
  log(lang.cpath)  
  die(func.name + "__" + func.dic["main"].prt.name + " is not defined")
 }
 execx(midNewx(f, [lang, prog, mid]Cpt), mem)
 @return "";
}

