###############################################
set rpt_path ./hw_synthesis/rpt


#set init_top_cell “multiplier_DW01_add_0”


###### Lef file setup, .tech first ######
set init_lef_file{hw_synthesis/lib/NanGate_15nm_OCL.tech.lef hw_synthesis/lib/NanGate_15nm_OCL.macro.lef}

set design_netlisttype verilog
set init_verilog [list hw_synthesis/results_synthesized.v]

set init_pwr_net {VDD}
set init_gnd_net {GND}

#set init_design_set_top 1

init_design

set init_mmmc_file {hw_synthesis/scripts/innovus/mmmc.tcl}

#CPF (Common Power Format) file is optional
#Can be used for low-power design and timing 
#Useful for multiple power domains required
#set init_cpf_file {*.cpf}



setDrawView fplan
#setFPlanRowSpacingAndType $rowgap 1
floorplan -r 0.8 0.7 20 20 20 20

#freeDesign

### Power Planning ###
### Power Rings ###
set pspace 5
set pwidth 2
set poffset 0.2

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

