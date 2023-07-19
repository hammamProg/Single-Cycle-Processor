module Mux4(a, b, c,d, sel, c_out);
									  
    input [31:0] a, b, c,d;
    input [1:0] sel;
    output reg [31:0] c_out;
	
    assign c_out = (sel==2'b00) ? a : (sel==2'b01) ? b : (sel==2'b10) ? c : d;


endmodule