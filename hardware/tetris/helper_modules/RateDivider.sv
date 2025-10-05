module RateDivider #(parameter CLOCK_FREQUENCY = 500, parameter OUTPUT_FREQUENCY = 1) (  // enable is the signal that is generated, equal to ClockIn/CLOCK_FREQUENCY
    input logic ClockIn, resetn,
    output logic Enable
);
    localparam RESET_VAL = CLOCK_FREQUENCY/OUTPUT_FREQUENCY - 1; // the amount of memory used is optimized like this, local param b/c doesn't change
    localparam HALF_PERIOD_COUNT = (CLOCK_FREQUENCY / (2 * OUTPUT_FREQUENCY));
    logic [$clog2(CLOCK_FREQUENCY*4)-1:0] count = CLOCK_FREQUENCY;  // max count value is 2^33-1, optimized space

    always_ff @(posedge ClockIn, negedge resetn)  // reset at 0 or when reset is high, otherwise count down
    begin
        if ((!resetn) | (count == 0))
            count <= RESET_VAL;
        else
            count <= count - 1;
    end
    always_ff @(posedge ClockIn, negedge resetn) begin
        if (!resetn) begin
            Enable <= 0;
        end else if (count == HALF_PERIOD_COUNT) begin  // toggle enable at half period
            Enable <= ~Enable;
        end else if (count == 0) begin
            Enable <= 1;
        end // hold otherwise
    end
    
endmodule