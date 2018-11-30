# #########################################################################################
# Design Compiler : Reports Script
# #########################################################################################

# #########################################################################################
# -- This script writes the netlist output file, genrerates reports for the design, area, timing and power and writes out the parasitics in SPEF or SPBF formats
# -- Note: this script assumes the toplevel design name was put into a variable 
#    called my_toplevel prior to this script
# #########################################################################################
#NOTES:
#-------
#[-nosplit] is an option used for not splitting lines when column fields overflow
#(remove the # at the beginning of the line to activate the commands)
 
# The following section writes out the synthesized netlist in a .v file

set filename [format "%s%s"  $DESIGN ".v"]
write -format verilog -hierarchy -output $filename

set filename [format "%s%s"  $DESIGN ".ddc"]
write -format ddc -hierarchy -output $filename


 

#############################################          DESIGN  ANALYSIS          #####################################################
######################################################
 

#NAME
#         report_constraint
#                    Displays constraint-related information about a design.
#DESCRIPTION
#         The   report_constraint   command   displays the following information for the constraints on the current design: whether the constraint   is   violated   or met, by how much the constraint value is violated or met, and the design object that is the worst violator.

#################################################################################################
report_constraint > ${DESIGN}_constraint.rpt;    # report constraint


##########################################################
report_attribute > ${DESIGN}_attribute.rpt;     # report attribute


##################################################################
############################################################
#You can display the balanced buffer tree and its level information at a given driver pin by
#using the report_buffer_tree command
report_buffer_tree > ${DESIGN}_buffer_tree.rpt;   # report buffer tree


###################################################################

#NAME
#         report_bus
#                    Reports   the bused ports or nets in the current instance or current design.
#

############################################################
report_bus > ${DESIGN}_bus.rpt;           # report_bus
############################################################
#NAME
#         report_cell
#                    Reports cell information.

#################################################################
report_cell > ${DESIGN}_cell.rpt;          # report cell


###################################################################################

#NAME
#         report_design
#                    Displays attributes on the current_design.

#####################################################################################################
report_design > ${DESIGN}_design.rpt;        # report design



#############################################################################################################

#NAME
#         report_hierarchy
#                    Reports   the reference hierarchy of the current_instance or cur-
#                    rent_design.

############################################################################################################
report_hierarchy > ${DESIGN}_hierarchy.rpt;     # report hierarchy


############################################################################################################
#NAME
#         report_lib
#                    Reports library information.
#DESCRIPTION
#         A library report displays library information including a list of operating conditions, wire load models, and available library cells.
#############################################################################################
report_lib $lib_name > ${DESIGN}_libraryrep.rpt;           # find design or library objects



                   
##########################################################################################################
#NAME
#         report_net
#                    Generates a report of net information.

##########################################################################################################
report_net > ${DESIGN}_net.rpt;           # report net




#############################################################################################################
report_operating_conditions -library $lib_name > ${DESIGN}_operating_conditions.rpt
#############################################################################################################

#NAME
#         report_port
#                    Displays port information within the design.

#############################################################################################################
report_port > ${DESIGN}_port.rpt;          # report port


#############################################################################################################
#NAME
#         report_reference
#                    Reports the references in current instance or design.

report_reference > ${DESIGN}_reference.rpt;     # report reference

#############################################################################################################

report_qor > ${DESIGN}_qor.rpt;           # report Quality Of Results


 
#############################################      AREA  ANALYSIS       #######################################################

#Area report file generated using design compiler contains detail information about the size of each cell used for this model.

######################################################
report_area > ${DESIGN}_area.rpt;          # report area




 
#############################################       TIMING  ANALYSIS        #####################################################

#NAME
#report_clock

#DESCRIPTION
#         Reports clock-related information. 
#####################################################
report_clock > ${DESIGN}_clock.rpt;         # report clock



##########################################################################
report_clock_gating_check > ${DESIGN}_clock_gating_check.rpt; # report clock gating check

#########################################################################
#NAME
#report_clock_timing

#DESCRIPTION
#This command generates a report of clock   timing   information   for   the current design.

####################################################
report_clock_timing -type summary > ${DESIGN}_clock_timing.rpt;  # report clock timing, alternatively latency/skew/transition


###########################################################################################################

report_timing > ${DESIGN}_timing.rpt;        # report timing (Provides a report of timing information for the current design).

 
#############################################         POWER  ANALYSIS      ######################################################




#############################################################################################################
#NAME
#        report_power
#                    Generate power reports.

#############################################################################################################
report_power > ${DESIGN}_power.rpt;         # display power report

# Youstina:
# I edited lines 91 and 108 as they were missing a required argument (library name)
# I also made all reports to be dumped in .rpt files instead of being displayed in shell

# --The following writes out the parasitics in SPEF or SPBF format (only spef supported pre-route)
# --You may edit the -format option to be reduced or distributed: For reduced format, there is one 
# resistance and capacitance per net. In distributed  format, the entire RC tree is written out for each net.

set filename [format "%s%s"  $DESIGN ".spef"]
write_parasitics -format distributed -output $filename

set filename [format "%s%s"  $DESIGN ".sdf"]
write_sdf $filename

set filename [format "%s%s"  $DESIGN ".sdc"]
write_sdc $filename

set filename [format "%s%s"  $DESIGN ".upf"]
save_upf $filename


