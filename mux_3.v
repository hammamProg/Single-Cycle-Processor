module Mux3(a, b, c, sel, c_out);

    input [31:0] a, b, c;
    input [1:0] sel;
    output [31:0] c_out;
	

	assign c_out = (sel==2'b00) ? a : (sel==2'b01) ? b : c;


endmodule