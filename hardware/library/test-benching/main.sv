`timescale 1ns/1ns
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
  for(int i = 0; i < 50; i++) begin
    #5 clk = ~clk;
  end
  /*forever begin  // uncomment this for infinite clock cycles (ModelSim probably)
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
  // originally was #5 and #5 before the reset in line 47 but i couldnt figure out why it wasnt working,
  // turns out it was just because i didnt have enough clock edges in more for loop, and increasing to 50 fixed it


  // test3: reset during positive edge
  reset = 1;  // turns to 1 5ns before next edge
  #10 reset = 0;  // stays on
  $display("Test3 done. Counter = %d", counter); // should be 0

  /*at the end, the values that were printed should be 
  - the full cycle from 0 to 14, then 0 and 1 as well
  - Test1 completion line is printed
  - counter = 2 and 3
  - Test2 completion
  - counter = 0
  - Test3 complete
  - if running the for loop, might print a few more values that are counting up
  - if using forever loop, will keep printing values, but I just ran it for a certain time frame on ModelSim (run 300ns)
  */
end
endmodule
