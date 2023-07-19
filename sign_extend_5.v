module Sign_Extend_5(SA,SignExtended);

input [4:0] SA;
output reg [31:0] SignExtended;


always @(*) begin
if (SA[4] == 1'b1) // Check the sign bit
SignExtended = {27'b111111111111111111111111111, SA}; // Sign extend with 1's
else
SignExtended = {27'b000000000000000000000000000, SA}; // Sign extend with 0's
end

endmodule