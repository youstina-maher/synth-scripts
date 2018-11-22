# #########################################################################################
# Design Compiler: Library Settings Script 
# #########################################################################################

#-- This Script define all libraries 


# Use $lib_path afterwards as a variable instead of writing the path every time you need it.
set lib_path "/home/eslam/Graduation_Project/synth_scripts/mod_2_copy/run2/UMC130" 
set lib_name "fsc0g_d_generic_core_ss1p08v125c"

# Change the Lib_Name with the name of your library 
set target_library $lib_path/$lib_name.db 

# Change the Lib_Name with the name of your library 
set link_library [list * $lib_path/$lib_name.db]

# Change the Lib_Name with the name of your library  
set symbol_library $lib_path/$lib_name.db

# The search_path variable specifies a list of directory paths that the tool uses to find logic libraries and other files when you specify a plain file name without a path. It also sets the paths where Design Compiler can continue the search for unresolved references after it searches the link libraries.
#set search_path "the search path" 


# Mapping the work library into a specific directory 
#define_design_lib $lib_name –path $work_path/bin



# Youstina: 
# I edited line 16 to make the values of the variables get substituted in the list, otherwise it won't
