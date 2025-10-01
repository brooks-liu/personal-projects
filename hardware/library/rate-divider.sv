module RateDivider #(parameter CLOCK_FREQUENCY = 500) (  // enable is the signal that is generated, equal to ClockIn/CLOCK_FREQUENCY
    input logic ClockIn, Reset,
    input logic[1:0] Speed,
    output logic Enable
);
    logic [$clog2(CLOCK_FREQUENCY*4)-1:0] RateDividerCount;
    logic [$clog2(CLOCK_FREQUENCY*4)-1:0] reset_val;

    always_comb
    begin
        case (Speed)
        2'b00: reset_val = 0;  // same speed as clock
        2'b01: reset_val = CLOCK_FREQUENCY - 1;  // depends on your input CLOCK_FREQUENCY
        2'b10: reset_val = CLOCK_FREQUENCY*2 - 1;  // half of above
        2'b11: reset_val = CLOCK_FREQUENCY*4 - 1;  // quarter of above
        default: reset_val = 0;
        endcase
    end

    always_ff @(posedge ClockIn)  // reset at 0 or when reset is high, otherwise count down
    begin
        if ((Reset == 1) | (RateDividerCount == 0))
            RateDividerCount <= reset_val;
        else
            RateDividerCount <= RateDividerCount - 1;
    end

    always_comb
    begin
    if (!Speed)
        Enable = ClockIn;
    else
        Enable = (RateDividerCount == 'b0)?'1:'0;  // choose 1 when count reaches 0 (enable signal)
    end
endmodule;