# #########################################################################################
# Design Compiler : Compile Script
# #########################################################################################

# #########################################################################################
# -- This script compiles the design, writes the synthesized netlist and checks 
#    the design, timing, etc.. and dumps results in a .out file 
# -- Note: this script assumes the toplevel design name was put into a variable 
#    called DESIGN prior to this script
# #########################################################################################


current_design $DESIGN

# default map effort is medium, change to high (or low, not recommended) if you desire dc to exert more effort to optimize the critical path
set map_efort medium 

# --Default is to start with normal compile then go ahead to incremental compile, set to 1 to use incremental compile
# --Only gate level optimization is performed, design is not taken back to gtech (generic technology), no logic level optimization, designware implementation may #   be changed
set incremental_mapping 0 

# default of dc is not to fix hold time violations (fixed post-layout, however set this variable to 1 to fix hold time violations while compiling
set fix_hold 0 

# Choose normal compile (0) or compile_ultra (1)
set compile_mode 0

# list all the clock objects in your design here
set all_clock_objects { clk } 


# set to 0 if you want default setting (structure, with minimum effort)  
set flatten_structure structure 

# set to 0 to use uniquify (separate copy for each instance, each optimized separately), or 1 to use set_dont_touch (optimize once and use same netlist for all 
# instances, or 2 to use ungroup (melt down hierarchy entirely) 
set multiple_instance_resolve 0

# Object list that need multiple instance resolution command --TODO: TEST THIS
#set multiple_inst_list= { block_A block_B }

# Set to zero if you do not want to optimize clock gating and 1 to optimize clock gating
set opt_clock_gating 0


if { $fix_hold == 1 } {
# Tell DC to attempt to fix hold time violations 
set_fix_hold [get_clocks $all_clock_objects]   
}



# #########################################################################################
# -- Resolving multiple instances
# #########################################################################################

if {$multiple_instance_resolve == 0} {
# use uniquify
uniquify 
} elseif {$multiple_instance_resolve == 1} {
# --Use set_dont_touch
# --Note: The type of object to set dont touch for may be cells or designs, so modify accordingly
set_dont_touch [get_cells $multiple_inst_list] 
} else {
# use ungroup
ungroup [get_cells $multiple_inst_list]
}



# #########################################################################################
# -- Optimization flow
# #########################################################################################


if {$flatten_structure=="flatten"} {
# Tell DC to flatten (implement as SOP, 2 level hierarchy only)
set_flatten true 
} elseif {$flatten_structure=="structure"} {
# Retains multiple levels of hierarchy
set_structure true 
}



# Incremental mapping allows for performing only incremental changes, map_effort indicates the amount of CPU time (effort) spent on mapping to gates
#compile -incremental_mapping -map_effort high
# --Note: I have read into this -inc and as I understand it is the same as -incremental_mapping, but I would like to verify this?
# --You may alternatively use the option area_high_effort_script to make DC exert more effort to optimize area
#compile_ultra -inc -timing_high_effort_script
# Use this option to use clock gating
compile -gate_clock


# #########################################################################################
# -- Design and Timing checks
# #########################################################################################
check_design > ${DESIGN}_design_check.out
check_timing > ${DESIGN}_timing_check.out

# The following section writes out the synthesized netlist in a .v file in the ./syn directory


set filename [format "%s%s"  $DESIGN ".syn.v"]
write -format verilog -hierarchy -output $filename

set filename [format "%s%s"  $DESIGN ".sdc"]
write_sdc $filename

set filename [format "%s%s"  $DESIGN ".upf"]
save_upf $filename


# ScanDEF


