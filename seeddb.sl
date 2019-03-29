@load "seedbnf"

dbns := classNsNewx("db", bnfns);
nsx(dbns, dbns)

dbx["val"] = ->(ns Classx, key Str)Classx{
 #fstr = osEnvGet("HOME")+"/soulx/db/" + Str(ns.obj) + "/" + key + ".sl" 
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
 @if(jstr){
  #ast = JsonArr(jstr)
  @if(ast.len() == 0){
   log(fstr)
   die("dbGetx: wrong grammar")
  }
  @return inx(ast, undNewx(ns));
 }
}