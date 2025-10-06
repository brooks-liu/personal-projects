`timescale 1ns/1ns
/*
depending on the size of the pixel im using, the pixel width/height will change
current value for display is 120x160 pixels, so for a 20x10 board, each cell is 6x6 pixels
the pixel outputs will be 

IMPORTANT: CHANGE THE INSTANTIATED MODULE WHEN YOU TEST/ACTUALLY RUN IT
*/

module tetris_top(
    input logic CLOCK_50,
    input logic [9:0] SW,
    input logic [3:0] KEY,

    output logic [7:0] VGA_R,
    output logic [7:0] VGA_G,
    output logic [7:0] VGA_B,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic VGA_BLANK_N,
    output logic VGA_SYNC_N,
	output VGA_CLK
);
    localparam CELL_WIDTH = 6;
    localparam CELL_HEIGHT = 6;
    localparam TILE_COLOUR = 3'b001;  // blue

    logic resetn;  // active low reset
    logic run;
    logic rotate_direction;
    logic rotate_btn;
    logic move_left_btn;
    logic move_right_btn;
    assign resetn = KEY[0];        // active-low by board (KEY[0] = 1 when not pressed)
    assign run = SW[0];
    assign rotate_direction = SW[9];
    assign rotate = ~KEY[3];  // keys are active highs
    assign right = ~KEY[1];
    assign left = ~KEY[2];


    // instantiate tetris game (tetris.sv outputs a board)
    logic [199:0] board;
    tetris_test game (
        .clk(CLOCK_50),
        .resetn(resetn),
        .run(run),
        .rotate(rotate),
        .rotate_direction(rotate_direction),
        .left(left),
        .right(right),
        .board(board)
    );

    // pixel update logic
    logic [7:0] px;
    logic [6:0] py;
    always_ff @(posedge CLOCK_50, negedge resetn) begin
        if (!resetn) begin
            px <= 8'd0;
            py <= 7'd0;
        end else begin
            if (px == 8'd59) begin  // resets back to 59 (dont need to update rest of screen)
                px <= 8'd0;
                if (py == 7'd119) begin
                    py <= 7'd0;
                end else begin
                    py <= py + 1;
                end
            end else begin
                px <= px + 1;
            end
        end
    end

    logic [3:0] cell_x;  
    logic [4:0] cell_y;
    logic in_playfield;
    logic [7:0] cell_index;
    logic cell_occupied;
    logic plot_pixel;
    logic cell_colour;

    always_comb begin
        cell_x = px / CELL_WIDTH;  // verilog truncates it
        cell_y = py / CELL_HEIGHT;
        in_playfield = (cell_x < 10) && (cell_y < 20);
        cell_index = cell_y * 10 + cell_x;
        cell_occupied = board[cell_index];
        if (in_playfield) begin
            cell_index = cell_y * 10 + cell_x;
            cell_occupied = board[cell_index];
            plot_pixel = cell_occupied;
            cell_colour = cell_occupied ? TILE_COLOUR : 3'b000;  // otherwise black
        end else begin
            plot_pixel = 0;
            cell_colour = 3'b000;
        end
    end




    vga_adapter VGA(
        .resetn(resetn),
        .clock(CLOCK_50),
        .colour(cell_colour),
        .x(px),
        .y(py),
        .plot(plot_pixel),

        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );



    

endmodule