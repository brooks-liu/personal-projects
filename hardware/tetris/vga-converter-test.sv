`timescale 1ns / 1ns

/*
If all goes well, the screen should display 17 1s
*/

module tetris_test(
    input logic clk,
    input logic resetn,
    input logic run,  // 1 to run game, 0 to pause
    input logic rotate,  // press to rotate piece
    input logic rotate_direction,  // 1 for cw, 0 for ccw
    input logic left, // move piece left
    input logic right, // move piece right

    output logic [199:0] board  // the current state of the board (10x20 grid, so 200 bits)
);
    assign board = 131071;


endmodule