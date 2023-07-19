module Alu_Controller(funct,controlSignals);

  input [6:0] funct;
  output reg [2:0] controlSignals;
  
  
    wire [4:0] last_five_bits;
  	wire [1:0] instructionType;
	// Determine the instruction type based on opcode
	assign instructionType = funct[6:5];
	assign last_five_bits = funct[4:0];


  always @(*) begin
    case (instructionType)
      // R-Type Instructions
      2'b00: begin
        case (last_five_bits)  // Use funct instead of opcode for R-Type instructions
          5'b00000: controlSignals = 3'b000; // AND
          5'b00001: controlSignals = 3'b001; // ADD
          5'b00010: controlSignals = 3'b010; // SUB
          5'b00011: controlSignals = 3'b011; // CMP  -> CMP & check zero flag
          default:  controlSignals = 3'b000;
        endcase
      end
      // J-Type Instructions
      2'b01: begin
        case (last_five_bits)
          5'b00000: controlSignals = 3'b000; // ANDI  -> AND
          5'b00001: controlSignals = 3'b001; // ADDI  -> ADD
          5'b00010: controlSignals = 3'b001; // LW    -> ADD
          5'b00011: controlSignals = 3'b001; // SW    -> ADD
          5'b00100: controlSignals = 3'b011; // BEQ   -> CMP & check zero flag
          default:  controlSignals = 3'b000;
        endcase
      end
      // I-Type Instructions
      2'b10: begin
        case (last_five_bits)
          5'b00000: controlSignals = 3'b000; // J     -> Don't care
          5'b00001: controlSignals = 3'b001; // Jal   -> Don't care
          default:  controlSignals = 3'b000;
        endcase
      end
      // S-Type Instructions
      2'b11: begin
        case (last_five_bits)
          5'b00000: controlSignals = 3'b100; // SLL    -> SL
          5'b00001: controlSignals = 3'b101; // SLR    -> SR
          default:  controlSignals = 3'b000;
        endcase
      end
    endcase
  end
endmodule
