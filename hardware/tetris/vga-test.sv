`timescale 1ns / 1ns // `timescale time_unit/time_precision

module VGA(
  input logic clk,
  output logic vga_HS,
  output logic vga_VS,
  output logic vga_BLANK_N,
  output logic vga_SYNC_N,
  output logic [7:0] R,
  output logic [7:0] G,
  output logic [7:0] B,
  output logic vga_CLOCK
);
// i think this FPGA is 50MHz clock, so do a clock divider first
// logic clk_25 = 0;
// always_ff @(posedge clk) begin
//   clk_25 <= ~clk_25;
// end


// first set up the HSYNC/VSYNC logic

logic [9:0] CounterX = 0;  // for HSYNC
logic [9:0] CounterY = 0;  // for VSYNC
wire CounterXmaxed = (CounterX==799);  // counts 800 values (0-->799)
wire CounterYmaxed = (CounterY==524);  // counts 525 values (0-->524)

always_ff @(posedge clk) begin
if(CounterXmaxed)  // will loop over each pixel (left to right) in a line, reset if it has maxed
  CounterX <= 0;
else
  CounterX <= CounterX + 1;
end

always_ff @(posedge clk) begin   // test to see if reached end of line, increment to next line
if(CounterXmaxed)
  if(CounterYmaxed)
    CounterY <= 0;
  else
    CounterY <= CounterY + 1;
end

// now set up the signals, they need to turn off for a certain time
assign vga_HS = ~((CounterX >= 664) && (CounterX < 769));  // previous 656 and 752, 664 and 769, 659 and 754 (inclusive)
assign vga_VS = ~((CounterY >= 491) && (CounterY < 493));  // previous 490 and 492, 491 and 493, 492 and 494 (inclusive)
assign vga_BLANK_N = (CounterX < 640) && (CounterY < 480);  // 1 if video on, 0 if not. below is different values, unsure what to use
// assign vga_BLANK_N = ((CounterX >= 20) && (CounterX < 624) && (CounterY >= 8) && (CounterY < 420)) ? 1'b1 : 1'b0;
// might also need to do inclusive of 640 and 480
assign vga_SYNC_N = 1'b1;
assign vga_CLOCK = clk;  // not sure rn


// assign colours and play around

assign R = vga_BLANK_N ? 8'h00 : 8'h00;
assign G = vga_BLANK_N ? 8'h00 : 8'h00;
assign B = vga_BLANK_N ? 8'hFF : 8'h00;

endmodule