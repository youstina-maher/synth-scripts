# #########################################################################################
# Design Compiler : Timing and Area Constraint Script
# #########################################################################################	


# #########################################################################################	
# This script sets the timing and area constraints for synthesis ####
# #########################################################################################	


# #########################################################################################	
# Variables controlling the clock section
# #########################################################################################	


# Change this variable to change the clock period
set clk_period 100 
# Change this variable according to the name of the port/pin of the clock in your design
set clk_source clk
# Change this variable according to what you want to name the clock object 
set clk_name clk 
# Change this list to change the waveform (duty cycle) of clk
set clk_waveform { 0 50 } 
# Set this variable with the estimated value of clock skew, used for pre-layout
set max_clock_uncertainty 0.5 
# This is the max latency propagated from the source of clock to the clock definition point (e.g: port) in the design
set max_clock_source_latency 4 
# Set to zero pre-layout, post-layout will be set to 1 to propagate actual clock latency throughout (TODO: confirm again this is true)
set propagate_latency 0 
# Max clock latency, TODO: this vs source latency??
set max_clock_latency 2 
# A list containing all the clock objects in the current design (re-used in compile_check_write_design.tcl)
set all_clock_objects { clk } 



# #########################################################################################
# Variables controlling the input/output delay section#
# #########################################################################################

# Change this variable to change max input delay
set max_input_delay 20 
# Change this variable to change max output delay
set max_output_delay 20 
# Change this variable according to the input ports in your design, the input delay setting will be done only to ports specified here
set input_ports { rstb en }
# Change this variable according to the output ports in your design, the output delay setting will be done only to ports specified here 
set output_ports { count_1 } 


# #########################################################################################	
# Variables controlling the area optimization section#
# #########################################################################################	

# If optimize_area is set to 1 the optimization priority will be given to minimizing area, otherwise, the priority will be given to delay, and area constraint 
# will be specified by area_con
set optimize_area_first 0 
set area_con 500


# #########################################################################################	
# Variables controlling the false paths section#
# #########################################################################################	

# List of input ports from which the false path(s) starts
set from_list { rstb } 

# List of output ports/pins where the false path(s) ends
set to_list { count_1 } 

# List of intermediate (port, pin, or leaf cell names) points through which the false path(s) pass 
#set through_list { C } 


# #########################################################################################	
# Variables controlling the multicycle path section#
# #########################################################################################	
# List of input ports/pins to the multi-cycle path
set multi_from_list { en }

# List of output ports/pins to the multi-cycle path
set multi_to_list { count_1 }

# List of intermediate (port, pin, or leaf cell names) points through which the multi-cycle path(s) pass 
#set multi_through_list { }

# This is the number of cycles for the defined path 
set path_multiplier 2 


# #########################################################################################	
# Variables controlling the combinational path delay section#
# #########################################################################################	

# The maximum path delay value
set max_path_delay 15

# List of input ports/pins to the combinational path
set comb_max_from_list { rstb }

# List of output ports/pins to the combinational path
set comb_max_to_list { count_1 }

# List of intermediate (port, pin, or leaf cell names) points through which the combinational path(s) pass 
#set comb_max_through_list { }

#The minimum path delay value
set min_path_delay 10

# List of input ports/pins to the combinational path
set comb_min_from_list { en }

# List of output ports/pins to the combinational path
set comb_min_to_list { count_1 }

# List of intermediate (port, pin, or leaf cell names) points through which the combinational path(s) pass 
#set comb_min_through_list { }


# #########################################################################################	
# Variables controlling the power constraint section
# #########################################################################################	

# To target optimum dynamic power constraint, set this to zero, otherwise set it to the max dynamic power value, additionally set the dyn_power unit below
set dyn_power 0 
# Set to the max leakage power value, additionally, set the unit of leakage_power below
set leakage_power 100
# --SAIF file contains the switching activity information, time duration values and time unit used in simulation, # read_saif converts this to synthesis time 
#   units (from target/ link library and annotates switching activity information on nets, pins, ports, and cells in the current design 
# --The following sets the saif file name to be read 
set saif_file_name rtl.back.saif
# This variable is the hierarchical reference to the instance of the design in the testbench
#set instance_in_tb tb_rtl/i
# This variable is the minimum bitwidth of register that can be clock gated
set min_bitwidth 3
# This variable is the maximum fanout of a single clock-gating cell.
set max_clk_gating_cell_fanout 3


# #########################################################################################	
# Clock object creation 
# #########################################################################################	

create_clock -name $clk_name -period  $clk_period -waveform $clk_waveform [get_ports $clk_source]
set_clock_uncertainty $max_clock_uncertainty [get_clocks $all_clock_objects]
set_clock_latency -source $max_clock_source_latency [get_clocks $all_clock_objects]
#set_clock_latency $max_clock_latency [get_clocks $all_clock_objects] 

if {$propagate_latency==1} {
   set_propagated_clock [get_clocks $all_clock_objects]
}
set_dont_touch_network [get_clocks $clk_name ]


# #########################################################################################	
# Input delay 
# #########################################################################################	
set_input_delay -clock $clk_name -max $max_input_delay [get_ports $input_ports] 

# #########################################################################################	
# Output delay
set_output_delay -clock $clk_name -max $max_output_delay [get_ports $output_ports] 


# #########################################################################################	
# False paths
# #########################################################################################	

#change -rise|fall -setup|hold the type of from/through/to lists may not be port, so change accordingly as well, you may also add a -through option
set_false_path -rise -setup -from [get_ports $from_list] -to [get_ports $to_list] 


# #########################################################################################	
# Multicycle paths
# #########################################################################################	

set_multicycle_path $path_multiplier -from [get_ports $multi_from_list] -to [get_ports $multi_to_list]

# #########################################################################################	
# Combinational delay
# #########################################################################################	
 
set_max_delay $max_path_delay -from [get_ports $comb_max_from_list] -to [get_ports $comb_max_to_list]
set_min_delay $min_path_delay -from [get_ports $comb_min_from_list] -to [get_ports $comb_min_to_list]
 
# #########################################################################################	
# Area 
# #########################################################################################	
if {$optimize_area_first==1} {
   set_max_area 0
} else {
   set_max_area $area_con
}


# #########################################################################################	
# Power 
# #########################################################################################	

#read_saif -input $saif_file_name -instance $instance_in_tb
# The second parameter sets the dynamic power unit, may be one of the following: GW, MW, KW, W, mW, uW, nW, pW, fW, aW
set_max_dynamic_power $dyn_power GW 
set_max_leakage_power $leakage_power GW 

# --The following sets some parameters to be used when compiling using the clock gating option
# --The option minimum_bitwidth sets the minimum size of a  register  bank  for  which  the clock can be gated, default is 3 bits-wide.
# --The option max_fanout sets the maximum fanout of a single clock-gating cell.
set_clock_gating_style -minimum_bitwidth $min_bitwidth -max_fanout $max_clk_gating_cell_fanout



# #########################################################################################	
# Recovery and removal time (for reset)
# #########################################################################################	

# Recovery time is the min time required between releasing a reset signal (most commonly, but applies generally to asynchronous signals) and the next active clock # edge [almost like setup time], the removal time is the min. time required to keep the reset signal asserted after the active clock edge [almost like hold time] 
# --This command enables reset (or any other asynch. signal) recovery and removal checks
set enable_recovery_removal_arcs true





