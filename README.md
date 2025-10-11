# Hardware Synthesis Flow  
**Last updated:** April 16, 2025

This repository provides scripts and step-by-step instructions for running hardware synthesis with Synopsys Design Compiler and place-and-route (P&R) with Cadence Innovus on the UCI ECE department servers.

## Table of Contents
- [Prerequisites](#prerequisites)
  - [Server Access](#server-access)
  - [SSH Clients](#ssh-clients)
- [Directory Structure](#directory-structure)
- [Design Compiler Workflow](#design-compiler-workflow)
  - [Setup](#setup)
  - [Synthesis Steps](#synthesis-steps)
  - [Changing the Standard Cell Library](#changing-the-standard-cell-library)
- [Innovus Place & Route Workflow](#innovus-place--route-workflow)
  - [Setup](#setup-1)
  - [Importing the Synthesized Netlist](#importing-the-synthesized-netlist)
  - [Power and Ground Setup](#power-and-ground-setup)
  - [Running the P&R Script](#running-the-pr-script)
- [Troubleshooting](#troubleshooting)
  - [Design Compiler Issues](#design-compiler-issues)
  - [Innovus Issues](#innovus-issues)
- [License / Contact](#license--contact)

---

## Prerequisites

### Server Access
- You must have access to the UCI ECE servers (Duo two-factor authentication is required).  
- For account setup and policies, see: https://newport.eecs.uci.edu

**Available servers:**
- `bondi.eecs.uci.edu`  
- `laguna.eecs.uci.edu`  
- `zuma.eecs.uci.edu`  
- `crystalcove.eecs.uci.edu`

### SSH Clients
- **VS Code**: Ideal for command-line workflows (Design Compiler, VCS, etc.).  
- **MobaXterm**: Recommended for GUI tools for Windows (Innovus, Virtuoso, etc.).
- **XQuartz**: Recommended for GUI tools for MacOS (Innovus, Virtuoso, etc.).

---

## hw_synthesis Directory Structure
```
/                      # Repository root
├── scripts/          # Setup and run scripts
│   ├── dc/           # Design Compiler scripts
│   └── innovus/      # Innovus scripts
├── src/              # RTL source files
├── results/          # Synthesis and P&R outputs
└── file_list.tcl     # List of source files for synthesis
```

---

## Design Compiler Workflow

### Setup
1. SSH into an ECE server.  
2. Source the DC environment:
   ```bash
   source scripts/dc/setup_dc.csh
   ```

### Synthesis Steps
1. Place your RTL files under `src/`.  
2. Update `file_list.tcl` with your file paths.  
3. Run the synthesis:
   ```bash
   make dc
   ```
4. Post-process the synthesized netlist (`results_synthesized.v`):
   ```bash
   sed -i 's/AND2_X1/AND2_X1_Benji/g' results_synthesized.v
   sed -i 's/FA_X1/FA_X1_Benji/g'     results_synthesized.v
   ```
   *Alternatively, define custom cell names in `macro.lef`.*

### Changing the Standard Cell Library
- By default, this flow uses the Nangate 15nm library.  
- To switch libraries, edit `variables.tcl` in `scripts/dc/`.

---

## Innovus Place & Route Workflow

### Setup
1. Source the Innovus environment:
   ```bash
   source scripts/innovus/setup_innovus.csh
   ```
2. Launch Innovus:
   ```bash
   innovus
   ```

### Importing the Synthesized Netlist
1. In the Innovus GUI, go to **File > Import Design**.  
2. Select `results_synthesized.v`.  
3. Under **Tech / Physical Libraries**:
   - Import `tech.lef` first, then `macro.lef`.  
   > ⚠️ Importing in the wrong order will cause errors.
4. (Optional) Load your IO assignment file.

### Power and Ground Setup
- **Power nets:** `VDD` (or your custom net)  
- **Ground nets:** `GND` (or your custom net)  
Ensure these names match those used in your TCL scripts (e.g., `mmmc.tcl`, Power ring floorplaning).

### Running the P&R Script
```tcl
source scripts/innovus/mmmc.tcl
source scripts/innovus/All_in_one.tcl
```

---

## Troubleshooting

### Design Compiler Issues
- **Error: `reference not found`**  
  Verify your `include` statements and paths in `file_list.tcl`.

### Innovus Issues
- 

---

## License / Contact
For questions or support, please contact:  
**Benji** — yuhuah2@uci.edu

