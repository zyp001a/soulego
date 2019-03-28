@load "seedbase"
dbGetx ->(ns Classx, key Str)Classx{
 #fstr = osEnvGet("HOME")+"/soulx/db/" + Str(ns.obj) + "/" + key + ".sl" 
 #f = @fs.stat(fstr)
 #f2 = @fs.stat(fstr+"t")
 @if(f){
  Str#str = @fs[fstr]
  @if(f["timeMod"] > fcache["timeMod"]){
   Str#jstr = osCmd(osEnvGet("HOME")+"/parser", "name key (" + str + ")")
   @fs[fstr + ".cache"] = jstr
  }@else{
   Str#jstr = @fs[fstr + ".cache"]
  }
 }
 /*
 #fcache = @fs.stat(fstr+".cache")
 #f2cache = @fs.stat(fstr+"t.cache")  
 @if(f2){
  str = "@`"+@fs[fstr+"t"]+"` '"+fstr+"t'";
  @if(f2["timeMod"] > f2cache["timeMod"]){
   Str#jstr = osCmd(osEnvGet("HOME")+"/soul2/sl-reader", key + " := "+str)
   @fs[fstr + "t.cache"] = jstr
  }@else{
   Str#jstr = @fs[fstr + "t.cache"]  
  }
 }@else{
  @return _
 }
 */
 Astx#ast = JsonArr(jstr)
 @if(ast.len() == 0){
  log(fstr)
  die("dbGetx: wrong grammar")
 }
 Cpt#r = ast2cptx(ast, scope, classNewx())
 @return r
}