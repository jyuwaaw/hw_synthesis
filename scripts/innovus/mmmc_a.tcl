# Version:1.0 MMMC View Definition File
# Do Not Remove Above Line
create_op_cond -name OPcondition -library_file {../NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NLDM/NanGate_15nm_OCL_typical_conditional_nldm.lib} -P {10} -V {10} -T {10}
create_op_cond -name Typical -library_file {../NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NLDM/NanGate_15nm_OCL_typical_conditional_nldm.lib} -P {10.0} -V {10.0} -T {10.0}
create_library_set -name 15nm_OCL_typical -timing {../NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NLDM/NanGate_15nm_OCL_typical_conditional_nldm.lib}
create_constraint_mode -name CONSTRAINTS -sdc_files {/users/ugrad/yuhuah2/ISA/Flexible-Precision-FP-Accelerator/hw_synthesis/results_synthesized.sdc}
create_constraint_mode -name FlexiBit -sdc_files {hw_synthesis/results_synthesized.sdc}
create_delay_corner -name Delay_Normal -library_set {15nm_OCL_typical}
