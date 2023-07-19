module ALU(A,B,ALUControl,ALUResult,ZeroFlag,negFlag);

input reg [31:0] A;
input reg [31:0] B;
input [2:0] ALUControl;
output reg [31:0] ALUResult;
output reg ZeroFlag;
output reg negFlag;


always @(*) begin
case (ALUControl)
// R-Type Instructions
3'b000: assign ALUResult = A & B; // AND operation
3'b001: begin 
        ALUResult = A + B; // ADD operation
        assign negFlag = ((A + B) < 0) ? 1'b1 : 1'b0;
    end 
3'b010: begin
        ALUResult = A - B; // SUB operation
        if ((A-B) < 0)
			assign negFlag = 1'b1;	 
		else
			assign negFlag = 1'b0;
    end

3'b011: assign ZeroFlag = (A < B) ? 1'b1 : 1'b0; // CMP operation

3'b100: assign ALUResult = A << B; // SLL operation
3'b101: assign ALUResult = A >> B; // SLR operation


default: begin
	ALUResult = 32'h00000000; // Default to zero
    ZeroFlag = 1'b0;// Default to zero
    negFlag = 1'b0; // Default to zero
end

endcase


end 
endmodule