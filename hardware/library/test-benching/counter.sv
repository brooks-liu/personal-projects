`timescale 1ns/1ns
module counter(
  input logic clk,
  input logic reset,
  output logic [3:0] counter
);
  always_ff @(posedge clk) begin
    if(reset) begin
      counter <= 0;
    end else if (counter == 14) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule

/*
- run for >1 cycle of the counter
- test if reset during time with NO pos clock edge then shouldnt reset
- test reset during pos clock edge --> make counter 0
*/