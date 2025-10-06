# comments are for if i use this as a template for other .do files
vlib work

# files to compile
vlog RateDivider.sv

# module to sim
vsim RateDivider

log {/*}
add wave {/*}

# initialize signals
force {ClockIn} 0
force {resetn} 1

# force clock
force {ClockIn} 0 0, 1 5 -repeat 10ns

# test reset during the Enable pulse to see behaviour
run 46ns
force {resetn} 0
run 3ns
force {resetn} 1

run 80ns

# zoom out to full waveform
wave zoom full
