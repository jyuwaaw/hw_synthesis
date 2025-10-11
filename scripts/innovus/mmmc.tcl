# Multi-Mode/Multi-Corner (MMMC) Analysis Setup
# Configure 1-corner single-model MMMC

# Use typical timing library file for this design
create_library_set -name TYPlib -timing {/users/ugrad/yuhuah2/ISA/NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_typical_conditional_ccs.lib}


# Timing constraints file from synthesis
create_constraint_mode -name CONSTRAINTS -sdc_files {/users/ugrad/yuhuah2/ISA/Flexible-Precision-FP-Accelerator/hw_synthesis/results_synthesized.sdc}

# Create operating condition (P-V-T) for the timing library
create_op_cond -name OPcondition -library_file {/users/ugrad/yuhuah2/ISA/NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_typical_conditional_ccs.lib} -P {1} -V {0.8} -T {25}
# Create RC corner from capacitance table(s)

# Delay corner = timing library
# Worst-case corner = max delay/affects setup times
# Best-case corner = min delay/affects hold times
# For 1-corner use typical values for both
create_delay_corner -name DELAYcorner -library_set TYPlib

# Analysis view = delay corner matched to constraints
create_analysis_view -name TYPview -delay_corner {DELAYcorner} -constraint_mode {CONSTRAINTS}
# Set analysis view to above for both setup and hold
set_analysis_view -setup {TYPview} -hold {TYPview}

# Version:1.0 MMMC View Definition File
# Do Not Remove Above Line
   #create_library_set -name typical -timing {../../../0_FreePDK45/CCS/NangateOpenCellLibrary_typical_ccs.lib ../sram_32_16/sram_32_16_freepdk45_TT_1p0V_25C.lib}
   #create_constraint_mode -name myconstraints -sdc_files {../gate/pulpino_top_nangate45.sdc}
   #create_delay_corner -name default -library_set {typical}
   #create_analysis_view -name ana1 -constraint_mode {myconstraints} -delay_corner {default}
   #set_analysis_view -setup {ana1} -hold {ana1}