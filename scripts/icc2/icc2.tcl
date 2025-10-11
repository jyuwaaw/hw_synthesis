# Load the required technology libraries and setup
set output_path "/users/ugrad/yuhuah2/ISA/Flexible-Precision-FP-Accelerator/hw_synthesis/rpt/PnR"

# Define paths to your files
set DESIGN_NAME PE
set TOP_CELL my_PE
set verilog_file "./results_synthesized.v"
set sdc_file "./results_synthesized.sdc"
#set tech_lef "./lib/NanGate_15nm_OCL.tech.lef"
set tech_lef "/users/ugrad/yuhuah2/ISA/TSMC.90/aci/sc-x/lef/tsmc090lk_4lm_2thick_tech.lef"
set lib_files [list /users/ugrad/yuhuah2/ISA/TSMC.90/aci/sc-x/libsi/typical.lib /users/ugrad/yuhuah2/ISA/TSMC.90/aci/sc-x/libsi/fast.lib]
set milkyway_lib "/users/ugrad/yuhuah2/ISA/TSMC.90/fe_TSMCHOME_tpdn90g2_130a/digital/Back_End/milkyway/tpdn90g2_130a/5lm/frame_only/tpdn90g2/lib"

# Create and set the design library
#create_lib -technology $tech_lef my_library
create_lib  my_library
#open_lib my_library

# Create a new cell
#create_design $DESIGN_NAME -library my_library
#create_mv_cells $DESIGN_NAME -lib my_library

# Read the Verilog file
read_verilog -top $TOP_CELL $verilog_file

# Read the SDC file
read_sdc $sdc_file

# Read the technology LEF file
read_tech_lef $tech_lef

# Initialize floorplan (adjust parameters as needed)
initialize_floorplan -site core_site -core_utilization 0.7 -aspect_ratio 1.0 -core_width 100 -core_height 100

# Place the standard cells
place_opt -effort high

# Perform Clock Tree Synthesis (CTS)
create_clock_tree -name my_clock_tree -root_pin CLK -target_skew 0.1

# Route the design
route_opt -effort high

# Perform post-route optimization
route_opt -post_route -effort high

# Extract parasitics
extract_rc

# Perform timing optimization
time_opt

# Verify the design
verify_geometry
verify_connectivity
verify_timing

# Save the design
save_design

# Write out the final files
write_def $output_path/PE.def
write_stream -format gds2 -output $output_path/PE.gds
write_verilog -output $output_path/PE_final.v

quit