module IM (
    input [31:0] addr, 

    output [31:0] instr
);

    reg [31:0]RAM[1023:0];// 4KB instruction memory

    initial $readmemh("code.txt", RAM); // load instructions from code.txt

// #### question ####
    assign instr = RAM[addr[11:2]]; // word aligned
    
endmodule