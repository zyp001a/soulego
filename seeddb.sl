@load "seedbnf"

dbns := classNsNewx("db", bnfns);
nsx(dbns, dbns)

dbGetx ->(ns Classx, key Str)Str{
 #fstr = osEnvGet("HOME")+"/soulego/db/" + ns.cpath + "/" + key
 #f = @fs.stat(fstr + ".sl")
 #fcache = @fs.stat(fstr+".sl.cache")
 @if(f != _ && f.len()>0){
  Str#str = @fs[fstr+".sl"]
  @if(f["timeMod"] > fcache["timeMod"]){
   Str#jstr = osCmd(osEnvGet("HOME")+"/soulego/parser", str)
   @fs[fstr + ".sl.cache"] = jstr
  }@else{
   Str#jstr = @fs[fstr + ".sl.cache"]
  }
  @return jstr;
 }
 /*
 #d = @fs.stat(fstr) 
 @if(d != _ && d.len()>0){
  @return '["funcns"]';
 }
 */
// #f2 = @fs.stat(fstr+".slt") 
}
dbx["val"] = ->(ns Classx, key Str)Classx{
 #jstr = dbGetx(ns, key)
 @if(jstr){
  #ast = JsonArr(jstr)
  @if(ast.len() == 0){
   log(jstr)
   die("dbGetx: wrong grammar")
  }
  
  @if(cinx(ns.class, classNsSubc)){
   @return inx(ast, undNewx(ns.ns), key);
  }
  @return inx(ast, undNewx(ns), key);   
 }
}