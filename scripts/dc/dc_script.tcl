#START
source variables.tcl

#start_gui

### Set your TOP design here ###
set target_design "flex_adder"

set rpt_path "./rpt"
set search_path "./lib"
set search_path "/ecelib/eceware/synopsys/syn/S-2021.06/libraries/syn"
#setenv SYNOPSYS /ecelib/eceware/synopsys/syn/S-2021.06
#setenv SYNOPSYS_LIB $SYNOPSYS/libraries/syn

#set search_path "./lib /something_else"

#set hdl/PEin_preserve_sequential true

set PROJECT_PATH /users/ugrad/yuhuah2/ISA/Flexible-Precision-FP-Accelerator/hw_synthesis
set search_path [list $PROJECT_PATH]
set link_library [list ./lib/NanGate_15nm_OCL.db]
set target_library [list $link_library]
set synthetic_library [list $link_library]
report_lib "$link_library"

# Multicore setting
#set multi_core_enable_analysis
# 15 is the maximum availalbe number of cores in DC
set_host_options -max_cores 16

#Read Files

#analyze -library WORK -format sverilog {../hdl/PE/position_aware_adder.sv}

source ./file_list.tcl

###### Analyze command for PE/Top module run ######y WORK -format sverilog {/users/ugrad/yuhuah2/ISA/Flexible-Precision-FP-Accelerator/hdl_fully_parameterized/PE/FlexiBit_multiplier/primitive_generator.sv}
analyze -library WORK -format sverilog {./src/exp_add/input_organizer.sv}
analyze -library WORK -format sverilog {./src/exp_add/exp_add_output_organizer.sv} 

link
uniquify

source ./scripts/dc/dc_timing.sdc
check_design

# Load in the timing constraint file
#update_timing

current_design $target_design

# Reducing power consumption

compile -map_effort medium
#set_leakage_optimization true
#set_dynamic_optimization true
#compile_ultra -gate_clock -no_autoungroup
#set compile_clock_gating_through_hierarchy true
group_path -name critical_path -from [all_inputs] -to [all_outputs]

#compile_ultra -no_autoungroup
#-timing_high_effort_script 

#compile_ultra -retime


change_names -rules verilog -hierarchy -verbose

write -format verilog -hierarchy -output results_synthesized.v
write_sdc results_synthesized.sdc


# timing, area, power reports
report_timing   -nworst 50 \
                -max_paths 50 \
                -path full \
                -delay max \
                -significant_digits 3 \
                -sort_by slack      > $rpt_path/timing_max.rpt
report_timing   -nworst 50 \
                -max_paths 50 \
                -path full \
                -delay min \
                -significant_digits 3 \
                -sort_by slack      > $rpt_path/timing_min.rpt

report_timing   -max_paths 1 \
                -path full \
                -delay max \
                -significant_digits 3 \
                -sort_by slack      > $rpt_path/timing.rpt
report_timing_derate                > $rpt_path/timing_derate.rpt
report_area     -hierarchy          > $rpt_path/area.rpt
report_power    -hier               > $rpt_path/power.rpt
report_power                        > $rpt_path/power_no_hier.rpt
report_net      -cell_degradation   > $rpt_path/net.rpt
report_clock_gating                 > $rpt_path/clock_gating.rpt

# Save the synthesis state
write -hierarchy -format ddc -output synthesis.ddc

quit
