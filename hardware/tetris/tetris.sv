`timescale 1ns / 1ns
// `timescale time_unit/time_precision
/* file to compile together:
    - tetris.sv
    - RateDivider.sv
    - UpdateBoard.sv

*/
/*
Signals needed:
    - Game ticker
    - Maybe an update speed? b/c don't want the piece going down every tick
    - Allow spawn (good for when clearing rows first or game over/restart/any text displays in the future)
    - Reset using key[0]
    - Run signal to pause/unpause game? Maybe SW[0] to pause/unpause
    - CW/CCW rotation inputs, press key[3] to rotate, if SW[9] is 1, cw, if 0 then ccw
    - Left/right movement inputs, press key[1] to move left, key[2] to move right
*/


module tetris(
    input logic clk,
    input logic resetn,
    input logic rotate,  // press to rotate piece
    input logic rotate_direction,  // 1 for cw, 0 for ccw
    input logic run,  // 1 to run game, 0 to pause
    input logic left, // move piece left
    input logic right, // move piece right

    output logic vga_HS,  // these should come from the virtual board representation i think?
    output logic vga_VS,
    output logic [7:0] R,
    output logic [7:0] G,
    output logic [7:0] B
);
    localparam GAME_SPEED = 60;  // amount of ticks before piece moves down, in the future if want speed increase then can change this value
    // GAME_SPEED might only be used for moving the piece down
    logic allow_spawn = 0;  // signal to allow spawning of new piece, used when clearing rows or game over/restart

    always_ff @(posedge clk, negedge resetn) begin  // reset block go with async reset for  now
        if (!resetn) begin  // reset logic here
            board <= 0;
            next_board <= 0;
            if(run) begin
                allow_spawn <= 1;
            end else begin
                allow_spawn <= 0;
            end
        end
        else begin
            // main logic here
            // do i need to put anything here? everything just continues as normal if not reset
        end
    end

    logic ticker;  // used as the game clock/ticker, for movement within the game, is a square wave
    RateDivider #(50000000, 1) create_ticker(  // i think the clock is 50MHz, so divide by 25mil to get 2Hz
        .ClockIn(clk),
        .Reset(resetn),
        .Enable(ticker)
    );

    // board representation - since what the state stored use registers
    // since board is 10x20 grid, can use 200 bits to represent it
    logic [199:0] board;  // change later if needed, will be left to right, top to bottom
    logic [199:0] next_board;  // to store the next state of the board
    

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