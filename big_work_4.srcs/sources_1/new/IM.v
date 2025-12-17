module IM (
    input [11:2] addr, //###### why [11:2]?

    output [31:0] instr
);

    reg [31:0]RAM[1023:0];// 4KB instruction memory

   // initial $readmemh("code.txt", RAM); // load instructions from code.txt

// #### question ####
    assign instr = RAM[addr[11:2]]; // word aligned
    
endmodule