`timescale 1ns / 1ns // `timescale time_unit/time_precision

module VGA(
    input logic clk,
    output logic vga_HS,
    output logic vga_VS,
    output logic R,
    output logic G,
    output logic B
);

    // first set up the HSYNC/VSYNC logic
    
    logic [9:0] CounterX;  // for HSYNC
    logic [8:0] CounterY;  // for VSYNC
    wire CounterXmaxed = (CounterX==767);  // counts 768 values (0-->767)
    wire CounterYmaxed = (CounterY==511);  // counts 512 values (0-->511)
    
    always @(posedge clk) begin
    if(CounterXmaxed)  // will loop over each pixel (left to right) in a line, reset if it has maxed
        CounterX <= 0;
    else
        CounterX <= CounterX + 1;
    end
    
    always @(posedge clk) begin  // test to see if reached end of line, increment to next line
    if(CounterXmaxed)
        if(CounterYmaxed)
            CounterY <= 0;
        else
            CounterY <= CounterY + 1;
    end
    
    // now set up the signals
    assign vga_HS = ~((CounterX >= 656) && (CounterX < 752));
    assign vga_VS = ~((CounterY >= 490) && (CounterY < 492));
    
    // apparently vga sync pulses must be negative
    assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;
    
    
    // assign colours and play around
    wire video_on = (CounterX < 640) && (CounterY < 480);
    
    assign R = video_on ? CounterY[3] | (CounterX==256) : 1'b0;
    assign G = video_on ? (CounterX[5] ^ CounterX[6]) | (CounterX==256) : 1'b0;
    assign B = video_on ? CounterX[4] | (CounterX==256) : 1'b0;

endmodule