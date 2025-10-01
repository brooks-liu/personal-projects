`timescale 1ns / 1ns // `timescale time_unit/time_precision

module VGA(
  input logic clk,
  output logic vga_HS,
  output logic vga_VS,
  output logic [7:0] R,
  output logic [7:0] G,
  output logic [7:0] B
);
// i think this FPGA is 50MHz clock, so do a clock divider first
logic clk_25 = 0;
always_ff @(posedge clk) begin
  clk_25 <= ~clk_25;
end


// first set up the HSYNC/VSYNC logic

logic [9:0] CounterX;  // for HSYNC
logic [9:0] CounterY;  // for VSYNC
wire CounterXmaxed = (CounterX==799);  // counts 800 values (0-->767)
wire CounterYmaxed = (CounterY==524);  // counts 525 values (0-->511)

always_ff @(posedge clk_25) begin
if(CounterXmaxed)  // will loop over each pixel (left to right) in a line, reset if it has maxed
  CounterX <= 0;
else
  CounterX <= CounterX + 1;
end

always_ff @(posedge clk_25) begin   // test to see if reached end of line, increment to next line
if(CounterXmaxed)
  if(CounterYmaxed)
    CounterY <= 0;
  else
    CounterY <= CounterY + 1;
end

// now set up the signals, they need to turn off for a certain time
assign vga_HS = ~((CounterX >= 656) && (CounterX < 752));  // maybe change to 640? 
assign vga_VS = ~((CounterY >= 490) && (CounterY < 492));  // maybe change to 480 + 482?

// assign colours and play around
wire video_on = (CounterX < 640) && (CounterY < 480);

assign R = video_on ? 8'h00 : 8'h00;
assign G = video_on ? 8'h00 : 8'h00;
assign B = video_on ? 8'hFF : 8'h00;

endmodule