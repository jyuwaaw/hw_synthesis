#############################################################
##### Innovus Synthesis config for FlexiBit Acceleraotr #####
#############################################################
# File Author: Benji Huang
# Create Date: Nov 1, 2024
#
# Dependencies:     Following packages are missing on EECS department server which is required by Innovus
#                   /users/ugrad/yuhuah2/local_lib/libgfortran.so.3
#                   /users/ugrad/yuhuah2/local_lib/libgfortran.so.3.0.0
# Target Devices: 
# Tool Versions:    v21.10-p004_1, built Tue May 18 11:58:29 PDT 2021
# Host:             bondi.eecs.uci.edu  (x86_64 w/Linux 4.18.0-553.5.1.el8_10.x86_64) 
#                                       (14cores*56cpus*Intel(R) Xeon(R) CPU E5-2660 v4 @ 2.00GHz 35840KB)
# OS:               Rocky Linux release 8.10 (Green Obsidian)
# License:          invs Innovus Implementation System   21.1    checkout succeeded
# 8 CPU jobs allowed with the current license(s). Use setMultiCpuUsage to set your required CPU count.
#
# Envoriment Setup: hw_synthesis/scripts/innovus/setup_innovus.csh

innovus &

### Report Path setup ###
set rpt_path "./post_PnR_rpts"


#set init_top_cell “multiplier_DW01_add_0”


### Lef library file setup, ALWAYS read .tech first ###
set init_lef_file{hw_synthesis/lib/NanGate_15nm_OCL.tech.lef hw_synthesis/lib/NanGate_15nm_OCL.macro.lef}

set design_netlisttype verilog
set init_verilog [list hw_synthesis/results_synthesized.v]

set init_pwr_net {VDD}
set init_gnd_net {GND}
set init_mmmc_file {hw_synthesis/scripts/innovus/mmmc.tcl}
#set init_design_set_top 1

init_design



#CPF (Common Power Format) file is optional
#Can be used for low-power design and timing 
#Useful for multiple power domains required
#set init_cpf_file {*.cpf}


### Floor plan dimensions ###
setDrawView fplan
#setFPlanRowSpacingAndType $rowgap 1
floorplan -r 0.8 0.7 20 20 20 20

### Release current design from memory ###
#freeDesign

### Power Planning ###
### Power Rings ###
set pspace 5
set pwidth 2
set poffset 0.2

### Add Power Ring ###
setAddRingMode -stacked_via_top_layer M3 \
    -stacked_via_bottom_layer M1
addRing -nets { VDD GND } \
    -type core_rings \
    -around user_defined \
    -center 0 \
    -spacing $pspace \
    -width $pwidth \
    -offset $poffset \
    -threshold auto \
    -layer {bottom M1 top M1 right M2 left M2 }

#addRing -skip_via_on_wire_shape Noshape -snap_wire_center_to_grid Grid -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer M1 -type core_rings -jog_distance 0.56 -threshold 0.56 -nets {VDD GND} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right M1 left M1} -width 2 -spacing 1

### Power Stripes (Optional) ###
#addStripe -nets { VSS GND } \
   #-layer M2 \
   #-width $swidth \
   #-spacing $pspace \
   #-xleft_offset $soffset \
   #-set_to_set_distance $sspace \
   #-block_ring_top_layer_limit M3 \
   #-block_ring_bottom_layer_limit M1 \
   #-padcore_ring_bottom_layer_limit M1 \
   #-padcore_ring_top_layer_limit M3 \
   #-stacked_via_top_layer M3 \
   #-stacked_via_bottom_layer M1 \
   #-max_same_layer_jog_length 3.0 \
   #-snap_wire_center_to_grid Grid \
   #-merge_stripes_value 1.5

   #sroute  -connect {blockPin padPin padRing corePin floatingStripe } \
   #        -allowJogging true \
   #        -allowLayerChange true \
   #        -blockPin useLef \
   #        -targetViaLayerRange {M1 AM }

   #editPin -side TOP \
   #        -layer M3 \
   #        -fixedPin 1 \
   #        -spreadType CENTER \
   #        -spacing 4 \
   #        -pin { I[0] I[1] I[2] CLEARbar CLK }

   #editPin -side BOTTOM \
   #        -layer M3 \
   #        -fixedPin 1 \
   #        -spreadType RANGE \
   #        -start { 4 0} \
   #        -end {50 0} \
   #        -spreadDirection CounterClockwise \
   #        -pin { Q[0] Q[1] Q[2] L_Cbar }

setPlaceMode    -timingDriven true \
                -congEffort auto \
                -ignoreScan true
placeDesign
setDrawView place

routeDesign
    ##### Command Obsolete #####
    ## Create the clock tree spec from the .sdc file (from synthesis)
    #createClockTreeSpec -output $rpt_path.ctstch
    ## Set -routeGuide to use routing guide during CTS.
    #setCTSMode -routeGuide true
    ## Set routeClkNet to use NanoRoute during CTS.
    #setCTSMode -routeClkNet true
    ## Perform clock tree synthesis
    #clockDesign -outDir ${rpt_path}_clock_reports
    ##### Command Obsolete #####

setCTSMode -engine ccopt
set_ccopt_property use_inverters auto 
#setCCOptMode -cts_opt_type full    ## Obsolete
set_ccopt_property -cts_opt_type full
create_ccopt_clock_tree_spec
return ccopt_design

### Routing TCL ###
globalDetailRoute

### Add Filler Cells ###
# Set the name(s) of the filler cell(s) in the cell libraryset
fillerCells [list FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64 ]
# Add the filler cells
setFillerMode -corePrefix ${BASENAME}_FILL -core ${fillerCells}
addFiller -cell $fillerCells -prefix ${BASENAME}FILL -markFixed

set rpt_path "./post_PnR_rpts"

report_power                        > $rpt_path/post_PnR_power.rpt
report_area                         > $rpt_path/post_PnR_area.rpt
report_timing                       > $rpt_path/post_PnR_timing.rpt
report_route                        > $rpt_path/post_PnR_route.rpt
reportRoute                         > $rpt_path/post_PnR_route_length.rpt
