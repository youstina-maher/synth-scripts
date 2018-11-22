#This script is for reading the rtl design filesby the Design Compiler
#It assumes that a list of verilog files and their directories is written in a .txt file
#The format of written file is like the following:
#/home/.../rtl/filenae.v

set rtl_directory './rtl'
set syn_directory './syn'
set fp [open "$rtl_directory/rtl_files.txt" r]
set outfile [open "$syn_directory/reading_files.tcl" w]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]
foreach line $data {
    
     puts $outfile "read_verilog $line"
}
close $outfile