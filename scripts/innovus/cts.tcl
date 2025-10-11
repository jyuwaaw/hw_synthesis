   ## Create the clock tree spec from the .sdc file (from synthesis)
   #createClockTreeSpec -output $rpt_path.ctstch
   ## Set -routeGuide to use routing guide during CTS.
   #setCTSMode -routeGuide true
   ## Set routeClkNet to use NanoRoute during CTS.
   #setCTSMode -routeClkNet true
   ## Perform clock tree synthesis
   #clockDesign -outDir ${rpt_path}_clock_reports
   ##### Command Above Obsolete #####

setCTSMode -engine ccopt
set_ccopt_property use_inverters auto 
#setCCOptMode -cts_opt_type full    ## Obsolete
set_ccopt_property -cts_opt_type full
create_ccopt_clock_tree_spec
return ccopt_design