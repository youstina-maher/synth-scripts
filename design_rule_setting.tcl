# #########################################################################################
# Design Compiler : Design Rule Script
# #########################################################################################	

# #########################################################################################	
# --This script sets the design rule constraints 
# --Note: This script assumes the target library name (without extension) was placed in a variable called tech_lib in the library setting script
# #########################################################################################	


# A list of the input ports of the design, only the ports specified here will be connected to the driving cell and constrained for max_capacitance
set input_ports { rstb }

# A list of the output ports of the design, only the ports specified here will be considered connected to the load 
set output_ports { en }

# Value of maximum input capacitive loading on your input ports, in terms of specific library gate load
set max_input_cap_load [expr [load_of $lib_name/INVCKDGD/I] * 10]

# Value of maximum output capacitive loading on your output ports, in terms of specific library gate load
set max_output_load [expr [load_of $lib_name/INVCKDGD/I] * 30]
 		
# Maximum capacitive load placed on some specified input ports/designs
set fanout_value 0.75

# List of ports or designs that we set the max capacitive load on them
set list_of_input_ports_or_designs { rstb en }

# Maximum transition delay value
set transition_value 5

# Setting the maximum input capacitance (load)
set_max_capacitance $max_input_cap_load [get_ports $input_ports]

#Setting output load (max allowable value)#
set_load $max_output_load [get_ports $output_ports]

# Set expected fanout load for output port, it sets the max_fanout attribute on the specified input ports and/or designs. Compile attempts to ensure that the sum 
# of the fanout_load attributes for input pins on nets driven by the specified ports (or all nets in the specified design) is less than the given value.
set_max_fanout $fanout_value [get_ports $list_of_input_ports_or_designs]

# --Sets the maximum transition time to nets attached to specified ports (or to all nets in the design)
# --The second argument is a list of clock groups, ports or designs to which we set the max_transition time
set_max_transition $transition_value { clk } 
