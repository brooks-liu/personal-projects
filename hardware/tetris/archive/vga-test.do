# comments are for if i use this as a template for other .do files
vlib work

# files to compile
vlog vga-test.sv

# module to sim
vsim VGA

log {/*}
add wave {/*}

# force clock
force {clk} 0 0, 1 5 - repeat 10ns


run 100ns

# zoom out to full waveform
wave zoom full
