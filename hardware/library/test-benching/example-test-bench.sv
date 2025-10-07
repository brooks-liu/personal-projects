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

module main;
logic clk;
logic reset;
logic [3:0] counter;

counter c1(
.clk(clk),
.reset(reset),
.counter(counter)
);

// first initial for clock + initial values (one cycle every 10ns)
initial begin
  clk = 0;
  for(int i = 0; i < 40; i++) begin
    #5 clk = ~clk;
  end
  /*forever begin
    #5 clk = ~clk;
  end*/
end

// second initial block to test (stimulus)
initial begin
  reset = 1;
  #10 reset = 0;

  $monitor("Counter value: %d", counter);
  // test1: let counter run
  #5 // time to first positive edge
  #155  // after 16 positive edges, counter should be 1
  $display("Test1 done. Counter = %d", counter);
  #5 // for test 2, start at positive clock edge

  // test2: reset not during positive edge
  #3 reset = 1;  // get past clock edge
  #5 reset = 0;  // 3 + 5 < 10 so no clock edge yet
  #7 // continue past clock edge
  $display("Test2 done. Counter = %d", counter);  // counter should be 3
  // for test 3, dont start at positive clock edge


  // test3: reset during positive edge
  reset = 1;  // turns to 1 5ns before next edge
  #10 reset = 0;  // stays on
  $display("Test3 done. Counter = %d", counter); // should be 0

  /*at the end, the values that were printed should be 
  - the full cycle from 0 to 14, then 0 and 1 as well
  - Test1 completion line is printed
  - counter = 2 and 3
  - Test2 completion
  - counter = 4 then 5
  - Test3 complete
  - added a finish to stop the forever loop
  - if running the for loop, should stop exactly after Test3 prints
  */
end
endmodule
