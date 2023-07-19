module Control_Unit_Top(clk,Stop_Bit,Funct_Type,Jump,Branch,MemRead,MemToReg,MemWrite,ALUSrc,RegWrite,Jump_And_Link,Write_data_choose,SP,SP_ADD);
    input clk;
    input Stop_Bit;
    input [6:0]Funct_Type;

    output Jump,Branch,MemRead,MemToReg,MemWrite,RegWrite,Jump_And_Link,SP;
    output [1:0]ALUSrc,SP_ADD,Write_data_choose;
    
	reg Jump,Branch,MemRead,MemToReg,MemWrite,RegWrite,Jump_And_Link,SP;	 
	reg [1:0]ALUSrc,SP_ADD,Write_data_choose;
	
	// Test
	reg controlSignals;

    wire [4:0] last_five_bits;
  	wire [1:0] instructionType;
	// Determine the instruction type based on opcode
	assign instructionType = Funct_Type[6:5];
	assign last_five_bits = Funct_Type[4:0];


  always @(*) begin
    case (instructionType)
      // R-Type Instructions
      2'b00: begin
        Jump = 1'b0;
        Branch = 1'b0;
        MemRead = 1'b0; // Don't care
        MemToReg = 1'b1;
        MemWrite = 1'b0; // Don't care
        ALUSrc = 2'b00;
        RegWrite = 1'b1;
        Jump_And_Link = 1'b0; // Don't care
        Write_data_choose = 2'b00; // Don't care
        SP = 1'b1;
        
		if ( clk && Stop_Bit==1) begin 
			Jump_And_Link = 1'b0;
			SP = 1'b0;
			SP_ADD = 2'b00; 
		end	
		if ( ~(clk) && Stop_Bit==1) begin 
			Jump_And_Link = 1'b0;
			SP = 1'b0;
			SP_ADD = 2'b01; 
		end
        
 	  
      end
      // J-Type Instructions
      2'b01: begin
        case (last_five_bits) 
			// ANDI  -> AND
	          5'b00000: begin 
	            Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0; // Don't care
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; // Don't care
	            ALUSrc = 2'b10;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit	
				
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end	  
		  	// ADDI  -> ADD
	          5'b00001: begin 
			  	Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0; // Don't care
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; // Don't care
	            ALUSrc = 2'b10;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit	 
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end
	          
			  
	          // LW    -> ADD
	          5'b00010: begin 
			  	Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0; // Don't care
	            MemToReg = 1'b0; 
	            MemWrite = 1'b0; // Don't care
	            ALUSrc = 2'b10;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b1;  
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end	
			   // SW    -> ADD
	          5'b00011: begin
			  	Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0; 
	            MemToReg = 1'b0; 
	            MemWrite = 1'b1; 
	            ALUSrc = 2'b10;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b1; 
	            Write_data_choose = 2'b01; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end	 
			  // BEQ   -> CMP & check zero flag
	          5'b00100: begin 
			  	Jump = 1'b0;
	            Branch = 1'b1;
	            MemRead = 1'b0;  
	            MemToReg = 1'b0; 
	            MemWrite = 1'b1; 
	            ALUSrc = 2'b10;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b1;  
	            Write_data_choose = 2'b01;  
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end 
	          //default: Don't Care
	        endcase
      end
      // I-Type Instructions
      2'b10: begin
        case (last_five_bits)
			// J    
          5'b00000: 
		  		begin 
			  	Jump = 1'b1;
	            Branch = 1'b0;  // Don't Care
	            MemRead = 1'b0;  // Don't Care 
	            MemToReg = 1'b0; // Don't Care
	            MemWrite = 1'b0;   // Don't Care
	            ALUSrc = 2'b00;	  // Don't Care
	            RegWrite = 1'b0;  // Don't Care
	            Jump_And_Link = 1'b0;  // Don't Care 
	            Write_data_choose = 2'b00; // Don't Care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  	end
		  // Jal   
          5'b00001:
		  begin
			  
			  if(clk) begin 
			  	Jump = 1'b1;
	            Branch = 1'b0;  // Don't Care
	            MemRead = 1'b0;  
	            MemToReg = 1'b0; // Don't Care
	            MemWrite = 1'b1;  
	            ALUSrc = 2'b00;	  // Don't Care
	            RegWrite = 1'b0;  // Don't Care
	            Jump_And_Link = 1'b0;  
	            Write_data_choose = 2'b00;
	            SP = 1'b1;
				SP_ADD = 2'b00;
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end
				  
			  else begin 
				Jump = 1'b1;
	            Branch = 1'b0;  // Don't Care
	            MemRead = 1'b0;  
	            MemToReg = 1'b0; // Don't Care
	            MemWrite = 1'b1;  
	            ALUSrc = 2'b00;	  // Don't Care
	            RegWrite = 1'b0;  // Don't Care
	            Jump_And_Link = 1'b0;  
	            Write_data_choose = 2'b00;
	            SP = 1'b1;
				SP_ADD = 2'b10;
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
			  end	  
			 			  
		  end
		  	
          default:  controlSignals = 3'b000;
        endcase
      end
      // S-Type Instructions
      2'b11: begin
        case (last_five_bits)
		  // SLL    
          5'b00000: 
		  begin  
		  		Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0;  
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; 
	            ALUSrc = 2'b01;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit	
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
		  end
		  
		  // SLR  -> Controls as SLL    
          5'b00001: 
		  begin 
			  	Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0;  
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; 
	            ALUSrc = 2'b01;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
		  
		  end 
		  
		  // SLLV     
          5'b00010: 
		  begin 
		  		Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0;  
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; 
	            ALUSrc = 2'b11;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
		  end 
		  
		  // SLRV  -> Controls as SLLV   
          5'b00011: 
		  begin 
		  		Jump = 1'b0;
	            Branch = 1'b0;
	            MemRead = 1'b0;  
	            MemToReg = 1'b1; 
	            MemWrite = 1'b0; 
	            ALUSrc = 2'b11;
	            RegWrite = 1'b1;
	            Jump_And_Link = 1'b0; // Don't care
	            Write_data_choose = 2'b00; // Don't care
	            SP = 1'b1; // default till we have Stop_Bit
				if ( clk && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b00; 
				end	
				if ( ~(clk) && Stop_Bit==1) begin 
					Jump_And_Link = 1'b0;
					SP = 1'b0;
					SP_ADD = 2'b01; 
				end
		  end 
		  
          
        endcase
      end
    endcase
  end

  //if Stop_Bit == 1 begin 

  //end


endmodule