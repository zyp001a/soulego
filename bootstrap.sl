call (func {
 calln "log" "bootstrap"
 calln "imp" ProgShell_default main__Env Lang_go//imp env
//assign _this (bear _env)//run env bear, imp self
//main _this//run self
})