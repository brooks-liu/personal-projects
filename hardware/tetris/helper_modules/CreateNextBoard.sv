module CreateNextBoard(
    input logic clk,
    input logic ticker,
    input logic[199:0] board,
    input logic rotate,  // press to rotate piece
    input logic rotate_direction,  // 1 for cw, 0 for ccw
    input logic left, // move piece left
    input logic right, // move piece right

    output logic[199:0] next_board  // the next state of the board after applying movement/rotation
);
    // want to store all the changes we want to make in next_board, then update board at every tick
    always_comb begin
        next_board = board;  // by default, no changes
        if (rotate & rotate_direction) begin
            // apply rotation logic to next_board
        end 
        if (rotate & !rotate_direction) begin
            // apply rotation logic to next_board
        end
        if (left) begin
            // apply left movement logic to next_board
        end
        if (right) begin
            // apply right movement logic to next_board
        end
        if (ticker) begin
            // apply downward movement logic to next_board
        end
    end



endmodule