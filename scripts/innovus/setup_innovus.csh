#!/bin/csh
# setup_innovus.csh
# Environment setup script for Cadence Innovus

# Set Innovus installation directory
setenv INNOVUS_HOME /ecelib/eceware/innovus

# Add Innovus bin directory to PATH
set path = ($path $INNOVUS_HOME/bin)

# Set the license server (referencing your provided script)
setenv CDS_LIC_FILE 5280@license.eecs.uci.edu
setenv LM_LICENSE_FILE $CDS_LIC_FILE

# If Innovus uses LD_LIBRARY_PATH, set it accordingly
if ( $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH /users/ugrad/yuhuah2/local_lib:$INNOVUS_HOME/tools/lib:$LD_LIBRARY_PATH
else
    setenv LD_LIBRARY_PATH /users/ugrad/yuhuah2/local_lib:$INNOVUS_HOME/tools/lib
endif

# Optional: Set any other required environment variables
# (Add additional environment variables here if necessary)

# Print confirmation message
echo "Innovus environment setup complete."
