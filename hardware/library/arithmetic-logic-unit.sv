module ArithmeticLogicUnit(input logic [3:0] A, B, input logic [1:0] Function, output logic [7:0] ALUout);
    logic [7:0] sum;
    RippleCarryAdder u1(A, B, 1'b0, sum[3:0], sum[7:4]);  // from "ripple-carry-adder.sv"

    always_comb
    begin
        case ( Function )
            0: ALUout = sum;
            1: if(|{A, B}) ALUout = 8'b00000001; else ALUout = 8'b00000000;
            2: if(&{A, B}) ALUout = 8'b00000001; else ALUout = 8'b00000000;
            3: ALUout = {A, B};
            default: ALUout = 8'b00000000;
        endcase
    end
endmodule