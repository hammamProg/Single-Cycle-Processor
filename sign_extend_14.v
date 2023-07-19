module Sign_Extend_14(Imm, SignExtended);

input [13:0] Imm;
output reg [31:0] SignExtended;


always @(*) begin
if (Imm[13] == 1'b1) // Check the sign bit
SignExtended = {18'b111111111111111111, Imm}; // Sign extend with 1's
else
SignExtended = {18'b000000000000000000, Imm}; // Sign extend with 0's
end

endmodule