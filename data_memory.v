module Data_Memory(clk,rst,WE,RE,WD,A,RD);

    input clk,rst,WE,RE;    // Write Enable, Read Enable
    input [31:0]A,WD;       // Address, Write Data
    output reg [31:0]RD;        // Read Data

    reg [31:0] mem [1023:0];

    always @ (posedge clk)
    begin
        if(WE)
            mem[A] <= WD;
        if(RE)
            RD <= mem[A];
    end


endmodule 
