# #########################################################################################
# Design Compiler: Main Script
# #########################################################################################

# -- Top script that call all other scripts sequentially, define variables and path directories 


# #################################
# -- Work variables
# #################################

# Use $work_path afterwards as a variable instead of writing the path every time you need it.
set work_path /home/eslam/Youstina/first-trial

# Instead of Top_level write the name of the design.v file 
set DESIGN counter



# #################################
# -- Define path directories for file locations
# #################################

set source_path $work_path/src/
set script_path "./scr/"
set log_path "./log/"
set ddc_path "./ddc/"
set db_path "./db/"
set netlist_path $work_path/netlist/
set report_path $work_path/rpt/


# #################################
# -- Calling scripts 
# #################################

source library_settings.tcl
source file_reading.tcl
source environment_settings.tcl
source design_rule_setting.tcl
source timing_area_constraint_setting.tcl 
source compile_check_write_design.tcl
source report.tcl



