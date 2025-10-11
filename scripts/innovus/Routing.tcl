##### Routing TCL #####
globalDetailRoute

##### Add Filler Cells #####
# Set the name(s) of the filler cell(s) in the cell libraryset
fillerCells [list FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64 ]
# Add the filler cells
setFillerMode -corePrefix ${BASENAME}_FILL -core ${fillerCells}
addFiller -cell $fillerCells -prefix ${BASENAME}FILL -markFixed

report_power                        > $rpt_path/post_PnR_power.rpt