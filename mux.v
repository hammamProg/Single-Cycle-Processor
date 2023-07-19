module Mux (a,b,s,c);

    input [31:0]a,b;
    input s;
    output [31:0]c;
    
    // A = 0 , B = 1
    assign c = (~s) ? a : b ;
    
endmodule