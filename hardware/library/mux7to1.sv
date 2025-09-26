`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux7to1 ( input logic [2:0] MuxSelect , input logic [6:0]
    MuxIn , output logic Out );
    always_comb // declare always_comb block
    begin
        case ( MuxSelect ) // start case statement
        3'b000 : Out = MuxIn [0]; // case 0
        3'b001 : Out = MuxIn [1]; // case 1
        3'b010 : Out = MuxIn [2]; // case 2
        3'b011 : Out = MuxIn [3]; // case 3
        3'b100 : Out = MuxIn [4]; // case 4
        3'b101 : Out = MuxIn [5]; // case 5
        3'b110 : Out = MuxIn [6]; // case 6
        default: Out = 0; // default case set arbitrarily, should not occur b/c only 7 input mux, if it does set to 0
    endcase
    end
endmodule