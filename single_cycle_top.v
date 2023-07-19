`include "Adder_32.v"
`include "Alu_Controller.v"
`include "ALU.v"
`include "And.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "Instruction_Memory.v"
`include "Mux_3.v"
`include "mux_4.v"
`include "Mux.v"
`include "PC_Adder.v"
`include "PC.v"
`include "Register_File.v"
`include "sheft_left_2.v"
`include "Sign_Extend_5.v"
`include "Sign_Extend_14.v"
`include "Sign_Extend_24.v"
`include "Stack_Pointer.v"

module Single_Cycle_Top(clk,rst);

    input clk,rst;
    
    // PC wires + IM wires
    wire [31:0] PC,PCPlus4,PCin,InstrD;

    // Control Signal Wires
    wire RegWrite;

    // Regsiter File wires 
    wire [31:0] WriteData;
    wire [31:0] RD1,RD2,RDd;
    
    // Sign Extend wires
    wire [31:0] SAExt;
    wire [31:0] ImmExt;
    wire [31:0] SignedImmExt;

    // Shift-Left-2 wires
    wire [31:0] ImmExt_Shift;
    
    // Control Unit wires
    wire Jump,Branch,MemRead,MemToReg,MemWrite,RegWrite_CU,Jump_And_Link,Write_data_choose,SP;
    wire [1:0]ALUSrc,SP_ADD;

    // Jump Address Wires
    wire [31:0] SignedImmExt_Shift;
    wire [31:0] Jump_Address;

    // muxes wires
    // mux PC+4 & ADD2
    wire [31:0] ADD2;
    wire [31:0] Mux_wire_1;
    wire [31:0] PCin_1;


    // And Gate 
    wire [31:0] Branch_check;

    // ALU wires
    wire ZeroFlag;
    wire NegFlag;
    wire [31:0]B;
    wire [2:0]ALUControl;
    wire [31:0] ALUResult;


    // Stack Pointer wires
    wire [31:0] SP_address;
    wire [31:0] NextStackAddress;
    wire [31:0] NextStackMinus4;
    wire [31:0] NextStackPlus4;

    // Data Memory wires
    wire [31:0] Data_Memory_Address;
    wire [31:0] Data_Memory_WriteData;
    wire [31:0] Out_readData;


    // wire [31:0] PC,RD_Instr,RD1_Top,Imm_Ext_Top,ALUResult,ReadData,RD2_Top,SrcB,Result;
    // wire RegWrite,MemWrite,ALUSrc,ResultSrc;
    // wire [1:0]ImmSrc;
    // wire [2:0]ALUControl_Top;

    PC_Module PCModule(
        .clk(clk),
        .rst(rst), 
		.PC_Next(PCin),
        .PC(PC)
    );
    
    PC_Adder PC_Adder(
                    .a(PC),
                    .b(32'd4),
                    .c(PCPlus4)
    );

    Instruction_Memory Instruction_Memory(
                            .rst(rst),
                            .A(PC),
                            .RD(InstrD)
    );

    Regsiter_File RF(
        .clk(clk),
        .rst(rst),
        .regWrite(RegWrite), 
        .rs1(InstrD[26:22]),
        .rs2(InstrD[16:12]), 
        .wr(InstrD[21:17]), 
        .WD(WriteData), 
        .RD1(RD1),
        .RD2(RD2), 
        .RDd(RDd)
        );

    Sign_Extend_5 SE5(
        .SA(InstrD[11:7]),
        .SignExtended(SAExt)
        );

    Sign_Extend_14 SE14(
        .Imm(InstrD[16:3]), 
        .SignExtended(ImmExt)
        );

    Sign_Extend_24 SE24(
        .SignedIMM(InstrD[26:3]), 
        .SignExtended(SignedImmExt)
        );
		
			   
		
    Control_Unit_Top CU( 
		.clk(clk),
		.Stop_Bit(InstrD[0]),
        .Funct_Type({InstrD[2:1] ,InstrD[31:27]}),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite_CU),
        .Jump_And_Link(Jump_And_Link),
        .Write_data_choose(Write_data_choose),
        .SP(SP),
        .SP_ADD(SP_ADD)
        );

    Sheft_Left_2 shift_Signed_Imm(
        .d_in(SignedImmExt), 
        .d_out(SignedImmExt_Shift)
        );

    Sheft_Left_2 shift_Imm(
        .d_in(ImmExt), 
        .d_out(ImmExt_Shift)
        );

    
    Adder_32 JumpAdd(
        .A(SignedImmExt_Shift),
        .B(PCPlus4),
        .Sum(Jump_Address)
        );

    Adder_32 ADD2_Module(
        .A(PCPlus4),
        .B(ImmExt_Shift),
        .Sum(ADD2)
        );

    Mux PCPlus4_ADD2(
        .a(PCPlus4),
        .b(ADD2),
        .s(Branch_check),
        .c(Mux_wire_1)
        );
    Mux Jump_and_Mux_wire_1(
        .a(Mux_wire_1),
        .b(Jump_Address),
        .s(Jump),
        .c(PCin_1)
        );
    
    Mux Out_PCin(
        .a(Out_readData),
        .b(PCin_1),
        .s(SP),
        .c(PCin)
        );
    
    AND_Gate andgate(.A(Branch), .B(ZeroFlag), .Out(Branch_check));

    Mux4 ALU_MUX(
        .a(RD2), 
        .b(SAExt), 
        .c(ImmExt),
        .d(RDd),
        .sel(ALUSrc), 
        .c_out(B)
        );


    Alu_Controller ALU_CTR(
        .funct({InstrD[2:1] ,InstrD[31:27]}),
        .controlSignals(ALUControl)
        );
    // ====================== ALU ======================
    
    ALU ALU(
        .A(RD1),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .ZeroFlag(ZeroFlag),
        .negFlag(NegFlag)
        );
    
    // ====================== Stack Pointer ======================

    Adder_32 NextSP_Minus(
        .A(NextStackAddress),
        .B(32'b11111111111111111111111111111100), // -4 ( computed by 2's complement )
        .Sum(NextStackMinus4)
        );

    Adder_32 NextSP_Plus(
        .A(NextStackAddress),
        .B(32'd4),
        .Sum(NextStackPlus4)
        );

    
    Mux3 ALU_MUX_Module(
        .a(NextStackAddress), 
        .b(NextStackMinus4), 
        .c(NextStackPlus4), 
        .sel(SP_ADD), 
        .c_out(SP_address)
        );

    StackPointer SP_Module(
        .clk(clk),
        .rst(rst),
        .SP_address(SP_address),
        .NextStackAddress(NextStackAddress)
        );
    

    // ====================== Data Memory ======================

    Mux Data_Memory_address(
        .a(NextStackAddress),
        .b(ALUResult),
        .s(Jump_And_Link),
        .c(Data_Memory_Address)
        );
    
    Mux3 Data_Memory_Write_Data(
        .a(PCPlus4), 
        .b(RDd), 
        .c(RD2), 
        .sel(Write_data_choose), 
        .c_out(Data_Memory_WriteData)
        );
    
    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .RE(MemRead),
        .WD(Data_Memory_WriteData),
        .A(Data_Memory_Address),
        .RD(Out_readData)
        );
    
    // ====================== Write Back Mux ======================


    Mux Write_Data_Mux(
        .a(Out_readData),
        .b(ALUResult),
        .s(MemToReg),
        .c(WriteData)
        );
    
endmodule