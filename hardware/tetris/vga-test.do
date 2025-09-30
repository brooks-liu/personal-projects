# comments are for if i use this as a template for other .do files
vlib work

# files to compile
vlog vga-test.sv

# module to sim
vsim VGA

log -r {/*}
add wave {/*}

# force clock
force -freeze {clk} 0 0ns
force -deposit clk 0 0ns, 1 10ns -repeat 20ns  # 50MHz = 20ns


run 5ms

# zoom out to full waveform
wave zoom full
