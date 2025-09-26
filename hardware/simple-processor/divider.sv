`timescale 1ns /1 ns
/************************** Control path **************************************************/
module control_path(
    input logic clk,
    input logic reset, 
    input logic Go,
    output logic [1:0] Sel,
    output logic ResultValid,
    output logic Din
); 


// control FSM states
typedef enum logic[2:0]
{
    S0 = 'd0,
    C1 = 'd1,
    C2 = 'd2,
    C3 = 'd3,
    C4 = 'd4,
    R0 = 'd5,
    D0 = 'd6
} statetype;

statetype CS, NS;

// control FSM state table
always_comb begin
    case(CS)
	    S0 : NS = C1;      
        C1 : NS = C2;
        C2 : NS = C3;
        C3 : NS = C4;
        C4 : NS = D0;
        R0 : NS = Go? S0:R0;
        D0 : NS = Go? S0:D0;
    endcase
end

// output logic i.e: datapath control signals
always_comb begin
    // by default, make all our signals 0
    Sel = 2'b10;
    Din = 1'b0;
    ResultValid = 1'b0;
    // Default case covered by R0 as well
    if (CS == S0) begin
        Sel = 2'b00;
        Din = 1'b1;
    end
    else if ((CS == C1) | 
        (CS == C2) | 
        (CS == C3) |
        (CS == C4))
        Sel = 2'b01;
    if (CS == D0)
        ResultValid = 1'b1;
end

// control FSM FlipFlop
always_ff @(posedge clk) begin
    if(reset)
        CS <= R0;
    else
       CS <= NS;
end

endmodule


/************************** Datapath **************************************************/
module datapath(
    input logic clk, 
    input logic reset,
    input logic Go,
    input logic Din,
    input logic [1:0] Sel, // For selecting what to input into registers
    input logic [3:0] Dividend, Divisor,
    output logic [3:0] Quotient, Remainder,
    output logic [4:0] Areg
);

logic[3:0] QMuxOut; // This feeds into a register that outputs the Quotient.
logic[4:0] AMuxOut; // Feeds into Areg.
logic[4:0] loaded_Divisor; // Loads the Divisor

logic[4:0] shifted_Areg;
logic[4:0] Areg_calc_out;
logic[3:0] Q_calc_out;

always_comb begin
    shifted_Areg[4:1] = Areg[3:0];
    shifted_Areg[0] = Quotient[3];
    Q_calc_out[3:1] = Quotient[2:0];
    // shifted_Areg - loaded_Divisor is -ve.
    if (|{(shifted_Areg - loaded_Divisor)&(5'b10000)}) begin
        Q_calc_out[0] = 1'b0;
        Areg_calc_out = shifted_Areg;
    end
    else begin
        Q_calc_out[0] = 1'b1;
        Areg_calc_out = shifted_Areg - loaded_Divisor; 
    end

//MuxOuts
    case(Sel)
        2'b00: begin // Reset
            AMuxOut = 5'b00000; QMuxOut = Dividend; 
        end
        2'b01: begin //Next calculation
            AMuxOut = Areg_calc_out; QMuxOut = Q_calc_out;
        end
        2'b10: begin // Steady
            AMuxOut = Areg; QMuxOut = Quotient;
        end
        default: AMuxOut = 5'b0;
    endcase
end

// FlipFlops
always_ff @(posedge clk) begin
    if(reset) begin
        loaded_Divisor <= 4'd0;
        Quotient <= 4'b0;
        Areg <= 4'b0;
    end
    else begin
        if (Din)
            loaded_Divisor[3:0] <= Divisor;
            loaded_Divisor[4] <= 0;
        Areg <= AMuxOut;
        Quotient <= QMuxOut;
    end
end

// Assignments.
assign Remainder = Areg[3:0];

endmodule



/************************** processor  **************************************************/
module divider(
    input logic Clock,
    input logic Reset, 
    input logic Go,
    input logic [3:0] Divisor, Dividend,
    output logic [3:0] Quotient, Remainder,
    output logic ResultValid
);


// intermediate logic
logic [4:0] Areg;
logic din;
logic [1:0] Sel;

control_path control(
   .clk(Clock),
   .reset(Reset), 
   .Go(Go),
   .Sel(Sel),
   .Din(din),
   .ResultValid(ResultValid)
);

datapath data(
    .clk(Clock), 
    .reset(Reset),
    .Go(Go),
    .Din(din),
    .Sel(Sel),
    .Dividend(Dividend),
    .Divisor(Divisor),
    .Remainder(Remainder),
    .Quotient(Quotient),
    .Areg(Areg)
);

endmodule
