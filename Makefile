#include ../Makefile.include

SCRIPT_DIR=./scripts

dc:
	rm -rf rpt
	mkdir rpt
	dc_shell -f $(SCRIPT_DIR)/dc/dc_script.tcl

#vcs:
#	$(SCRIPT_DIR)/vcs/vcs_compile.tcl
#	./simv

icc2:
	rm -rf rpt
	mkdir rpt
	icc2_shell -gui -f $(SCRIPT_DIR)/icc2/icc2.tcl

innovus:
	rm -rf rpt
	mkdir rpt
	$(SCRIPT_DIR)/innovus/PnR.tcl
	
clean:
	rm -f simv
	rm -f *.vcd
	rm -f *.key
	rm -rf csrc/
	rm -rf *.rpt
	rm -rf *.log
	rm -rf *.svf
	rm -rf *.ddc
	rm -rf results_synthesized.v
	rm -rf results_synthesized.sdc
	rm -rf alib-52/
	rm -rf rpt/
	rm -rf simv.daidir/
	rm -rf encounter*
	rm -rf *.mr
	rm -rf *.syn
	rm -rf *.pvl
# Remove temporary files #
	rm -rf innovus.cmd*
	rm -rf innovus.log*
	rm -rf genus.cmd*
	rm -rf genus.log*
	rm -rf crte_*
	rm -rf Synopsys_stack_trace*