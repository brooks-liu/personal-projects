module full_adder(input logic a, b, cin, output logic cout, s);
    assign s = (a ^ b) ^ cin;
	assign cout = (b & ~(a ^ b)) | (c_in & (a ^ b));
endmodule

module RippleCarryAdder(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
    full_adder u1(a[0], b[0], c_in, c_out[0], s[0]);
	full_adder u2(a[1], b[1], c_out[0], c_out[1], s[1]);
	full_adder u3(a[2], b[2], c_out[1], c_out[2], s[2]);
	full_adder u4(a[3], b[3], c_out[2], c_out[3], s[3]);
endmodule