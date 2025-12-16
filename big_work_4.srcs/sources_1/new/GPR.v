// general purpose register 
module GPR (
    input reg_write,
    input [4:0] R_addr_1,
    input [4:0] R_addr_2,
    input [4:0] W_addr,
    input [31:0] W_data,

    output [31:0] R_data_1,
    output [31:0] R_data_2
);
    reg [31:0] RAM[31:0]; // 32 registers, each 32 bits

    // read
    assign R_data_1 = RAM[R_addr_1];
    assign R_data_2 = RAM[R_addr_2];

    // write
    always @(*) begin
        if (reg_write && (W_addr != 0)) begin // register 0 is always 0
            RAM[W_addr] = W_data;
        end
    end

    // ######## initialize registers to 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            RAM[i] = 32'b0;
        end
    end
    
endmodule