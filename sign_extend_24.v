module Sign_Extend_24(SignedIMM, SignExtended);

input [23:0] SignedIMM;
output reg [31:0] SignExtended;


always @(*) begin
if (SignedIMM[23] == 1'b1) // Check the sign bit
SignExtended = {8'b11111111, SignedIMM}; // Sign extend with 1's
else
SignExtended = {8'b00000000, SignedIMM}; // Sign extend with 0's
end

endmodule