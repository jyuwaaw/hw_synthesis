#### Floor Planning.............
#floorPlan -coreMarginsBy die -site CoreSite -r 0.994006640125 0.7 10 10 10 10
#floorPlan -coreMarginsBy die -site CoreSite -s 1400 1400 10 10 10 10
#floorPlan -site CoreSite -noSnapToGrid -d 1850 1850 10 10 10 10
#floorPlan -coreMarginsBy die -site CoreSite -r 0.999758842733 0.7 260 260 260 260
###Add IO Fillers.........
addIoFiller -cell pfeed10000 -prefix FILLER -side n
addIoFiller -cell pfeed10000 -prefix FILLER -side e
addIoFiller -cell pfeed10000 -prefix FILLER -side w
addIoFiller -cell pfeed10000 -prefix FILLER -side s
### Global Netconnect...........
globalNetConnect VDD -type pgpin -pin VDD -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -verbose -netlistOverride
globalNetConnect VDDO -type pgpin -pin VDDO -verbose -netlistOverride
globalNetConnect VSSO -type pgpin -pin VSSO -verbose -netlistOverride
### Add Power Rings.............
addRing -skip_via_on_wire_shape Noshape -snap_wire_center_to_grid Grid -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer TOP_M -type core_rings -jog_distance 0.56 -threshold 0.56 -nets {VDD VSS} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right TOP_M left TOP_M} -width 2 -spacing 1

### Add Speacial Routes.........
sroute -connect { corePin } -layerChangeRange { M1 TOP_M } -blockPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { M1 TOP_M } -nets { VDD VSS } -allowLayerChange 1 -targetViaLayerRange { M1 TOP_M }

### Add Stripes.............
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit TOP_M -max_same_layer_jog_length 0.88 -snap_wire_center_to_grid Grid -padcore_ring_bottom_layer_limit M3 -set_to_set_distance 50 -skip_via_on_pin Standardcell -stacked_via_top_layer TOP_M -padcore_ring_top_layer_limit TOP_M -spacing 1 -merge_stripes_value 0.56 -layer TOP_M -block_ring_bottom_layer_limit M3 -width 2 -nets {VDD VSS} -stacked_via_bottom_layer M1

### Placement of Standard Cells.....without any optimization......
setPlaceMode -fp false
#setPlaceMode -placeIoPins true
placeDesign -noPrePlaceOpt
#place_opt_design

###command to load a design.......innovus -init omp.enc
##after launching innovus.......source omp.enc
#saveDesign omp.enc

### Setting for preCTS......
setDelayCalMode -siAware false
timeDesign -preCTS 
report_timing 
optDesign -preCTS 

### Clock Tree Synthesis.........
create_ccopt_clock_tree_spec
ccopt_design
#or 
#clockDesign -specFile omp.ctstch -outDir clk_report
#displayClockTree -clk mCLK -level 1  ----not checked properly

### Post CTS Optimization.....
timeDesign -postCTS
optDesign -postCTS
timeDesign -postCTS
#####nanoroute...........turnoff Fix antenna

setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven 1
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail


setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -routeAntennaCellName {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {dl04d1 bufbd7 buffd2 dl03d1 bufbdf buffda dl02d2 dl03d4 dl04d2 dl02d1 dl01d4 buffd3 bufbda bufbdk buffd4 dl04d4 dl02d4 bufbd4 dl01d2 bufbd3 bufbd1 dl01d1 buffd7 bufbd2 buffd1 dl03d2 inv0d2 invbda inv0da invbdk inv0d1 inv0d7 invbd4 invbd2 inv0d0 invbd7 invbdf inv0d4} -maxAllowedDelay 1
setNanoRouteMode -quiet -routeAntennaCellName adiode
setNanoRouteMode -quiet -routeTdrEffort 5
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail -viaOpt -wireOpt

### Post Route Anlysis.......0.0
setAnalysisMode -analysisType onChipVariation
timeDesign -postRoute
## optional when there is any violation....
 optDesign -postRoute -hold

timeDesign -postRoute 
report_timing
setAnalysisMode -checkType hold
report_timing 
report_power
report_constraint -all_violators
report_ccopt_skew_groups

### Metal Fill..
addFiller -cell feedth9 -prefix FILLER -doDRC
addFiller -cell feedth3 -prefix FILLER -doDRC
addFiller -cell feedth -prefix FILLER -doDRC

###Verify Geometry
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }

###Verify DRC
get_verify_drc_mode -disable_rules -quiet
get_verify_drc_mode -quiet -area
get_verify_drc_mode -quiet -layer_range
get_verify_drc_mode -check_implant -quiet
get_verify_drc_mode -check_implant_across_rows -quiet
get_verify_drc_mode -check_ndr_spacing -quiet
get_verify_drc_mode -check_only -quiet
get_verify_drc_mode -check_same_via_cell -quiet
get_verify_drc_mode -exclude_pg_net -quiet
get_verify_drc_mode -ignore_trial_route -quiet
get_verify_drc_mode -max_wrong_way_halo -quiet
get_verify_drc_mode -use_min_spacing_on_block_obs -quiet
get_verify_drc_mode -limit -quiet
set_verify_drc_mode -disable_rules {} -check_implant true -check_implant_across_rows false -check_ndr_spacing false -check_same_via_cell false -exclude_pg_net false -ignore_trial_route false -report test.drc.rpt -limit 1000
verify_drc
set_verify_drc_mode -area {0 0 0 0}

###Verify Connectivity
verifyConnectivity -type all -error 1000 -warning 50

saveNetlist omp_post_layout.v

### Save DEF file
set dbgLefDefOutVersion 5.8
global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.8
defOut -floorplan -netlist -routing omp_post_layout.def
set dbgLefDefOutVersion 5.8
set dbgLefDefOutVersion 5.8

### GDS file Stream 
streamOut omp_gds.gds -mapFile libraries/lef/gds2_fe_4l.map -libName DesignLib -units 20000 -mode ALL
streamOut omp_gds.gds -mapFile libraries/lef/gds2_fe_4l.map -libName DesignLib -merge { libraries/tsl18fs120.gds libraries/tsl18cio250_4lm.gds } -units 20000 -mode ALL