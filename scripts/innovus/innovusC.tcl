# Load design
read_def your_design.def

# Setup libraries
set_app_var lib_search_path "path_to_your_libs"
set_app_var tech_lib "your_tech_library"
set_app_var design_lib "your_design_library"

# Load power intent file
read_cpf your_power_intent.cpf

# Power grid setup and analysis
pwrgrid_setup -vdd VDD_net -vss VSS_net
pwrgrid_analyze

# Define voltage domains if necessary
set_voltage_domain -name core -voltage 1.0 -domain {core_cells}

# Run static power analysis
report_power -static

# Set activity data for dynamic power analysis
set_activity_file -vcd your_activity_file.vcd

# Run power analysis
power_analysis

# Optimize power
opt_power

# Generate and check power reports
report_power
