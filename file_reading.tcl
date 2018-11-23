# ########################################################################
# This is an extra script that was just used for first-time testing
# ########################################################################
analyze -f verilog $DESIGN.v
elaborate $DESIGN
current_design $DESIGN
link

