`timescale 1ns / 1ns
// `timescale time_unit/time_precision


module tetris(
    input logic clk,
    input logic resetn,
    input logic cw,
    input logic ccw,

    output logic vga_HS,  // these should come from the virtual board representation i think?
    output logic vga_VS,
    output logic [7:0] R,
    output logic [7:0] G,
    output logic [7:0] B
);
    always_ff @(posedge clk, negedge resetn) begin  // go with async reset for now
        if (!reset) begin
            // reset logic here
            board <= 0;
        end 
        else begin
            // main logic here
            // do i need to put anything here? everything just continues as normal if not reset
        end
    end

    logic ticker = 0;  // used as the game clock/ticker, for movement within the game
    always_ff @(posedge clk) begin
        ticker <= ~ticker;  // divide clock by 2 for now, will change later
    end

    // board representation - since what the state stored use registers
    // since board is 10x20 grid, can use 200 bits to represent it
    logic [199:0] board;  // change later if needed, will be left to right, top to bottom (like how the vga would read it)
    logic [199:0] next_board;  // to store the next state of the board
    
    always_ff @


    // piece representation



    // piece rotation
    always_comb begin
        case(cw)
            0: // do nothing
            1: // cw rotation logic here
            default: // do nothing
        endcase
    end
    always_comb begin
        case(ccw)
            0: // do nothing
            1: // ccw rotation logic here
            default: // do nothing
        endcase
    end



endmodule