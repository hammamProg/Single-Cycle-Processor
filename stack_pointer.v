module StackPointer(clk,rst,SP_address,NextStackAddress);
    input clk,rst;
    input [31:0]SP_address;
    output reg [31:0]NextStackAddress;

    wire [31:0] SP_address;

    always @(posedge clk)
    begin
        if(rst)
            NextStackAddress <= 900;
        else
            NextStackAddress <= SP_address;
    end

    // - Assuume that the First Address of the Stack is 900
    // SP_address = mem[900]
endmodule