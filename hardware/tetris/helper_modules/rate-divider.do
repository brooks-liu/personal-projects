# comments are for if i use this as a template for other .do files
vlib work

# files to compile
vlog vga-rate-divider.sv

# module to sim
vsim RateDivider #(.CLOCK_FREQUENCY(4), .OUTPUT_FREQUENCY(1))

log {/*}  # can do -r {/*}
add wave {/*}

# initialize signals
force {ClockIn} 0
force {resetn} 0

# force clock
force {clk} 0 0, 1 5ns - repeat 10ns

# test reset
run 20ns
force {resetn} 1

run 20ns
force {resetn} 0
run 20ns
force {resetn} 1

run 20ns

# zoom out to full waveform
wave zoom full
