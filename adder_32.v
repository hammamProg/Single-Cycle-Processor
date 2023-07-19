module Adder_32(A,B,Sum);

input [31:0] A;
input [31:0] B;
output reg [31:0] Sum;

always @(A, B) begin
Sum = A + B;
end

endmodule