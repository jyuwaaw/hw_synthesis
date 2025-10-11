# Hardware Synthesis Flow <span style="font-size: 0.5em; color: #777;">Last Revision: Apr 16, 2025</span>

You should get access to ECE department servers. Please refer to this page for more information: [newport.eecs.uci.edu](https://newport.eecs.uci.edu)

# Content Index 📋

- [How to connect to server](#how-to-connect-to-server)
    - [ECE department server list](#ece-department-server-list-duo-two-factor-login-required)
    - [SSH Interfaces](#ssh-interfaces)
- [Design Compiler](#design-compiler)
    - [Quick Trouble Shooting DC](#quick-trouble-shooting-dc)
- [Innovus P&R](#innovus-pr)
    - [Quick Trouble Shooting](#quick-trouble-shooting-innovus)
---

# How to connect to server
## ECE department server list (Duo two-factor login required):
- bondi.eecs.uci.edu
- laguna.eecs.uci.edu
- zuma.eecs.uci.edu
- crystalcove.eecs.uci.edu

## SSH Interfaces
1. VSCode (For Design Compiler, VCS, etc.)
2. MobaXterm (For Innovus, Virtuoso, etc.) *[for Windows]*
3. XQuartz (For Innovus, Virtuoso, etc.) *[for MacOS]*

# Design Compiler
1. Run the following command: `source scripts/dc/setup_dc.csh`
2. Add your files to `/src`
3. Update the `file_list.tcl` to indicate your files
4. Run Makefile: `make dc`
5. In synthesized netlist `results_synthesized.v` 
    - replace all `AND2_X1` with `AND2_X1_Benji`
    - replace all `FA_X1` with `FA_X1_Benji`
    - or you can define anyname you want in *macro.lef*
6. Now you're ready for P&R 


How to change standard cell library (Currently only Nangate 15nm)  
→ Edit `variables.tcl`

### Quick trouble shooting DC
1. error: reference not found:
    - Check your `include` line in design

# Innovus P&R
1. Run the following command: `source scripts/innovus/setup_innovus.csh`
2. Run the `innovus` to invoke Innovus
3. Click `File`, then `Import Design`, Design Import window pops up
    - Add your *results_synthesized.v* file
    - For Tech/Physical Libaries:
        - Select `LEF Files`, Select `···`, Import your lib files
        - **Notice**: You **MUST** select `tech.lef` first, following with `marco.lef`!! Otherwise error will occur.
    - Import your IO Assignment File as needed
    - Power
        - Power     Nets: `VDD` or other. MUST be consistent with other TCLs
        - Ground    Nets: `GND` or other. MUST be consistent with other TCLs
            - e.g. in `mmmc.tcl`, power ring creating commands
    - Analysis Config
        - File directory: `scripts/innovus/mmmc.tcl`
4. Run `All_in_one.tcl`

### Quick trouble shooting Innovus
1. error: 