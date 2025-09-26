`timescale 1ns /1 ns
/************************** Control path **************************************************/
module control_path(
    input logic clk,
    input logic reset, 
    input logic run, 
    input logic [15:0] INSTRin,
    output logic R0in, R1in, Ain, Rin, IRin, 
    output logic [1:0] select, ALUOP,
    output logic done
); 

/* OPCODE format: II M X DDDDDDDDDDDD, where 
    *     II = instruction, M = Immediate, X = rX; X = (rX==0) ? r0:r1
    *     If M = 0, DDDDDDDDDDDD = 00000000000Y = rY; Y = (rY==0) r0:r1
    *     If M = 1, DDDDDDDDDDDD = #D is the immediate operand 
    *
    *  II M  Instruction   Description
    *  -- -  -----------   -----------
    *  00 0: mv    rX,rY    rX <- rY
    *  00 1: mv    rX,#D    rX <- D (sign extended)
    *  01 0: add   rX,rY    rX <- rX + rY
    *  01 1: add   rX,#D    rX <- rX + D
    *  10 0: sub   rX,rY    rX <- rX - rY
    *  10 1: sub   rX,#D    rX <- rX - D
    *  11 0: mult  rX,rY    rX <- rX * rY
    *  11 1: mult  rX,#D    rX <- rX * D 
*/

parameter mv = 2'b00, add = 2'b01, sub = 2'b10, mult = 2'b11;

logic [1:0] II;
logic M, rX, rY;

assign II = INSTRin[15:14];
assign M =  INSTRin[13];
assign rX = INSTRin[12];
assign rY = INSTRin[0];

// control FSM states
typedef enum logic[1:0]
{
    C0 = 'd0,
    C1 = 'd1, 
    C2 = 'd2, 
    C3 = 'd3
} statetype;

statetype current_state, next_state;


// control FSM state table
always_comb begin
    case(current_state)
	    C0: next_state = run? C1:C0;
        C1: next_state = done? C0:C2;
        C2: next_state = C3;
        C3: next_state = C0;
    endcase
end

// output logic i.e: datapath control signals
always_comb begin
    // by default, make all our signals 0
    R0in = 1'b0; R1in = 1'b0;
    Ain = 1'b0; Rin = 1'b0; IRin = 1'b0;
    select = 2'bxx; 
    ALUOP = 2'bxx;
    done = 1'b0;

    case(current_state)
        C0: IRin = 1'b1;
        C1: begin
            if(II == mv) begin
                if(M) select = 2'b11;
                else select = (rY==0) ? 2'b01:2'b10;

                R0in = (rX == 0);
                R1in = (rX == 1); 
                done = 1'b1;             
            end
            else begin
                select = (rX==0) ? 2'b01:2'b10;
                Ain = 1'b1;
            end
        end
        C2: begin
            Rin = 1'b1;
            if(M) select = 2'b11;
            else select = (rY==0)? 2'b01:2'b10;
            case(II)
                add: ALUOP = 2'b00;
                sub: ALUOP = 2'b01;
                mult: ALUOP = 2'b10;
                default: ALUOP = 2'bxx;
            endcase
        end
        C3: begin
            select = 2'b00;
            R0in = (rX == 0);
            R1in = (rX == 1);
            done = 1'b1;  
        end
    endcase 
end


// control FSM FlipFlop
always_ff @(posedge clk) begin
    if(reset)
        current_state <= C0;
    else
       current_state <= next_state;
end

endmodule




/************************** Datapath **************************************************/
module datapath(
    input logic clk, 
    input logic reset,
    input logic [15:0] INSTRin,
    input logic IRin, R0in, R1in, Ain, Rin,
    input logic [1:0] select, ALUOP,
    output logic [15:0] r0, r1, a, r // for testing purposes these are outputs
);

// datapath implemented using schematic processor-reference.png
logic[15:0] IR, ALUout, MUXout;

always_comb begin
//mux
    case(select)
        2'b00: MUXout = r;
        2'b01: MUXout = r0;
        2'b10: MUXout = r1;
        2'b11: MUXout[15:0] = {INSTRin[11], INSTRin[11], INSTRin[11], INSTRin[11], INSTRin[11:0]};
    endcase
//ALU
    case(ALUOP)
        2'b00: ALUout = a + MUXout;
        2'b01: ALUout = a - MUXout;
        2'b10: ALUout = a * MUXout;
        default: ALUout = a;
    endcase 
end

// FlipFlops
always_ff @(posedge clk) begin
    if(reset) begin
        r <= 0;
        r0 <= 0;
        r1 <= 0;
        a <= 0;
    end
    if(Rin)
        r <= ALUout;
    if (Ain)
        a <= MUXout;
    if (R0in)
        r0 <= MUXout;
    if (R1in)
        r1 <= MUXout;
end

endmodule



/************************** Processor  **************************************************/
module processor(
    input logic [15:0] INSTRin,
    input logic reset, 
    input logic clk,
    input logic run,
    output logic done,
    output logic[15:0] r0_out,r1_out, a_out, r_out
);

// intermediate logic 
logic r0in, r1in, ain, rin, irin;
logic[1:0] select, aluop;

control_path control(
   .clk(clk),
   .reset(reset), 
   .run(run), 
   .INSTRin(INSTRin),
   .R0in(r0in), 
   .R1in(r1in), 
   .Ain(ain), 
   .Rin(rin), 
   .IRin(irin), 
   .select(select), 
   .ALUOP(aluop),
   .done(done)
);

datapath data(
    .clk(clk), 
    .reset(reset),
    .INSTRin(INSTRin),
    .IRin(irin), 
    .R0in(r0in),
    .R1in(r1in), 
    .Ain(ain),
    .Rin(rin),
    .select(select), 
    .ALUOP(aluop),
    .r0(r0_out), 
    .r1(r1_out),
    .a(a_out),
    .r(r_out)
);

endmodule
