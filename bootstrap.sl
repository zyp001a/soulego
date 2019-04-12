call (func {
 call log "bootstrap"
 call imp ProgShell_default (get main "Env") Lang_go//imp env
//assign _this (bear _env)//run env bear, imp self
//main _this//run self
})