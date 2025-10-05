/*
depending on the size of the pixel im using, the pixel width/height will change
current value for display is 120x160 pixels, so for a 20x10 board, each cell is 6x6 pixels
*/

module VGA(
    input logic CLOCK_50,
    input logic SW,
    input logic KEY,
    output logic HEX3, HEX2, HEX1, HEX0,
    output logic [7:0] LED_R, LED_G, LED_B,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic VGA_BLANK_N,
    output logic VGA_SYNC_N,
    output logic VGA_CLK,   
);
    localparam CELL_WIDTH = 6;
    localparam CELL_HEIGHT = 6;

    cell_x
    cell_y 

endmodule