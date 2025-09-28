module register(input logic clk ,input logic reset_b , input logic[7:0] d , output logic[7:0] q) ;
    always_ff @ (posedge clk)
    begin
        if (reset_b) q <= 8'b00000000;
        else q <= d;
    end
endmodule

module sequential_ALU(input logic Clock, Reset_b, input logic [3:0] Data, input logic [2:0] Function, output logic [7:0] ALU_reg_out);
    integer decimalA;
    decimalA = A;
    logic[3:0] zeros;
    zeros[0] = 0; zeros[1] = 0; zeros[2] = 0; zeros[3] = 0;

    always_comb
    begin
        case(Function)
            0: ALUout = Data + ALU_reg_out[3:0];  // A + B
            1: ALUout = Data * ALU_reg_out[3:0];  // A * B
            2: ALUout = {zeros, ALU_reg_out[3:0]} << decimalA;
            3: ALUout = ALUout;
            default: ALUout = ALUout;
        endcase
    end
    register u1(Clock, Reset_b, ALUout, ALU_reg_out)
endmodule