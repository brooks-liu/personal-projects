module UpdateBoard(
    input logic clk,
    input logic ticker,
    input logic[199:0] board,
    input logic[199:0] next_board,
    output logic[199:0] updated_board,
    input logic rotate,  // press to rotate piece
    input logic rotate_direction,  // 1 for cw, 0 for ccw
    input logic left, // move piece left
    input logic right // move piece right
);
    // want to store all the changes we want to make in next_board, then update board at every tick



endmodule