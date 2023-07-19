module Regsiter_File(clk,rst,regWrite, rs1,rs2, wr, WD, RD1,RD2, RDd);

    input clk,rst,regWrite;
    input [4:0]rs1,rs2,wr;
    input [31:0]WD;
    output [31:0]RD1,RD2,RDd;

    reg [31:0] Register [31:0];
    

    always @ (posedge clk)
    begin
        if(regWrite)
            Register[wr] <= WD;
    end

    assign RD1 = (rst) ? 32'd0 : Register[rs1];
    assign RD2 = (rst) ? 32'd0 : Register[rs2];
    assign RDd = (rst) ? 32'd0 : Register[wr];


    initial begin
        Register[0] = 32'd5;
        Register[1] = 32'd6;	
		Register[2] = 32'd10;
        
    end

endmodule