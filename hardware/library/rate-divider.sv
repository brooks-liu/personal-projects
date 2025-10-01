module RateDivider #(parameter CLOCK_FREQUENCY = 500)(
	input logic ClockIn, Reset, Start, 
	input logic [2:0] Letter, 
	output logic DotDashOut, NewBitOut
);
	logic [$clog2(CLOCK_FREQUENCY/2-1):0] counter, counter_start;  // counter to calculate the new pulse
	logic started;  // tracks if start has been "pressed"
	logic [11:0] encoding; 
	logic [3:0] encoding_bit;  // keeps track of the bit of the encoding that is being read

	assign counter_start = CLOCK_FREQUENCY/2;
	
	always_comb  // assign encoding values
	begin
		case(Letter)
			0: encoding = 12'b101110000000;
			1: encoding = 12'b111010101000;
			2: encoding = 12'b111010111010;
			3: encoding = 12'b111010100000;
			4: encoding = 12'b100000000000;
			5: encoding = 12'b101011101000;
			6: encoding = 12'b111011101000;
			7: encoding = 12'b101010100000;
		default: encoding = 12'b000000000000;
		endcase
	end
	
	always_ff @(posedge ClockIn)
	begin
		if (Reset) // don't want values from previous runs
		begin
			started <= 1'b0;
			encoding_bit <= 4'd11;
			DotDashOut <= 1'b0;
			NewBitOut <= 1'b0;
			counter <= counter_start;
		end
		else if (Start) // once it starts, change started to 1, prepare the counters (this works even if you don't reset)
		begin
			started <= 1'b1;
			encoding_bit <= 4'd11;
			NewBitOut <= 1'b0;
			counter <= counter_start;
		end
		else if (started) // only starts running after Start turns to 0
		begin
            if (counter > 0) // counter has not reached zero
			begin
                counter <= counter - 1;
                NewBitOut <= 1'b0; // this is the wanted "pulse" (this will give a very short pulse as it is only 1 for 1 clock cycle)
            end
            else // counter reaches zero, pulse is formed so update all needed values
			begin
                DotDashOut <= encoding[encoding_bit];  // change this on the next pulse
                NewBitOut <= 1'b1;  
                counter <= counter_start;  // resets the counter so it doesn't run negative

                if (encoding_bit > 0)
                    encoding_bit <= encoding_bit - 1;  // increments to the right
                else
                    started <= 1'b0;  // stops the counters and all values, encoding_bit will reset next Start cycle
            end
        end
		else 
		begin
			NewBitOut <= 1'b0; // nothings happening so nothings outputted 
        end
	end
endmodule