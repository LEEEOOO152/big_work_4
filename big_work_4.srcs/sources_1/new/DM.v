// data memory
module DM (
    input clk,
    input [11:2] addr,// from ALU###### why [11:2]?
    input [31:0] W_data,// from GPR R_data_2
    input mem_write,

    output [31:0] R_data // to MUX_3 the last one
);
    reg [31:0] RAM[1023:0]; // 4KB data memory

    // read########
    assign R_data = RAM[addr[11:2]]; // word aligned

    // write##########
    always @(posedge clk) begin
        if (mem_write) begin
            RAM[addr[11:2]] <= W_data; // word aligned
        end
    end
endmodule