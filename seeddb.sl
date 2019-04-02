@load "seedbnf"

dbns := classNsNewx("db", bnfns);
nsx(dbns, dbns)

dbGetx ->(ns Classx, key Str)Str{
 #fstr = osEnvGet("HOME")+"/soulego/db/" + Str(ns.obj) + "/" + key + ".sl" 
 #f = @fs.stat(fstr)
// #f2 = @fs.stat(fstr+"t")
 #fcache = @fs.stat(fstr+".cache")
 @if(f != _ && f.len()>0){
  Str#str = @fs[fstr]
  @if(f["timeMod"] > fcache["timeMod"]){
   Str#jstr = osCmd(osEnvGet("HOME")+"/soulego/parser", str)
   @fs[fstr + ".cache"] = jstr
  }@else{
   Str#jstr = @fs[fstr + ".cache"]
  }
 }
}
dbx["val"] = ->(ns Classx, key Str)Classx{
 #jstr = dbGetx(ns, key)
 @if(jstr){
  #ast = JsonArr(jstr)
  @if(ast.len() == 0){
   log(jstr)
   die("dbGetx: wrong grammar")
  }
  @return inx(ast, undNewx(ns));
 }
}