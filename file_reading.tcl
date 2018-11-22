analyze -f verilog $DESIGN.v
elaborate $DESIGN
current_design $DESIGN
link

