# #########################################################################################
# Design Compiler: Environmental settings script 
# #########################################################################################


set tropographical_mode 0 
# A list of the input ports of the design "if you needed to list some inputs" 
# --Note: You can make any number of lists as needed 
set list_inputs { rstb en } 



# List of output ports of the design "if you needed to list some outputs"
#--Note: You can make any number of lists as needed. 
set list_outputs {count_1}  
set clk {clk}



# #########################################################################################
# System Interface
# #########################################################################################

# Change this variable to change the driving cell.
set driving_cell INVCGD 


# Get the desired input port(or list of ports) you want to be drived by the cell you chose.
# --Note: if you didn't set a driving cell to an input port the default is zero.  
set_driving_cell -lib_cell $driving_cell [get_ports $list_inputs] 


# Use to set the drive resistance on ports of the design when the input port drive capability cannot be characterized with a cell in the technology library.(example: the port is drive by a resistance 1.5 kohms)
# Get the desired input port(or list of ports) you want to be drived by the 'value' you chose.
#--Note: the 'set_driving_cell' command is more convenient and accurate than 'set_drive'for describing the drive capability of a port.
set_drive 3 [get_ports $list_inputs] 

# For heavily loaded driving ports, such as clock lines, keep the drive strength setting at 0.
set_drive 0 [get_ports $clk] 


# Get the desired input port(or list of ports) you want to remove the drived cell you chose from it.
#remove_driving_cell $driving_cell [get_ports $list_inputs] 


# Change the value by the desired capacitance load. 
# Get the desired input/output port(or list of ports) you want to be loaded by this capacitance value. 
# by writing [-min]/[-max] Indicates that the load value is to be used for minimum/maximum delay analysis. 
set_load 5 [get_ports $list_outputs] 
set_load 5 [get_ports $list_inputs] 
 

# Get the desired output port(or list of ports) you want to set on it this fanout load. 
# --Note: fanout load is dimenionless number not capacitance.
set_fanout_load 3 [get_ports $list_outputs]     
  

# #########################################################################################
# Logic Constraints
# #########################################################################################
  
# Use if you want to specify one or more input ports in the current design to be driven by don't care/Zero/one 
#set_logic_dc   [get_ports $list_inputs]  
#set_logic_zero [get_ports $list_inputs]
#set_logic_one  [get_ports $list_inputs] 

# Use if you want to specifies output ports to be unconnected to outside logic.
#set_unconnected [get_ports $list_outputs] 


# #########################################################################################
# Wire Load Models
# #########################################################################################

if (!($tropographical_mode)) {
# Change the name of the wire model.
set_wire_load_model -name enG5K  

# Choose the wire load mode #
# Top => The default, specifies that the wire capacitance of all nets is calculated using the wire load model set on the top-level design. 
set_wire_load_mode top 

# Enclosed => specifies that the wire capacitance of each net is calculated using the wire load model set on the smallest subdesign that completely encloses that net.  
#set_wire_load_mode enclosed 

# Segmented => specifies that for each net that crosses hierarchical subdesigns, the wire capacitance is calculated for each segment of the net based on the wire load model set on the subdesign that contains that segment.The total wire capacitance of the net is the sum of the wire capacitances of its segments
#set_wire_load_mode segmented 


# Turn on auto wire load selection (library must support this feature) 
#set auto_wire_load_selection true
  }


# #########################################################################################
# Operating Condition
# #########################################################################################

# Change the variable to change the operating condition. 
set_operating_conditions WCCOM -lib $lib_name  

 

# #########################################################################################
# Power Intent
# #########################################################################################


 

 





# Mahmoud Abdellatif :
##1 add to set_operating_conditions with -lib Lib_Name.db     
#2 ask Abdelrahman to add report_design to his report to be able to know which operating condition is synthesized
##3 for wire model, it is used when DC is not in tropographical_mode (add this condition : if (! tropographical_mode) ... and add all wire load commands inside the IF condition   Done
#4 In Presentation : Example 6-1/ 6-2 add commands and results for what user should do before running DC to know the available operating condition & wire load model/moded/auto_wire_load_selection
#5 but don't use the result in the manual and make it yourself by DC
#6 In Presentation : Figures 6-1 / 6-2 / 6-3 are important with illustration and examples 
#7 In Presentation : Answer this : why to consider best caese and worst case not only the worst case ?
#8 In Presentation : Please add what is auto_wire_load_selection pros and cons
##9 Why line 100 is here ? is this a library command ?
##10 read the comment on set_driving_cell for clock signal on page 6-10 and make a command for the clock separately 
##11 from Figure 6-3 and the example on it modify the comments you wrote to be more clear ) 
##12 why didn't you add set_load on inputs as well 
##13 add to Logic constraints : set_unconnected because we might need it 
##14 leave Power Intent section empty Done 
##15 rename the script and make all letters lowercase Done
# Thanks Manar, the script is clear that made me try to make it perfect :-) # you're welcome, i hope to make it perfect as well :) # 
